package type_

import (
	"github.com/k2works/getting-started-tdd/apps/go/domain/model"
)

// FizzBuzzType はタイプごとの FizzBuzz 生成を抽象化するインターフェースです。
type FizzBuzzType interface {
	Generate(number int) model.FizzBuzzValue
}

type fizzBuzzTypeBase struct{}

func (b fizzBuzzTypeBase) isFizz(number int) bool { return number%3 == 0 }
func (b fizzBuzzTypeBase) isBuzz(number int) bool { return number%5 == 0 }

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
