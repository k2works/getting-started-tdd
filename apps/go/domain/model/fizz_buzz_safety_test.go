package model

import "testing"

func TestTryNewFizzBuzzValue_正の値で生成できる(t *testing.T) {
	v, err := TryNewFizzBuzzValue(1, "1")
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if v.Number() != 1 {
		t.Fatalf("Number() = %d, want 1", v.Number())
	}
}

func TestTryNewFizzBuzzValue_負の値でエラーを返す(t *testing.T) {
	_, err := TryNewFizzBuzzValue(-1, "-1")
	if err == nil {
		t.Fatal("expected error for negative number")
	}
}

func TestFizzBuzzList_FindFirst_最初のFizzBuzzを見つける(t *testing.T) {
	list := NewFizzBuzzList([]FizzBuzzValue{
		NewFizzBuzzValue(1, "1"),
		NewFizzBuzzValue(15, "FizzBuzz"),
	})

	isFizzBuzz := MakeValuePredicate("FizzBuzz")
	v, found := list.FindFirst(isFizzBuzz)

	if !found {
		t.Fatal("should find FizzBuzz")
	}
	if v.Number() != 15 {
		t.Fatalf("Number() = %d, want 15", v.Number())
	}
}

func TestFizzBuzzList_FindFirst_見つからない場合(t *testing.T) {
	values := []FizzBuzzValue{NewFizzBuzzValue(1, "1")}
	list := NewFizzBuzzList(values)

	isFizzBuzz := MakeValuePredicate("FizzBuzz")
	_, found := list.FindFirst(isFizzBuzz)

	if found {
		t.Fatal("should not find FizzBuzz")
	}
}

func TestFizzBuzzList_AnyMatch_Fizzが存在する(t *testing.T) {
	list := NewFizzBuzzList([]FizzBuzzValue{
		NewFizzBuzzValue(1, "1"),
		NewFizzBuzzValue(3, "Fizz"),
	})

	if !list.AnyMatch(MakeValuePredicate("Fizz")) {
		t.Fatal("should contain Fizz")
	}
}

func TestFizzBuzzList_AllMatch_全て数値ではない(t *testing.T) {
	list := NewFizzBuzzList([]FizzBuzzValue{
		NewFizzBuzzValue(1, "1"),
		NewFizzBuzzValue(3, "Fizz"),
	})

	isNumber := func(v FizzBuzzValue) bool {
		return v.Value() != "Fizz" && v.Value() != "Buzz" && v.Value() != "FizzBuzz"
	}
	if list.AllMatch(isNumber) {
		t.Fatal("not all values should be numbers")
	}
}

func TestGenericMap_FizzBuzzValueを文字列に変換する(t *testing.T) {
	values := []FizzBuzzValue{
		NewFizzBuzzValue(1, "1"),
		NewFizzBuzzValue(3, "Fizz"),
	}

	result := MapSlice(values, func(v FizzBuzzValue) string {
		return v.Value()
	})

	if result[0] != "1" || result[1] != "Fizz" {
		t.Fatalf("MapSlice result = %v", result)
	}
}

func TestGenericFilter_正の値だけを抽出する(t *testing.T) {
	numbers := []int{-2, -1, 0, 1, 2, 3}
	positives := FilterSlice(numbers, func(n int) bool { return n > 0 })

	if len(positives) != 3 {
		t.Fatalf("len(positives) = %d, want 3", len(positives))
	}
}

func TestGenericReduce_合計を計算する(t *testing.T) {
	numbers := []int{1, 2, 3, 4, 5}
	sum := ReduceSlice(numbers, 0, func(acc, n int) int { return acc + n })

	if sum != 15 {
		t.Fatalf("ReduceSlice sum = %d, want 15", sum)
	}
}
