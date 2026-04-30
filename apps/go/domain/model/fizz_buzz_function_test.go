package model

import (
	"strings"
	"testing"
)

func TestPredicate_Fizzを判定する(t *testing.T) {
	isFizz := func(v FizzBuzzValue) bool {
		return v.Value() == "Fizz"
	}

	v := NewFizzBuzzValue(3, "Fizz")
	if !isFizz(v) {
		t.Fatal("isFizz should return true for Fizz")
	}
}

func TestFizzBuzzList_Filter_Fizzだけを抽出する(t *testing.T) {
	list := NewFizzBuzzList([]FizzBuzzValue{
		NewFizzBuzzValue(1, "1"),
		NewFizzBuzzValue(3, "Fizz"),
		NewFizzBuzzValue(5, "Buzz"),
		NewFizzBuzzValue(6, "Fizz"),
	})

	isFizz := func(v FizzBuzzValue) bool {
		return v.Value() == "Fizz"
	}
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
	list := NewFizzBuzzList([]FizzBuzzValue{
		NewFizzBuzzValue(1, "1"),
		NewFizzBuzzValue(3, "Fizz"),
		NewFizzBuzzValue(5, "Buzz"),
		NewFizzBuzzValue(6, "Fizz"),
		NewFizzBuzzValue(15, "FizzBuzz"),
	})

	isFizz := MakeValuePredicate("Fizz")
	getValue := func(v FizzBuzzValue) string { return v.Value() }

	result := list.Filter(isFizz).Map(getValue)

	for _, s := range result {
		if s != "Fizz" {
			t.Fatalf("expected Fizz, got %q", s)
		}
	}
}
