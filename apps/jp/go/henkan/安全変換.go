package 変換

import "fmt"

// Ａ安全変換 は正の数なら FizzBuzz変換 の結果を、そうでなければエラーを返します。
// 変換結果（成功・失敗）は Go の慣用に従い (値, error) の 2 値で表します。
func Ａ安全変換(数 int) (string, error) {
	if 数 <= 0 {
		return "", fmt.Errorf("正の数を指定してください: %d", 数)
	}
	return FizzBuzz変換(数), nil
}
