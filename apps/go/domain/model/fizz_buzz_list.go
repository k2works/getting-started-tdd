// Package model は FizzBuzz のドメインモデルを提供します。
package model

import (
	"fmt"
	"strings"
)

// MaxCount はリストの上限件数です。
const MaxCount = 100

// FizzBuzzList は FizzBuzzValue のコレクションです。
type FizzBuzzList struct {
	value []FizzBuzzValue
}

// Predicate は FizzBuzzValue を受け取り bool を返す関数型です。
type Predicate func(FizzBuzzValue) bool

// Mapper は FizzBuzzValue を受け取り string を返す関数型です。
type Mapper func(FizzBuzzValue) string

// Reducer は累積値と要素を受け取り新しい累積値を返す関数型です。
type Reducer func(acc int, v FizzBuzzValue) int

// NewFizzBuzzList は FizzBuzzList を生成します。
func NewFizzBuzzList(values []FizzBuzzValue) *FizzBuzzList {
	if len(values) > MaxCount {
		panic(fmt.Sprintf("上限は%d件までです", MaxCount))
	}
	newValues := make([]FizzBuzzValue, len(values))
	copy(newValues, values)
	return &FizzBuzzList{value: newValues}
}

// Value はリスト内の全要素のコピーを返します。
func (l *FizzBuzzList) Value() []FizzBuzzValue {
	result := make([]FizzBuzzValue, len(l.value))
	copy(result, l.value)
	return result
}

// Count はリスト内の要素数を返します。
func (l *FizzBuzzList) Count() int { return len(l.value) }

// ToStringSlice は各要素の文字列表現のスライスを返します。
func (l *FizzBuzzList) ToStringSlice() []string {
	result := make([]string, len(l.value))
	for i, v := range l.value {
		result[i] = v.String()
	}
	return result
}

// Filter は条件に合致する要素だけを含む新しいリストを返します。
func (l *FizzBuzzList) Filter(pred Predicate) *FizzBuzzList {
	result := make([]FizzBuzzValue, 0, len(l.value))
	for _, v := range l.value {
		if pred(v) {
			result = append(result, v)
		}
	}
	return NewFizzBuzzList(result)
}

// Map は各要素に関数を適用した結果のスライスを返します。
func (l *FizzBuzzList) Map(fn Mapper) []string {
	result := make([]string, len(l.value))
	for i, v := range l.value {
		result[i] = fn(v)
	}
	return result
}

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
	switch {
	case n <= 0:
		return NewFizzBuzzList([]FizzBuzzValue{})
	case n >= len(l.value):
		return NewFizzBuzzList(l.value)
	default:
		return NewFizzBuzzList(l.value[:n])
	}
}

// Join は各要素の文字列表現を区切り文字で結合した文字列を返します。
func (l *FizzBuzzList) Join(sep string) string {
	return strings.Join(l.ToStringSlice(), sep)
}

// Reduce は初期値から始めて各要素に関数を適用し、単一の値に畳み込みます。
func (l *FizzBuzzList) Reduce(initial int, fn Reducer) int {
	acc := initial
	for _, v := range l.value {
		acc = fn(acc, v)
	}
	return acc
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
	_, found := l.FindFirst(pred)
	return found
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

// MakeValuePredicate は指定した値と一致するかを判定する述語関数を返します。
func MakeValuePredicate(target string) Predicate {
	return func(v FizzBuzzValue) bool {
		return v.Value() == target
	}
}

// Compose は f を適用した後に g を適用する合成関数を返します。
func Compose(f, g func(int) int) func(int) int {
	return func(n int) int {
		return g(f(n))
	}
}
