package type_ //nolint:revive

import "fmt"

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
	case FizzBuzzType01:
		return "Standard"
	case FizzBuzzType02:
		return "NumberOnly"
	case FizzBuzzType03:
		return "FizzBuzzOnly"
	default:
		return "Unknown"
	}
}

// FizzBuzzTypeName は FizzBuzz タイプの型安全な識別子です。
type FizzBuzzTypeName int //nolint:revive

const (
	// FizzBuzzTypeStandard は通常の FizzBuzz タイプです。
	FizzBuzzTypeStandard FizzBuzzTypeName = iota + 1
	// FizzBuzzTypeNumberOnly は常に数値を返すタイプです。
	FizzBuzzTypeNumberOnly
	// FizzBuzzTypeFizzBuzzOnly は FizzBuzz のみ変換するタイプです。
	FizzBuzzTypeFizzBuzzOnly
)

// CreateFizzBuzzType は FizzBuzzTypeName から FizzBuzzType を生成します。
func CreateFizzBuzzType(name FizzBuzzTypeName) FizzBuzzType {
	return NewFizzBuzzType(int(name))
}
