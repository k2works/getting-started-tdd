(ns なでしこ.エラー処理のテスト
  "題材 D: 安全変換（なでしこ3 の test/error_test.nako3 に対応）"
  (:require [clojure.test :refer [deftest is testing]]
            [なでしこ.エラー処理 :refer [安全変換]]))

(deftest 安全変換のテスト
  (testing "正の数は成功になる"
    (is (= {:成功 true :値 "Fizz"} (安全変換 3))))
  (testing "0は失敗になる"
    (is (= {:成功 false :エラー "正の数を指定してください: 0"} (安全変換 0))))
  (testing "数値でなければ失敗になる"
    (is (= {:成功 false :エラー "数値を指定してください: a"} (安全変換 "a")))))
