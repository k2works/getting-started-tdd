package 変換_test

import (
	"strings"
	"testing"

	変換 "github.com/k2works/getting-started-tdd/apps/jp/go/henkan"
)

func 検証(t *testing.T, 実際, 期待 string) {
	t.Helper()
	if 実際 != 期待 {
		t.Errorf("実際 %q, 期待 %q", 実際, 期待)
	}
}

func Test3を渡したらFizzを返す(t *testing.T) {
	検証(t, 変換.FizzBuzz変換(3), "Fizz")
}

func Test5を渡したらBuzzを返す(t *testing.T) {
	検証(t, 変換.FizzBuzz変換(5), "Buzz")
}

func Test15を渡したらFizzBuzzを返す(t *testing.T) {
	検証(t, 変換.FizzBuzz変換(15), "FizzBuzz")
}

func Test1を渡したら文字列1を返す(t *testing.T) {
	検証(t, 変換.FizzBuzz変換(1), "1")
}

func Test2を渡したら文字列2を返す(t *testing.T) {
	検証(t, 変換.FizzBuzz変換(2), "2")
}

func Test15まで作ると15件になる(t *testing.T) {
	if 件数 := len(変換.FizzBuzz配列作成(15)); 件数 != 15 {
		t.Errorf("件数 %d, 期待 15", 件数)
	}
}

func Test15まで作った配列の並び(t *testing.T) {
	検証(t, strings.Join(変換.FizzBuzz配列作成(15), ","),
		"1,2,Fizz,4,Buzz,Fizz,7,8,Fizz,Buzz,11,Fizz,13,14,FizzBuzz")
}
