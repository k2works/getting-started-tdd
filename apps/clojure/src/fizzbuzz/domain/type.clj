(ns fizzbuzz.domain.type
  (:require [fizzbuzz.domain.model :as model]))

;; ── プロトコル: FizzBuzzType ──────────────────────────────

(defprotocol FizzBuzzType
  "FizzBuzz タイプごとの文字列生成プロトコル"
  (generate-string [this value]
    "FizzBuzzValue から文字列を生成する"))

;; ── タイプ 1: 通常の FizzBuzz ─────────────────────────────

(defrecord FizzBuzzType01 []
  FizzBuzzType
  (generate-string [_this value]
    (let [n (:number value)]
      (cond
        (model/fizz-buzz? n) "FizzBuzz"
        (model/fizz? n) "Fizz"
        (model/buzz? n) "Buzz"
        :else (str n)))))

;; ── タイプ 2: 数字のみ ───────────────────────────────────

(defrecord FizzBuzzType02 []
  FizzBuzzType
  (generate-string [_this value]
    (str (:number value))))

;; ── タイプ 3: FizzBuzz の場合のみ ────────────────────────

(defrecord FizzBuzzType03 []
  FizzBuzzType
  (generate-string [_this value]
    (let [n (:number value)]
      (cond
        (model/fizz-buzz? n) "FizzBuzz"
        (model/fizz? n) "Fizz"
        (model/buzz? n) "Buzz"
        :else ""))))

;; ── タイプ未定義 ─────────────────────────────────────────

(defrecord FizzBuzzTypeNotDefined []
  FizzBuzzType
  (generate-string [_this _value]
    (throw (ex-info "FizzBuzz タイプが未定義です" {:type :not-defined}))))

;; ── ファクトリ関数 ───────────────────────────────────────

(defn create-type
  "タイプ番号から FizzBuzzType インスタンスを生成する"
  [type-num]
  (case type-num
    1 (->FizzBuzzType01)
    2 (->FizzBuzzType02)
    3 (->FizzBuzzType03)
    (->FizzBuzzTypeNotDefined)))
