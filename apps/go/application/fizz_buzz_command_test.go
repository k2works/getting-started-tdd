package application

import (
	"testing"

	"github.com/k2works/getting-started-tdd/apps/go/domain/model"
	type_ "github.com/k2works/getting-started-tdd/apps/go/domain/type_"
)

func TestFizzBuzzValueCommand_Execute_値を生成する(t *testing.T) {
	fbt := type_.FizzBuzzType01{}
	cmd := NewFizzBuzzValueCommand(3, fbt)
	result := cmd.Execute()
	v, ok := result.(model.FizzBuzzValue)
	if !ok {
		t.Fatal("Execute() should return FizzBuzzValue")
	}
	if v.Value() != "Fizz" {
		t.Fatalf("Value() = %q, want %q", v.Value(), "Fizz")
	}
}

func TestFizzBuzzListCommand_Execute_リストを生成する(t *testing.T) {
	fbt := type_.FizzBuzzType01{}
	cmd := NewFizzBuzzListCommand(fbt, 100)
	result := cmd.Execute()
	list, ok := result.(*model.FizzBuzzList)
	if !ok {
		t.Fatal("Execute() should return *FizzBuzzList")
	}
	if list.Count() != 100 {
		t.Fatalf("Count() = %d, want %d", list.Count(), 100)
	}
}
