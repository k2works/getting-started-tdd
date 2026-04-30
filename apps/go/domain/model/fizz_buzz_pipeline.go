package model

import "strings"

// Reducer は累積値と要素を受け取り新しい累積値を返す関数型です。
type Reducer func(acc int, v FizzBuzzValue) int

// GroupByValue は値でグルーピングした map を返します。
func (l *FizzBuzzList) GroupByValue() map[string][]FizzBuzzValue {
	result := make(map[string][]FizzBuzzValue)
	for _, v := range l.value {
		result[v.Value()] = append(result[v.Value()], v)
	}
	return result
}

// CountByValue は値ごとの出現回数を返します。
func (l *FizzBuzzList) CountByValue() map[string]int {
	result := make(map[string]int)
	for _, v := range l.value {
		result[v.Value()]++
	}
	return result
}

// Take は先頭から n 件の要素を含む新しいリストを返します。
func (l *FizzBuzzList) Take(n int) *FizzBuzzList {
	if n > len(l.value) {
		n = len(l.value)
	}
	result := make([]FizzBuzzValue, n)
	copy(result, l.value[:n])
	return &FizzBuzzList{value: result}
}

// Join は各要素の文字列表現を区切り文字で結合した文字列を返します。
func (l *FizzBuzzList) Join(sep string) string {
	strs := make([]string, len(l.value))
	for i, v := range l.value {
		strs[i] = v.String()
	}
	return strings.Join(strs, sep)
}

// Reduce は初期値から始めて各要素に関数を適用し、単一の値に畳み込みます。
func (l *FizzBuzzList) Reduce(initial int, fn Reducer) int {
	acc := initial
	for _, v := range l.value {
		acc = fn(acc, v)
	}
	return acc
}
