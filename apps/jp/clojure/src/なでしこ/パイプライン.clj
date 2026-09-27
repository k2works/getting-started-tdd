(ns なでしこ.パイプライン
  "題材 C: パイプライン処理（なでしこ3 の src/pipeline.nako3 に対応）"
  (:require [なでしこ.基本変換 :refer [FizzBuzz変換]]
            [なでしこ.語順 :refer [なでしこ]]))

(defn 装飾
  "文字列を角括弧で囲む。"
  [文字列]
  (str "[" 文字列 "]"))

(defn FizzBuzz装飾
  "なでしこ3 の「NをFizzBuzz変換して装飾して戻す」。"
  [数]
  (なでしこ 数 を FizzBuzz変換 して 装飾))

(defn パイプライン処理
  "1 から 上限 までを FizzBuzz装飾 したベクタを返す。"
  [上限]
  (->> (range 1 (inc 上限))
       (mapv FizzBuzz装飾)))
