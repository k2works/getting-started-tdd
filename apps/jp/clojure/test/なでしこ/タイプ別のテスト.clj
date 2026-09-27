(ns なでしこ.タイプ別のテスト
  "題材 B: タイプ生成（なでしこ3 の test/type_test.nako3 に対応）"
  (:require [clojure.test :refer [deftest is testing]]
            [なでしこ.タイプ別 :refer [タイプ変換 タイプ生成]]))

(deftest タイプ生成のテスト
  (testing "タイプ1は通常の変換をする"
    (let [通常 (タイプ生成 1)]
      (is (= "Fizz" (タイプ変換 通常 3)))
      (is (= "通常" (:名前 通常)))))
  (testing "タイプ2は数字だけを返す"
    (let [数字 (タイプ生成 2)]
      (is (= "3" (タイプ変換 数字 3)))
      (is (= "数字限定" (:名前 数字)))))
  (testing "タイプ3は15の倍数だけFizzBuzzを返す"
    (is (= "FizzBuzz" (タイプ変換 (タイプ生成 3) 15))))
  (testing "タイプ3は3の倍数を数字で返す"
    (is (= "3" (タイプ変換 (タイプ生成 3) 3))))
  (testing "存在しないタイプはエラーになる"
    (is (thrown-with-msg? clojure.lang.ExceptionInfo
                          #"^該当するタイプは存在しません: 4$"
                          (タイプ生成 4)))))
