(ns fizzbuzz.domain.model)

;; ── 値オブジェクト: FizzBuzzValue ──────────────────────────

(defrecord FizzBuzzValue [number value])

(defn fizz?
  "3 の倍数かどうかを判定する"
  [n]
  (zero? (mod n 3)))

(defn buzz?
  "5 の倍数かどうかを判定する"
  [n]
  (zero? (mod n 5)))

(defn fizz-buzz?
  "3 と 5 両方の倍数かどうかを判定する"
  [n]
  (and (fizz? n) (buzz? n)))

(defn create-fizz-buzz-value
  "数値から FizzBuzzValue を生成する"
  [n]
  (->FizzBuzzValue n (str n)))

;; ── コレクションオブジェクト: FizzBuzzList ──────────────────

(defrecord FizzBuzzList [values])

(defn create-fizz-buzz-list
  "FizzBuzzValue のベクタから FizzBuzzList を生成する"
  [values]
  (->FizzBuzzList values))
