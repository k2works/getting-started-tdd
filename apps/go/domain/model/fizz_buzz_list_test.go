package model

import (
	"strconv"
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
			t.Fatal("should panic when exceeding MAX_COUNT")
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
