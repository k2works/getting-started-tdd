package model

import "fmt"

// MaxCount はリストの上限件数です。
const MaxCount = 100

// FizzBuzzList は FizzBuzzValue のコレクションです。
type FizzBuzzList struct {
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

func (l *FizzBuzzList) Value() []FizzBuzzValue {
	result := make([]FizzBuzzValue, len(l.value))
	copy(result, l.value)
	return result
}

func (l *FizzBuzzList) Count() int { return len(l.value) }

func (l *FizzBuzzList) ToStringSlice() []string {
	result := make([]string, len(l.value))
	for i, v := range l.value {
		result[i] = v.String()
	}
	return result
}
