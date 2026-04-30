package fizzbuzz

import "strconv"

// FizzBuzzType はタイプごとの FizzBuzz 生成を抽象化するインターフェースです。
type FizzBuzzType interface { //nolint:revive
	Generate(number int) string
}

// BasicGenerate は手続き型で FizzBuzz を生成します。
func BasicGenerate(number, fizzBuzzType int) string {
	isFizz := number%3 == 0
	isBuzz := number%5 == 0

	switch fizzBuzzType {
	case 1:
		if isFizz && isBuzz {
			return "FizzBuzz"
		}
		if isFizz {
			return "Fizz"
		}
		if isBuzz {
			return "Buzz"
		}
		return strconv.Itoa(number)
	case 2:
		return strconv.Itoa(number)
	case 3:
		if isFizz && isBuzz {
			return "FizzBuzz"
		}
		return strconv.Itoa(number)
	default:
		panic("該当するタイプは存在しません")
	}
}

// fizzBuzzTypeBase は FizzBuzz 判定の共通ロジックを提供します。
type fizzBuzzTypeBase struct{}

func (b fizzBuzzTypeBase) isFizz(number int) bool {
	return number%3 == 0
}

func (b fizzBuzzTypeBase) isBuzz(number int) bool {
	return number%5 == 0
}

// FizzBuzzType01 は通常の FizzBuzz を生成します。
type FizzBuzzType01 struct { //nolint:revive
	fizzBuzzTypeBase
}

// Generate はタイプ 1 の通常 FizzBuzz 文字列を返します。
func (f FizzBuzzType01) Generate(number int) string {
	if f.isFizz(number) && f.isBuzz(number) {
		return "FizzBuzz"
	}
	if f.isFizz(number) {
		return "Fizz"
	}
	if f.isBuzz(number) {
		return "Buzz"
	}
	return strconv.Itoa(number)
}

// FizzBuzzType02 は数値のみを返します。
type FizzBuzzType02 struct{} //nolint:revive

// Generate はタイプ 2 の数値文字列を返します。
func (f FizzBuzzType02) Generate(number int) string {
	return strconv.Itoa(number)
}

// FizzBuzzType03 は FizzBuzz のみ返し、それ以外は数値を返します。
type FizzBuzzType03 struct { //nolint:revive
	fizzBuzzTypeBase
}

// Generate はタイプ 3 の FizzBuzz または数値文字列を返します。
func (f FizzBuzzType03) Generate(number int) string {
	if f.isFizz(number) && f.isBuzz(number) {
		return "FizzBuzz"
	}
	return strconv.Itoa(number)
}

// NewFizzBuzzType は指定されたタイプの FizzBuzzType を生成します。
func NewFizzBuzzType(fizzBuzzType int) FizzBuzzType {
	switch fizzBuzzType {
	case 1:
		return FizzBuzzType01{}
	case 2:
		return FizzBuzzType02{}
	case 3:
		return FizzBuzzType03{}
	default:
		panic("該当するタイプは存在しません")
	}
}
