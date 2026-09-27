package 変換

import "strconv"

// FizzBuzz変換 は 15 の倍数で FizzBuzz、3 の倍数で Fizz、5 の倍数で Buzz、それ以外は数の文字列を返します。
func FizzBuzz変換(数 int) string {
	switch {
	case 数%15 == 0:
		return "FizzBuzz"
	case 数%3 == 0:
		return "Fizz"
	case 数%5 == 0:
		return "Buzz"
	default:
		return strconv.Itoa(数)
	}
}

// FizzBuzz配列作成 は 1 から上限までを FizzBuzz変換 した配列を返します。
func FizzBuzz配列作成(上限 int) []string {
	結果 := make([]string, 0, 上限)
	for 数 := 1; 数 <= 上限; 数++ {
		結果 = append(結果, FizzBuzz変換(数))
	}
	return 結果
}
