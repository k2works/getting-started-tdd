package 変換_test

import (
	"slices"
	"testing"

	変換 "github.com/k2works/getting-started-tdd/apps/jp/go/henkan"
)

func Testパイプライン(t *testing.T) {
	t.Run("装飾すると角括弧で囲む", func(t *testing.T) {
		検証(t, 変換.Ｓ装飾("Fizz"), "[Fizz]")
	})
	t.Run("5までのパイプライン処理", func(t *testing.T) {
		実際 := 変換.Ｐパイプライン処理(5)
		期待 := []string{"[1]", "[2]", "[Fizz]", "[4]", "[Buzz]"}
		if !slices.Equal(実際, 期待) {
			t.Errorf("実際 %q, 期待 %q", 実際, 期待)
		}
	})
}
