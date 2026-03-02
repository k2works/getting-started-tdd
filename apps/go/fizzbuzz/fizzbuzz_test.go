package fizzbuzz

import (
	"bytes"
	"strings"
	"testing"
)

// TODO リスト（章 1-3）
/*
- [x] 数を文字列にして返す
  - [x] 1 を渡したら文字列 "1" を返す
  - [x] 2 を渡したら文字列 "2" を返す
- [x] 3 の倍数のときは "Fizz" を返す
- [x] 5 の倍数のときは "Buzz" を返す
- [x] 3 と 5 両方の倍数のときは "FizzBuzz" を返す
- [x] 1 から 100 までの数
- [x] プリントする
*/

func assertGenerate(t *testing.T, input int, want string) {
	t.Helper()
	got := Generate(input)
	if got != want {
		t.Fatalf("Generate(%d) = %q, want %q", input, got, want)
	}
}

func TestGenerate_1を渡したら文字列1を返す(t *testing.T) {
	assertGenerate(t, 1, "1")
}

func TestGenerate_2を渡したら文字列2を返す(t *testing.T) {
	assertGenerate(t, 2, "2")
}

func TestGenerate_3を渡したらFizzを返す(t *testing.T) {
	assertGenerate(t, 3, "Fizz")
}

func TestGenerate_6を渡したらFizzを返す(t *testing.T) {
	assertGenerate(t, 6, "Fizz")
}

func TestGenerate_5を渡したらBuzzを返す(t *testing.T) {
	assertGenerate(t, 5, "Buzz")
}

func TestGenerate_10を渡したらBuzzを返す(t *testing.T) {
	assertGenerate(t, 10, "Buzz")
}

func TestGenerate_15を渡したらFizzBuzzを返す(t *testing.T) {
	assertGenerate(t, 15, "FizzBuzz")
}

func TestGenerateList_1から100までのFizzBuzzを返す(t *testing.T) {
	got := GenerateList(1, 100)

	if len(got) != 100 {
		t.Fatalf("len(GenerateList(1,100)) = %d, want 100", len(got))
	}
	if got[0] != "1" {
		t.Errorf("got[0] = %q, want %q", got[0], "1")
	}
	if got[2] != "Fizz" {
		t.Errorf("got[2] = %q, want %q", got[2], "Fizz")
	}
	if got[4] != "Buzz" {
		t.Errorf("got[4] = %q, want %q", got[4], "Buzz")
	}
	if got[14] != "FizzBuzz" {
		t.Errorf("got[14] = %q, want %q", got[14], "FizzBuzz")
	}
}

func TestPrint_FizzBuzzの結果を出力する(t *testing.T) {
	var buf bytes.Buffer
	Print(&buf)
	output := buf.String()

	if !strings.Contains(output, "1\n") {
		t.Error("output should contain '1'")
	}
	if !strings.Contains(output, "Fizz\n") {
		t.Error("output should contain 'Fizz'")
	}
	if !strings.Contains(output, "Buzz\n") {
		t.Error("output should contain 'Buzz'")
	}
	if !strings.Contains(output, "FizzBuzz\n") {
		t.Error("output should contain 'FizzBuzz'")
	}
}
