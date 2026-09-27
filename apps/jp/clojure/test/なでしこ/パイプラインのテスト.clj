(ns なでしこ.パイプラインのテスト
  "題材 C: パイプライン（なでしこ3 の test/pipeline_test.nako3 に対応）"
  (:require [clojure.test :refer [deftest is testing]]
            [なでしこ.パイプライン :refer [FizzBuzz装飾 パイプライン処理 装飾]]))

(deftest パイプラインのテスト
  (testing "装飾すると角括弧で囲む"
    (is (= "[Fizz]" (装飾 "Fizz"))))
  (testing "変換してから装飾する"
    (is (= "[FizzBuzz]" (FizzBuzz装飾 15))))
  (testing "5までのパイプライン処理"
    (is (= ["[1]" "[2]" "[Fizz]" "[4]" "[Buzz]"] (パイプライン処理 5)))))
