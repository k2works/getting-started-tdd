package fizzbuzz

import "testing"

func TestFizzBuzzValueCommand_Execute_値を生成する(t *testing.T) {
	fbt := FizzBuzzType01{}
	cmd := NewFizzBuzzValueCommand(3, fbt)
	result := cmd.Execute()
	v, ok := result.(FizzBuzzValue)
	if !ok {
		t.Fatal("Execute() should return FizzBuzzValue")
	}
	if v.Value() != "Fizz" {
		t.Fatalf("Value() = %q, want %q", v.Value(), "Fizz")
	}
}

func TestFizzBuzzListCommand_Execute_リストを生成する(t *testing.T) {
	fbt := FizzBuzzType01{}
	cmd := NewFizzBuzzListCommand(fbt, 100)
	result := cmd.Execute()
	list, ok := result.(*FizzBuzzList)
	if !ok {
		t.Fatal("Execute() should return *FizzBuzzList")
	}
	if list.Count() != 100 {
		t.Fatalf("Count() = %d, want %d", list.Count(), 100)
	}
}
