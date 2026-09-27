package 変換_test

import (
	"testing"

	変換 "github.com/k2works/getting-started-tdd/apps/jp/go/henkan"
)

func Test語順の再現(t *testing.T) {
	t.Run("3 を FizzBuzz変換 すると Fizz を返す（後置呼び出し）", func(t *testing.T) {
		検証(t, string(変換.Ｓ数(3).FizzBuzz変換()), "Fizz")
	})
	t.Run("15 を FizzBuzz変換して 装飾する", func(t *testing.T) {
		検証(t, string(変換.Ｓ数(15).FizzBuzz変換().Ｓ装飾()), "[FizzBuzz]")
	})
}
