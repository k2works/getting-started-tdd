(ns fizzbuzz.core-test
  (:require [clojure.test :refer :all]
            [fizzbuzz.core :refer :all]))

(deftest fizzbuzz-test
  (testing "数を文字列にして返す"
    (testing "1 を渡したら文字列 \"1\" を返す"
      (is (= "1" (fizzbuzz 1))))
    (testing "2 を渡したら文字列 \"2\" を返す"
      (is (= "2" (fizzbuzz 2)))))

  (testing "3 の倍数のときは数の代わりに「Fizz」と返す"
    (testing "3 を渡したら文字列 \"Fizz\" を返す"
      (is (= "Fizz" (fizzbuzz 3)))))

  (testing "5 の倍数のときは「Buzz」と返す"
    (testing "5 を渡したら文字列 \"Buzz\" を返す"
      (is (= "Buzz" (fizzbuzz 5)))))

  (testing "3 と 5 両方の倍数の場合には「FizzBuzz」と返す"
    (testing "15 を渡したら文字列 \"FizzBuzz\" を返す"
      (is (= "FizzBuzz" (fizzbuzz 15))))))

(deftest fizzbuzz-list-test
  (testing "1 から 100 までの FizzBuzz リストを生成する"
    (let [result (fizzbuzz-list 1 100)]
      (is (= 100 (count result)))
      (is (= "1" (first result)))
      (is (= "Buzz" (nth result 99))))))
