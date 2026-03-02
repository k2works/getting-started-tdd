package model

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

func (v FizzBuzzValue) Number() int    { return v.number }
func (v FizzBuzzValue) Value() string  { return v.value }
func (v FizzBuzzValue) String() string { return v.value }
func (v FizzBuzzValue) Equal(other FizzBuzzValue) bool {
	return v.number == other.number && v.value == other.value
}
