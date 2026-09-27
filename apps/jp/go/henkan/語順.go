package 変換

// Ｓ数 は後置呼び出し Ｓ数(3).FizzBuzz変換() で語順を再現するための数の型です。
type Ｓ数 int

// Ｍ文字列 は変換後の文字列に装飾を後置で続けるための型です。
type Ｍ文字列 string

// FizzBuzz変換 は数を FizzBuzz変換 します。
func (数 Ｓ数) FizzBuzz変換() Ｍ文字列 {
	return Ｍ文字列(FizzBuzz変換(int(数)))
}

// Ｓ装飾 は文字列を角括弧で囲みます。
func (文字列 Ｍ文字列) Ｓ装飾() Ｍ文字列 {
	return Ｍ文字列(Ｓ装飾(string(文字列)))
}
