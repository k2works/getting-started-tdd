package functional

import (
	"testing"

	"github.com/k2works/getting-started-tdd/apps/go/domain/model"
)

func TestGenericMap_FizzBuzzValueを文字列に変換する(t *testing.T) {
	values := []model.FizzBuzzValue{
		model.NewFizzBuzzValue(1, "1"),
		model.NewFizzBuzzValue(3, "Fizz"),
	}

	result := MapSlice(values, func(v model.FizzBuzzValue) string {
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
