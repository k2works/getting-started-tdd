package model

import "fmt"

// FizzBuzzValue は FizzBuzz の結果を表す値オブジェクトです。
type FizzBuzzValue struct {
	number int
	value  string
}

// NewFizzBuzzValue は FizzBuzzValue を生成します。
func NewFizzBuzzValue(number int, value string) FizzBuzzValue {
	if number < 0 {
		panic("値は正の値のみ許可します")
	}
	return FizzBuzzValue{number: number, value: value}
}

// TryNewFizzBuzzValue は安全なファクトリです。負の値では error を返します。
func TryNewFizzBuzzValue(number int, value string) (FizzBuzzValue, error) {
	if number < 0 {
		return FizzBuzzValue{}, fmt.Errorf("値は正の値のみ許可します: %d", number)
	}
	return FizzBuzzValue{number: number, value: value}, nil
}

// Number は数値を返します。
func (v FizzBuzzValue) Number() int { return v.number }

// Value は FizzBuzz の変換結果を返します。
func (v FizzBuzzValue) Value() string { return v.value }

// String は fmt.Stringer を実装します。
func (v FizzBuzzValue) String() string { return v.value }

// Equal は 2 つの FizzBuzzValue が等しいかを判定します。
func (v FizzBuzzValue) Equal(other FizzBuzzValue) bool {
	return v.number == other.number && v.value == other.value
}
