// Package type_ は FizzBuzz のタイプバリエーションを提供します。
// type は Go 予約語のためアンダースコア付きパッケージ名を使用しています。
package type_ //nolint:revive

import (
	"fmt"

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

// FizzBuzzTypeName は FizzBuzz タイプの型安全な識別子です。
type FizzBuzzTypeName int

// FizzBuzzTypeStandard, FizzBuzzTypeNumberOnly, FizzBuzzTypeFizzBuzzOnly は FizzBuzz タイプの識別定数です。
const (
	FizzBuzzTypeStandard     FizzBuzzTypeName = iota + 1 // 1
	FizzBuzzTypeNumberOnly                               // 2
	FizzBuzzTypeFizzBuzzOnly                             // 3
)

// TryNewFizzBuzzType は安全なファクトリです。不正なタイプでは error を返します。
func TryNewFizzBuzzType(fizzBuzzType int) (FizzBuzzType, error) {
	switch fizzBuzzType {
	case 1:
		return FizzBuzzType01{}, nil
	case 2:
		return FizzBuzzType02{}, nil
	case 3:
		return FizzBuzzType03{}, nil
	default:
		return nil, fmt.Errorf("該当するタイプは存在しません: %d", fizzBuzzType)
	}
}

// DescribeFizzBuzzType は型スイッチで FizzBuzzType の種類を文字列で返します。
func DescribeFizzBuzzType(fbt FizzBuzzType) string {
	switch fbt.(type) {
	case FizzBuzzType01, *FizzBuzzType01:
		return "Standard"
	case FizzBuzzType02, *FizzBuzzType02:
		return "NumberOnly"
	case FizzBuzzType03, *FizzBuzzType03:
		return "FizzBuzzOnly"
	default:
		return "Unknown"
	}
}

// CreateFizzBuzzType は FizzBuzzTypeName から FizzBuzzType を生成します。
func CreateFizzBuzzType(name FizzBuzzTypeName) FizzBuzzType {
	return NewFizzBuzzType(int(name))
}
