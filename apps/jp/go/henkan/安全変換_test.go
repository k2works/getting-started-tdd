package 変換_test

import (
	"testing"

	変換 "github.com/k2works/getting-started-tdd/apps/jp/go/henkan"
)

// 「数値でなければ失敗になる」は引数が int のためコンパイル時に弾かれる（FINDINGS.md 参照）
func Test安全変換(t *testing.T) {
	t.Run("正の数は成功になる", func(t *testing.T) {
		値, エラー := 変換.Ａ安全変換(3)
		if エラー != nil {
			t.Fatalf("成功するはず: %v", エラー)
		}
		検証(t, 値, "Fizz")
	})
	t.Run("0は失敗になる", func(t *testing.T) {
		_, エラー := 変換.Ａ安全変換(0)
		if エラー == nil {
			t.Fatal("失敗するはず")
		}
		検証(t, エラー.Error(), "正の数を指定してください: 0")
	})
}
