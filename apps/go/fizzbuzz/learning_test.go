package fizzbuzz

import (
	"bytes"
	"fmt"
	"strconv"
	"testing"
)

// 学習用テスト: strconv.Itoa の使い方確認。
func TestLearning_strconvItoa_整数を文字列へ変換できる(t *testing.T) {
	got := strconv.Itoa(42)
	want := "42"
	if got != want {
		t.Fatalf("strconv.Itoa(42) = %q, want %q", got, want)
	}
}

func TestLearning_fmtFprintln_バッファに出力できる(t *testing.T) {
	var buf bytes.Buffer
	fmt.Fprintln(&buf, "hello")
	got := buf.String()
	want := "hello\n"
	if got != want {
		t.Fatalf("buf.String() = %q, want %q", got, want)
	}
}
