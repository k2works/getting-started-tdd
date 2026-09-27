(ns なでしこ.基本変換
  "題材 A: FizzBuzz の基本変換（なでしこ3 の src/fizzbuzz.nako3 に対応）")

(defn FizzBuzz変換
  "15 の倍数で FizzBuzz、3 の倍数で Fizz、5 の倍数で Buzz、それ以外は数の文字列を返す。"
  [数]
  (cond
    (zero? (mod 数 15)) "FizzBuzz"
    (zero? (mod 数 3)) "Fizz"
    (zero? (mod 数 5)) "Buzz"
    :else (str 数)))

(defn FizzBuzz配列作成
  "1 から 上限 までを FizzBuzz変換 したベクタを返す。"
  [上限]
  (mapv FizzBuzz変換 (range 1 (inc 上限))))
