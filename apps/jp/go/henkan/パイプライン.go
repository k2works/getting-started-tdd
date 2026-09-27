package 変換

// Ｓ装飾 は文字列を角括弧で囲みます。
func Ｓ装飾(文字列 string) string {
	return "[" + 文字列 + "]"
}

// して は「先して後」の順に関数を合成します。
func して[入力, 途中, 出力 any](先 func(入力) 途中, 後 func(途中) 出力) func(入力) 出力 {
	return func(値 入力) 出力 { return 後(先(値)) }
}

// FizzBuzz装飾 は数を FizzBuzz変換して 装飾して 返します。
func FizzBuzz装飾(数 int) string {
	return して(FizzBuzz変換, Ｓ装飾)(数)
}

// Ｐパイプライン処理 は 1 から上限までを FizzBuzz装飾 した配列を返します。
func Ｐパイプライン処理(上限 int) []string {
	結果 := make([]string, 0, 上限)
	for 数 := 1; 数 <= 上限; 数++ {
		結果 = append(結果, FizzBuzz装飾(数))
	}
	return 結果
}
