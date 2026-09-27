package 変換_test

import (
	"testing"

	変換 "github.com/k2works/getting-started-tdd/apps/jp/go/henkan"
)

func 生成(t *testing.T, 番号 int) 変換.Ｔタイプ {
	t.Helper()
	タイプ, エラー := 変換.Ｔタイプ生成(番号)
	if エラー != nil {
		t.Fatalf("タイプ%d の生成に失敗: %v", 番号, エラー)
	}
	return タイプ
}

func Testタイプ生成(t *testing.T) {
	t.Run("タイプ1は通常の変換をする", func(t *testing.T) {
		タイプ := 生成(t, 1)
		検証(t, 変換.Ｔタイプ変換(タイプ, 3), "Fizz")
		検証(t, タイプ.Ｎ名前, "通常")
	})
	t.Run("タイプ2は数字だけを返す", func(t *testing.T) {
		タイプ := 生成(t, 2)
		検証(t, 変換.Ｔタイプ変換(タイプ, 3), "3")
		検証(t, タイプ.Ｎ名前, "数字限定")
	})
	t.Run("タイプ3は15の倍数だけFizzBuzzを返す", func(t *testing.T) {
		検証(t, 変換.Ｔタイプ変換(生成(t, 3), 15), "FizzBuzz")
	})
	t.Run("タイプ3は3の倍数を数字で返す", func(t *testing.T) {
		検証(t, 変換.Ｔタイプ変換(生成(t, 3), 3), "3")
	})
	t.Run("存在しないタイプはエラーになる", func(t *testing.T) {
		_, エラー := 変換.Ｔタイプ生成(4)
		if エラー == nil {
			t.Fatal("エラーになるはず")
		}
		検証(t, エラー.Error(), "該当するタイプは存在しません: 4")
	})
}
