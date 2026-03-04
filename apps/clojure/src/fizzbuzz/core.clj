(ns fizzbuzz.core
  (:gen-class))

(defn fizzbuzz
  "数値を FizzBuzz 文字列に変換する"
  [n]
  (cond
    (and (zero? (mod n 3)) (zero? (mod n 5))) "FizzBuzz"
    (zero? (mod n 3)) "Fizz"
    (zero? (mod n 5)) "Buzz"
    :else (str n)))

(defn fizzbuzz-list
  "start から end までの FizzBuzz リストを生成する"
  [start end]
  (mapv fizzbuzz (range start (inc end))))

(defn print-fizzbuzz
  "start から end までの FizzBuzz を出力する"
  [start end]
  (doseq [item (fizzbuzz-list start end)]
    (println item)))

(defn -main
  "メインエントリーポイント"
  [& _args]
  (print-fizzbuzz 1 100))
