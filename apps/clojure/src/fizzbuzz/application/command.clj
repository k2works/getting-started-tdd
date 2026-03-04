(ns fizzbuzz.application.command
  (:require [fizzbuzz.domain.model :as model]
            [fizzbuzz.domain.type :as type]))

;; ── プロトコル: FizzBuzzCommand ──────────────────────────

(defprotocol FizzBuzzCommand
  "FizzBuzz コマンドプロトコル"
  (execute [this]
    "コマンドを実行する"))

;; ── 単一値コマンド ───────────────────────────────────────

(defrecord FizzBuzzValueCommand [number type-num]
  FizzBuzzCommand
  (execute [_this]
    (let [fizz-buzz-type (type/create-type type-num)
          value (model/create-fizz-buzz-value number)]
      (type/generate-string fizz-buzz-type value))))

;; ── リストコマンド ───────────────────────────────────────

(defrecord FizzBuzzListCommand [numbers type-num]
  FizzBuzzCommand
  (execute [_this]
    (let [fizz-buzz-type (type/create-type type-num)]
      (->> numbers
           (mapv model/create-fizz-buzz-value)
           (mapv #(type/generate-string fizz-buzz-type %))
           model/create-fizz-buzz-list))))
