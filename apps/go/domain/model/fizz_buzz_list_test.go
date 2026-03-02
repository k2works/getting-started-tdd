package model

import (
	"strconv"
	"strings"
	"testing"
)

func TestNewFizzBuzzList_スライスからリストを生成する(t *testing.T) {
	values := []FizzBuzzValue{
		NewFizzBuzzValue(1, "1"),
		NewFizzBuzzValue(2, "2"),
	}
	list := NewFizzBuzzList(values)
	if list.Count() != 2 {
		t.Fatalf("Count() = %d, want %d", list.Count(), 2)
	}
}

func TestNewFizzBuzzList_上限を超えるとパニックする(t *testing.T) {
	defer func() {
		if r := recover(); r == nil {
			t.Fatal("should panic when exceeding MaxCount")
		}
	}()
	values := make([]FizzBuzzValue, 101)
	for i := range values {
		values[i] = NewFizzBuzzValue(i, strconv.Itoa(i))
	}
	NewFizzBuzzList(values)
}

func TestFizzBuzzList_Value_防御的コピーを返す(t *testing.T) {
	values := []FizzBuzzValue{NewFizzBuzzValue(1, "1")}
	list := NewFizzBuzzList(values)
	got := list.Value()
	got[0] = NewFizzBuzzValue(99, "99")
	if list.Value()[0].Number() != 1 {
		t.Fatal("internal state should not be modified")
	}
}

func TestFizzBuzzList_ToStringSlice_文字列スライスを返す(t *testing.T) {
	values := []FizzBuzzValue{
		NewFizzBuzzValue(1, "1"),
		NewFizzBuzzValue(3, "Fizz"),
	}
	list := NewFizzBuzzList(values)
	got := list.ToStringSlice()
	if got[0] != "1" || got[1] != "Fizz" {
		t.Fatalf("ToStringSlice() = %v", got)
	}
}

func TestPredicate_Fizzを判定する(t *testing.T) {
	isFizz := func(v FizzBuzzValue) bool { return v.Value() == "Fizz" }

	v := NewFizzBuzzValue(3, "Fizz")
	if !isFizz(v) {
		t.Fatal("isFizz should return true for Fizz")
	}
}

func TestFizzBuzzList_Filter_Fizzだけを抽出する(t *testing.T) {
	list := newType01List(15)
	isFizz := func(v FizzBuzzValue) bool { return v.Value() == "Fizz" }

	filtered := list.Filter(isFizz)

	for _, v := range filtered.Value() {
		if v.Value() != "Fizz" {
			t.Fatalf("expected Fizz, got %q", v.Value())
		}
	}
}

func TestMakeValuePredicate_指定した値と一致する述語を返す(t *testing.T) {
	isFizz := MakeValuePredicate("Fizz")
	isBuzz := MakeValuePredicate("Buzz")

	v := NewFizzBuzzValue(3, "Fizz")
	if !isFizz(v) {
		t.Fatal("isFizz should return true")
	}
	if isBuzz(v) {
		t.Fatal("isBuzz should return false for Fizz")
	}
}

func TestFizzBuzzList_Map_値を変換する(t *testing.T) {
	values := []FizzBuzzValue{
		NewFizzBuzzValue(1, "1"),
		NewFizzBuzzValue(3, "Fizz"),
	}
	list := NewFizzBuzzList(values)

	toUpper := func(v FizzBuzzValue) string {
		return strings.ToUpper(v.Value())
	}
	got := list.Map(toUpper)

	if got[0] != "1" || got[1] != "FIZZ" {
		t.Fatalf("Map result = %v", got)
	}
}

func TestCompose_2つの関数を合成する(t *testing.T) {
	double := func(n int) int { return n * 2 }
	addOne := func(n int) int { return n + 1 }

	doubleThenAddOne := Compose(double, addOne)

	got := doubleThenAddOne(5)
	if got != 11 {
		t.Fatalf("Compose(double, addOne)(5) = %d, want 11", got)
	}
}

func TestFizzBuzzList_FilterとMapを組み合わせる(t *testing.T) {
	list := newType01List(15)
	isFizz := MakeValuePredicate("Fizz")
	getValue := func(v FizzBuzzValue) string { return v.Value() }

	result := list.Filter(isFizz).Map(getValue)

	for _, s := range result {
		if s != "Fizz" {
			t.Fatalf("expected Fizz, got %q", s)
		}
	}
}

func TestFizzBuzzList_Filterは元のリストを変更しない(t *testing.T) {
	original := newType01List(15)
	originalCount := original.Count()

	_ = original.Filter(MakeValuePredicate("Fizz"))

	if original.Count() != originalCount {
		t.Fatal("original list should not be modified")
	}
}

func TestFizzBuzzList_GroupByValue_値でグルーピングする(t *testing.T) {
	list := newType01List(15)

	grouped := list.GroupByValue()

	if _, ok := grouped["Fizz"]; !ok {
		t.Fatal("grouped should contain 'Fizz' key")
	}
	if _, ok := grouped["Buzz"]; !ok {
		t.Fatal("grouped should contain 'Buzz' key")
	}
	if _, ok := grouped["FizzBuzz"]; !ok {
		t.Fatal("grouped should contain 'FizzBuzz' key")
	}
}

func TestFizzBuzzList_CountByValue_値ごとの出現回数を数える(t *testing.T) {
	list := newType01List(15)

	counts := list.CountByValue()

	if counts["FizzBuzz"] != 1 {
		t.Fatalf("FizzBuzz count = %d, want 1", counts["FizzBuzz"])
	}
}

func TestFizzBuzzList_Take_先頭N件を取得する(t *testing.T) {
	list := newType01List(15)

	taken := list.Take(5)

	if taken.Count() != 5 {
		t.Fatalf("Take(5).Count() = %d, want 5", taken.Count())
	}
}

func TestFizzBuzzList_Join_要素を文字列で結合する(t *testing.T) {
	values := []FizzBuzzValue{
		NewFizzBuzzValue(1, "1"),
		NewFizzBuzzValue(2, "2"),
		NewFizzBuzzValue(3, "Fizz"),
	}
	list := NewFizzBuzzList(values)

	got := list.Join(", ")

	if got != "1, 2, Fizz" {
		t.Fatalf("Join(', ') = %q, want %q", got, "1, 2, Fizz")
	}
}

func TestFizzBuzzList_メソッドチェーンでパイプラインを構築する(t *testing.T) {
	list := newType01List(100)

	result := list.
		Filter(MakeValuePredicate("Fizz")).
		Take(3).
		Join(", ")

	if result != "Fizz, Fizz, Fizz" {
		t.Fatalf("pipeline result = %q, want %q", result, "Fizz, Fizz, Fizz")
	}
}

func TestFizzBuzzList_Reduce_数値の合計を計算する(t *testing.T) {
	values := []FizzBuzzValue{
		NewFizzBuzzValue(1, "1"),
		NewFizzBuzzValue(2, "2"),
		NewFizzBuzzValue(3, "Fizz"),
	}
	list := NewFizzBuzzList(values)

	sum := list.Reduce(0, func(acc int, v FizzBuzzValue) int {
		return acc + v.Number()
	})

	if sum != 6 {
		t.Fatalf("Reduce sum = %d, want 6", sum)
	}
}

func TestFizzBuzzList_FindFirst_最初のFizzBuzzを見つける(t *testing.T) {
	list := newType01List(100)

	v, found := list.FindFirst(MakeValuePredicate("FizzBuzz"))
	if !found {
		t.Fatal("should find FizzBuzz")
	}
	if v.Number() != 15 {
		t.Fatalf("Number() = %d, want 15", v.Number())
	}
}

func TestFizzBuzzList_FindFirst_見つからない場合(t *testing.T) {
	list := NewFizzBuzzList([]FizzBuzzValue{NewFizzBuzzValue(1, "1")})

	_, found := list.FindFirst(MakeValuePredicate("FizzBuzz"))
	if found {
		t.Fatal("should not find FizzBuzz")
	}
}

func TestFizzBuzzList_AnyMatch_Fizzが存在する(t *testing.T) {
	list := newType01List(15)
	if !list.AnyMatch(MakeValuePredicate("Fizz")) {
		t.Fatal("should contain Fizz")
	}
}

func TestFizzBuzzList_AllMatch_全て数値ではない(t *testing.T) {
	list := newType01List(15)
	isNumber := func(v FizzBuzzValue) bool {
		return v.Value() != "Fizz" && v.Value() != "Buzz" && v.Value() != "FizzBuzz"
	}
	if list.AllMatch(isNumber) {
		t.Fatal("not all values should be numbers")
	}
}

func newType01List(count int) *FizzBuzzList {
	values := make([]FizzBuzzValue, count)
	for i := 1; i <= count; i++ {
		value := strconv.Itoa(i)
		switch {
		case i%15 == 0:
			value = "FizzBuzz"
		case i%3 == 0:
			value = "Fizz"
		case i%5 == 0:
			value = "Buzz"
		}
		values[i-1] = NewFizzBuzzValue(i, value)
	}
	return NewFizzBuzzList(values)
}
