(ns なでしこ.タイプ別
  "題材 B: タイプ別の変換（なでしこ3 の src/type.nako3 に対応）"
  (:require [なでしこ.基本変換 :refer [FizzBuzz変換]]))

(defprotocol 変換できる
  (変換する [タイプ 数] "タイプに応じて数を文字列に変換する。"))

(defrecord タイプ [名前 変換]
  変換できる
  (変換する [_ 数] (変換 数)))

(defn- 数字限定変換 [数]
  (str 数))

(defn- FizzBuzz限定変換 [数]
  (if (zero? (mod 数 15)) "FizzBuzz" (str 数)))

(def ^:private タイプ一覧
  {1 (->タイプ "通常" FizzBuzz変換)
   2 (->タイプ "数字限定" 数字限定変換)
   3 (->タイプ "FizzBuzz限定" FizzBuzz限定変換)})

(defn タイプ生成
  "番号からタイプを作る。存在しない番号は ex-info を投げる。"
  [番号]
  (or (get タイプ一覧 番号)
      (throw (ex-info (str "該当するタイプは存在しません: " 番号) {:番号 番号}))))

(defn タイプ変換
  "タイプの変換を数に適用する。"
  [タイプ 数]
  (変換する タイプ 数))
