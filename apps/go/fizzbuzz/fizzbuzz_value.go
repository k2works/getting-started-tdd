package fizzbuzz

// FizzBuzzValue は FizzBuzz の結果を表す値オブジェクトです。
type FizzBuzzValue struct { //nolint:revive
	number int
	value  string
}

// NewFizzBuzzValue は FizzBuzzValue を生成します。
func NewFizzBuzzValue(number int, value string) FizzBuzzValue {
	if number < 0 {
		panic("値は正の値のみ許可します")
	}
	return FizzBuzzValue{
		number: number,
		value:  value,
	}
}

// Number は元の数値を返します。
func (v FizzBuzzValue) Number() int {
	return v.number
}

// Value は変換後の文字列を返します。
func (v FizzBuzzValue) Value() string {
	return v.value
}

// Equal は値の等価性を比較します。
func (v FizzBuzzValue) Equal(other FizzBuzzValue) bool {
	return v.number == other.number && v.value == other.value
}

// String は文字列表現を返します。
func (v FizzBuzzValue) String() string {
	return v.value
}
