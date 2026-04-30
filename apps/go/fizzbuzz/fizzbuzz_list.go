package fizzbuzz

import "fmt"

// MaxCount は FizzBuzzList に格納できる最大件数です。
const MaxCount = 100

// FizzBuzzList は FizzBuzzValue のコレクションです。
type FizzBuzzList struct { //nolint:revive
	value []FizzBuzzValue
}

// NewFizzBuzzList は FizzBuzzList を生成します。
func NewFizzBuzzList(values []FizzBuzzValue) *FizzBuzzList {
	if len(values) > MaxCount {
		panic(fmt.Sprintf("上限は%d件までです", MaxCount))
	}
	newValues := make([]FizzBuzzValue, len(values))
	copy(newValues, values)
	return &FizzBuzzList{value: newValues}
}

// Value は防御的コピーを返します。
func (l *FizzBuzzList) Value() []FizzBuzzValue {
	result := make([]FizzBuzzValue, len(l.value))
	copy(result, l.value)
	return result
}

// Count は要素数を返します。
func (l *FizzBuzzList) Count() int {
	return len(l.value)
}

// ToStringSlice は文字列のスライスを返します。
func (l *FizzBuzzList) ToStringSlice() []string {
	result := make([]string, len(l.value))
	for i, v := range l.value {
		result[i] = v.String()
	}
	return result
}
