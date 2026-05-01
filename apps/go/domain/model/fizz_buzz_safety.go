package model

import "fmt"

// TryNewFizzBuzzValue は安全なファクトリです。負の値では error を返します。
func TryNewFizzBuzzValue(number int, value string) (FizzBuzzValue, error) {
	if number < 0 {
		return FizzBuzzValue{}, fmt.Errorf("値は正の値のみ許可します: %d", number)
	}
	return FizzBuzzValue{number: number, value: value}, nil
}

// FindFirst は条件に合致する最初の要素を返します。
// 見つからない場合は found が false になります。
func (l *FizzBuzzList) FindFirst(pred Predicate) (FizzBuzzValue, bool) {
	for _, v := range l.value {
		if pred(v) {
			return v, true
		}
	}
	return FizzBuzzValue{}, false
}

// AnyMatch は条件に合致する要素が 1 つでもあれば true を返します。
func (l *FizzBuzzList) AnyMatch(pred Predicate) bool {
	for _, v := range l.value {
		if pred(v) {
			return true
		}
	}
	return false
}

// AllMatch は全要素が条件に合致すれば true を返します。
func (l *FizzBuzzList) AllMatch(pred Predicate) bool {
	for _, v := range l.value {
		if !pred(v) {
			return false
		}
	}
	return true
}

// MapSlice は任意の型のスライスに関数を適用し、変換結果のスライスを返します。
func MapSlice[T any, R any](slice []T, fn func(T) R) []R {
	result := make([]R, len(slice))
	for i, v := range slice {
		result[i] = fn(v)
	}
	return result
}

// FilterSlice は条件に合致する要素だけを含む新しいスライスを返します。
func FilterSlice[T any](slice []T, pred func(T) bool) []T {
	var result []T
	for _, v := range slice {
		if pred(v) {
			result = append(result, v)
		}
	}
	return result
}

// ReduceSlice は初期値から始めて各要素に関数を適用し、単一の値に畳み込みます。
func ReduceSlice[T any, R any](slice []T, initial R, fn func(R, T) R) R {
	acc := initial
	for _, v := range slice {
		acc = fn(acc, v)
	}
	return acc
}
