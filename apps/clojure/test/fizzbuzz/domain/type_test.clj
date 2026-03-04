(ns fizzbuzz.domain.type-test
  (:require [clojure.test :refer :all]
            [fizzbuzz.domain.model :as model]
            [fizzbuzz.domain.type :as type]))

(deftest fizz-buzz-type01-test
  (testing "タイプ 1: 通常の FizzBuzz"
    (let [t (type/->FizzBuzzType01)]
      (is (= "1" (type/generate-string t (model/create-fizz-buzz-value 1))))
      (is (= "2" (type/generate-string t (model/create-fizz-buzz-value 2))))
      (is (= "Fizz" (type/generate-string t (model/create-fizz-buzz-value 3))))
      (is (= "Buzz" (type/generate-string t (model/create-fizz-buzz-value 5))))
      (is (= "FizzBuzz" (type/generate-string t (model/create-fizz-buzz-value 15)))))))

(deftest fizz-buzz-type02-test
  (testing "タイプ 2: 数字のみ"
    (let [t (type/->FizzBuzzType02)]
      (is (= "1" (type/generate-string t (model/create-fizz-buzz-value 1))))
      (is (= "3" (type/generate-string t (model/create-fizz-buzz-value 3))))
      (is (= "5" (type/generate-string t (model/create-fizz-buzz-value 5))))
      (is (= "15" (type/generate-string t (model/create-fizz-buzz-value 15)))))))

(deftest fizz-buzz-type03-test
  (testing "タイプ 3: FizzBuzz の場合のみ"
    (let [t (type/->FizzBuzzType03)]
      (is (= "" (type/generate-string t (model/create-fizz-buzz-value 1))))
      (is (= "Fizz" (type/generate-string t (model/create-fizz-buzz-value 3))))
      (is (= "Buzz" (type/generate-string t (model/create-fizz-buzz-value 5))))
      (is (= "FizzBuzz" (type/generate-string t (model/create-fizz-buzz-value 15)))))))

(deftest fizz-buzz-type-not-defined-test
  (testing "タイプ未定義: 例外を発生させる"
    (let [t (type/->FizzBuzzTypeNotDefined)]
      (is (thrown? clojure.lang.ExceptionInfo
                   (type/generate-string t (model/create-fizz-buzz-value 1)))))))

(deftest create-type-test
  (testing "ファクトリ関数でタイプを生成する"
    (is (instance? fizzbuzz.domain.type.FizzBuzzType01 (type/create-type 1)))
    (is (instance? fizzbuzz.domain.type.FizzBuzzType02 (type/create-type 2)))
    (is (instance? fizzbuzz.domain.type.FizzBuzzType03 (type/create-type 3)))
    (is (instance? fizzbuzz.domain.type.FizzBuzzTypeNotDefined (type/create-type 99)))))
