package fizzbuzz

import "testing"

func TestNewFizzBuzzValue_正の値で生成できる(t *testing.T) {
	v := NewFizzBuzzValue(1, "1")
	if v.Number() != 1 {
		t.Fatalf("Number() = %d, want %d", v.Number(), 1)
	}
	if v.Value() != "1" {
		t.Fatalf("Value() = %q, want %q", v.Value(), "1")
	}
}

func TestNewFizzBuzzValue_負の値でパニックする(t *testing.T) {
	defer func() {
		if r := recover(); r == nil {
			t.Fatal("NewFizzBuzzValue(-1, \"-1\") should panic")
		}
	}()
	NewFizzBuzzValue(-1, "-1")
}

func TestFizzBuzzValue_Equal_同じ値は等しい(t *testing.T) {
	v1 := NewFizzBuzzValue(1, "1")
	v2 := NewFizzBuzzValue(1, "1")
	if !v1.Equal(v2) {
		t.Fatal("v1.Equal(v2) should be true")
	}
}

func TestFizzBuzzValue_Equal_異なる値は等しくない(t *testing.T) {
	v1 := NewFizzBuzzValue(1, "1")
	v2 := NewFizzBuzzValue(2, "2")
	if v1.Equal(v2) {
		t.Fatal("v1.Equal(v2) should be false")
	}
}

func TestFizzBuzzValue_String_文字列表現を返す(t *testing.T) {
	v := NewFizzBuzzValue(3, "Fizz")
	if v.String() != "Fizz" {
		t.Fatalf("String() = %q, want %q", v.String(), "Fizz")
	}
}
