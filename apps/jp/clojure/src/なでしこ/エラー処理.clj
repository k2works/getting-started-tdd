(ns なでしこ.エラー処理
  "題材 D: 安全変換（なでしこ3 の src/error.nako3 に対応）"
  (:require [なでしこ.基本変換 :refer [FizzBuzz変換]]))

(defn- 成功結果 [値]
  {:成功 true :値 値})

(defn- 失敗結果 [メッセージ]
  {:成功 false :エラー メッセージ})

(defn 安全変換
  "数でなければ失敗、0 以下なら失敗、それ以外は FizzBuzz変換 の結果で成功を返す。"
  [値]
  (cond
    (not (number? 値)) (失敗結果 (str "数値を指定してください: " 値))
    (<= 値 0) (失敗結果 (str "正の数を指定してください: " 値))
    :else (成功結果 (FizzBuzz変換 値))))
