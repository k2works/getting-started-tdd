package model

import "testing"

func TestFizzBuzzValue_不変性を確認する(t *testing.T) {
	v1 := NewFizzBuzzValue(3, "Fizz")
	v2 := v1
	if !v1.Equal(v2) {
		t.Fatal("v1 and v2 should be equal")
	}
}

func TestFizzBuzzList_Filterは元のリストを変更しない(t *testing.T) {
	original := NewFizzBuzzList([]FizzBuzzValue{
		NewFizzBuzzValue(1, "1"),
		NewFizzBuzzValue(3, "Fizz"),
		NewFizzBuzzValue(6, "Fizz"),
	})
	originalCount := original.Count()

	isFizz := MakeValuePredicate("Fizz")
	_ = original.Filter(isFizz)

	if original.Count() != originalCount {
		t.Fatal("original list should not be modified")
	}
}

func TestFizzBuzzList_GroupByValue_値でグルーピングする(t *testing.T) {
	list := NewFizzBuzzList([]FizzBuzzValue{
		NewFizzBuzzValue(1, "1"),
		NewFizzBuzzValue(3, "Fizz"),
		NewFizzBuzzValue(5, "Buzz"),
		NewFizzBuzzValue(15, "FizzBuzz"),
	})

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
	list := NewFizzBuzzList([]FizzBuzzValue{
		NewFizzBuzzValue(1, "1"),
		NewFizzBuzzValue(3, "Fizz"),
		NewFizzBuzzValue(5, "Buzz"),
		NewFizzBuzzValue(15, "FizzBuzz"),
	})

	counts := list.CountByValue()

	if counts["FizzBuzz"] != 1 {
		t.Fatalf("FizzBuzz count = %d, want 1", counts["FizzBuzz"])
	}
}

func TestFizzBuzzList_Take_先頭N件を取得する(t *testing.T) {
	list := NewFizzBuzzList([]FizzBuzzValue{
		NewFizzBuzzValue(1, "1"),
		NewFizzBuzzValue(2, "2"),
		NewFizzBuzzValue(3, "Fizz"),
	})

	taken := list.Take(2)

	if taken.Count() != 2 {
		t.Fatalf("Take(2).Count() = %d, want 2", taken.Count())
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
	list := NewFizzBuzzList([]FizzBuzzValue{
		NewFizzBuzzValue(3, "Fizz"),
		NewFizzBuzzValue(6, "Fizz"),
		NewFizzBuzzValue(9, "Fizz"),
		NewFizzBuzzValue(12, "Fizz"),
		NewFizzBuzzValue(15, "FizzBuzz"),
	})

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
