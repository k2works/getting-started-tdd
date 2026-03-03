(ns fizzbuzz.application.command-test
  (:require [clojure.test :refer :all]
            [fizzbuzz.application.command :as cmd]))

(deftest fizz-buzz-value-command-test
  (testing "FizzBuzzValueCommand: 単一値コマンド"
    (testing "タイプ 1"
      (is (= "1" (cmd/execute (cmd/->FizzBuzzValueCommand 1 1))))
      (is (= "Fizz" (cmd/execute (cmd/->FizzBuzzValueCommand 3 1))))
      (is (= "Buzz" (cmd/execute (cmd/->FizzBuzzValueCommand 5 1))))
      (is (= "FizzBuzz" (cmd/execute (cmd/->FizzBuzzValueCommand 15 1)))))
    (testing "タイプ 2"
      (is (= "1" (cmd/execute (cmd/->FizzBuzzValueCommand 1 2))))
      (is (= "3" (cmd/execute (cmd/->FizzBuzzValueCommand 3 2)))))
    (testing "タイプ 3"
      (is (= "" (cmd/execute (cmd/->FizzBuzzValueCommand 1 3))))
      (is (= "Fizz" (cmd/execute (cmd/->FizzBuzzValueCommand 3 3)))))))

(deftest fizz-buzz-list-command-test
  (testing "FizzBuzzListCommand: リストコマンド"
    (let [result (cmd/execute (cmd/->FizzBuzzListCommand (range 1 101) 1))]
      (is (= 100 (count (:values result))))
      (is (= "1" (first (:values result))))
      (is (= "Buzz" (last (:values result)))))))

(deftest fizz-buzz-command-error-test
  (testing "未定義タイプでコマンド実行すると例外が発生する"
    (is (thrown? clojure.lang.ExceptionInfo
                 (cmd/execute (cmd/->FizzBuzzValueCommand 1 99))))))
