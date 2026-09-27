package 変換

import (
	"fmt"
	"strconv"
)

// Ｔタイプ は名前と変換（数 → 文字列の関数）を持つタイプです。
// 公開するには大文字始まりが必要なため、全角大文字を前置しています。
type Ｔタイプ struct {
	Ｎ名前 string
	Ｈ変換 func(int) string
}

// Ｔタイプ生成 は番号に対応するタイプを返します。該当しない番号はエラーです。
func Ｔタイプ生成(番号 int) (Ｔタイプ, error) {
	switch 番号 {
	case 1:
		return Ｔタイプ{Ｎ名前: "通常", Ｈ変換: FizzBuzz変換}, nil
	case 2:
		return Ｔタイプ{Ｎ名前: "数字限定", Ｈ変換: strconv.Itoa}, nil
	case 3:
		return Ｔタイプ{Ｎ名前: "FizzBuzz限定", Ｈ変換: fizzBuzz限定変換}, nil
	default:
		return Ｔタイプ{}, fmt.Errorf("該当するタイプは存在しません: %d", 番号)
	}
}

// Ｔタイプ変換 はタイプの変換を数に適用します。
func Ｔタイプ変換(タイプ Ｔタイプ, 数 int) string {
	return タイプ.Ｈ変換(数)
}

func fizzBuzz限定変換(数 int) string {
	if 数%15 == 0 {
		return "FizzBuzz"
	}
	return strconv.Itoa(数)
}
