(ns complexity-checker
  "Clojure 関数の循環複雑度を計測するツール。

  循環複雑度の計算ルール:
    基本複雑度 = 1
    +1: cond の各分岐（:else 除く）
    +1: if, if-let, if-not, if-some
    +1: when, when-let, when-not, when-some, when-first
    +1: case の各分岐（デフォルト除く）
    +1: and, or（短絡評価による分岐）
    +1: loop（再帰ループ）
    +1: try（例外処理）"
  (:require [clojure.java.io :as io]
            [clojure.string :as str]))

;; ── 複雑度を上げるフォーム ──────────────────────────────
(def ^:private branching-forms
  #{'if 'if-let 'if-not 'if-some
    'when 'when-let 'when-not 'when-some 'when-first
    'and 'or 'loop 'try})

(defn- count-cond-branches
  "cond フォーム内の分岐数を数える（:else を除く）"
  [form]
  (let [pairs (partition 2 (rest form))]
    (count (filter #(not= :else (first %)) pairs))))

(defn- count-case-branches
  "case フォーム内の分岐数を数える（デフォルト除く）"
  [form]
  (let [clauses (drop 2 form)]
    (max 0 (dec (quot (count clauses) 2)))))

(defn- complexity-of-form
  "S 式を再帰的に走査して循環複雑度を計算する"
  [form]
  (cond
    (not (sequential? form)) 0
    (empty? form) 0
    :else
    (let [head (first form)
          children-complexity (reduce + (map complexity-of-form (rest form)))]
      (+ children-complexity
         (cond
           (= head 'cond) (count-cond-branches form)
           (= head 'case) (count-case-branches form)
           (= head 'condp) (count-case-branches form)
           (contains? branching-forms head) 1
           :else 0)))))

(defn- extract-defn-forms
  "ファイルからすべての defn/defn- フォームを抽出する"
  [^java.io.File file]
  (try
    (let [content (slurp file)
          reader (java.io.PushbackReader. (java.io.StringReader. content))]
      (loop [forms []]
        (let [form (try (read reader) (catch Exception _ ::eof))]
          (if (= form ::eof)
            forms
            (recur (if (and (sequential? form)
                           (contains? #{'defn 'defn-} (first form)))
                     (conj forms form)
                     forms))))))
    (catch Exception e
      (binding [*out* *err*]
        (println (str "警告: " (.getPath file) " の読み込みに失敗: " (.getMessage e))))
      [])))

(defn- fn-name
  "defn フォームから関数名を取得する"
  [form]
  (second form))

(defn- fn-complexity
  "defn フォームの循環複雑度を計算する（基本複雑度 1 + 分岐数）"
  [form]
  (inc (complexity-of-form form)))

(defn- analyze-file
  "ファイル内の全関数の循環複雑度を分析する"
  [^java.io.File file]
  (for [form (extract-defn-forms file)]
    {:file (.getPath file)
     :name (str (fn-name form))
     :complexity (fn-complexity form)}))

(defn- find-clj-files
  "指定パス配下の .clj ファイルを再帰的に探索する"
  [paths]
  (->> paths
       (mapcat #(file-seq (io/file %)))
       (filter #(str/ends-with? (.getName ^java.io.File %) ".clj"))
       (filter #(.isFile ^java.io.File %))))

(defn check-complexity
  "循環複雑度のチェックを実行する"
  [& {:keys [threshold paths]
      :or {threshold 7 paths ["src"]}}]
  (let [files (find-clj-files paths)
        results (mapcat analyze-file files)
        violations (filter #(> (:complexity %) threshold) results)]

    (println (str "=== Clojure 循環複雑度チェック (閾値: " threshold ") ==="))
    (println)

    (doseq [r (sort-by :complexity > results)]
      (let [marker (if (> (:complexity r) threshold) "!!" "ok")]
        (println (format "  [%s] %-40s 複雑度: %d"
                         marker
                         (str (:name r) " (" (.getName ^java.io.File (io/file (:file r))) ")")
                         (:complexity r)))))

    (println)
    (println (format "関数数: %d, 違反: %d" (count results) (count violations)))

    (when (seq violations)
      (println)
      (println "以下の関数が閾値を超えています:")
      (doseq [v violations]
        (println (format "  - %s (%s): 複雑度 %d > %d"
                         (:name v) (:file v) (:complexity v) threshold))))

    (if (seq violations)
      (do (println "\n複雑度チェック: 失敗")
          (System/exit 1))
      (println "\n複雑度チェック: 成功"))))

(defn -main
  "エントリーポイント"
  [& args]
  (let [threshold (if (and (seq args) (re-matches #"\d+" (first args)))
                    (Integer/parseInt (first args))
                    7)]
    (check-complexity :threshold threshold)))
