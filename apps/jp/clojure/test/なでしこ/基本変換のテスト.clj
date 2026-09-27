(ns なでしこ.基本変換のテスト
  "題材 A: FizzBuzz 変換（なでしこ3 の test/fizzbuzz_test.nako3 に対応）"
  (:require [clojure.string :as 文字列]
            [clojure.test :refer [deftest is testing]]
            [なでしこ.基本変換 :refer [FizzBuzz変換 FizzBuzz配列作成]]
            [なでしこ.語順 :refer [なでしこ]]))

(deftest FizzBuzz変換のテスト
  (testing "3を渡したらFizzを返す"
    (is (= "Fizz" (FizzBuzz変換 3))))
  (testing "5を渡したらBuzzを返す"
    (is (= "Buzz" (FizzBuzz変換 5))))
  (testing "15を渡したらFizzBuzzを返す"
    (is (= "FizzBuzz" (FizzBuzz変換 15))))
  (testing "1を渡したら文字列1を返す"
    (is (= "1" (FizzBuzz変換 1))))
  (testing "2を渡したら文字列2を返す"
    (is (= "2" (FizzBuzz変換 2)))))

(deftest FizzBuzz配列作成のテスト
  (testing "15まで作ると15件になる"
    (is (= 15 (count (FizzBuzz配列作成 15)))))
  (testing "15まで作った配列の並び"
    (is (= "1,2,Fizz,4,Buzz,Fizz,7,8,Fizz,Buzz,11,Fizz,13,14,FizzBuzz"
           (文字列/join "," (FizzBuzz配列作成 15))))))

(deftest 語順のテスト
  (testing "3を FizzBuzz変換 の順で書ける"
    (is (= "Fizz" (なでしこ 3 を FizzBuzz変換))))
  (testing "スレッディングマクロでも値が先に来る"
    (is (= "Fizz" (-> 3 FizzBuzz変換)))))
