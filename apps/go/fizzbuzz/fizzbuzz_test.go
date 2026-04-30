package fizzbuzz

import (
	"bytes"
	"strings"
	"testing"
)

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
	if got[1] != "2" {
		t.Errorf("got[1] = %q, want %q", got[1], "2")
	}
	if got[2] != "Fizz" {
		t.Errorf("got[2] = %q, want %q", got[2], "Fizz")
	}
	if got[3] != "4" {
		t.Errorf("got[3] = %q, want %q", got[3], "4")
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
