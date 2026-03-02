// Package fizzbuzz は FizzBuzz 問題の実装を提供します。
package fizzbuzz

import (
	"fmt"
	"io"
	"strconv"

	"github.com/k2works/getting-started-tdd/apps/go/application"
	"github.com/k2works/getting-started-tdd/apps/go/domain/model"
	type_ "github.com/k2works/getting-started-tdd/apps/go/domain/type_"
)

// Generate は FizzBuzz の文字列を返します。
func Generate(number int) string {
	switch {
	case number%15 == 0:
		return "FizzBuzz"
	case number%3 == 0:
		return "Fizz"
	case number%5 == 0:
		return "Buzz"
	default:
		return strconv.Itoa(number)
	}
}

// GenerateList は start から end までの FizzBuzz 結果をスライスで返します。
func GenerateList(start, end int) []string {
	results := make([]string, 0, end-start+1)
	for i := start; i <= end; i++ {
		results = append(results, Generate(i))
	}
	return results
}

// Print は FizzBuzz の結果を writer に出力します。
func Print(w io.Writer) {
	for _, s := range GenerateList(1, 100) {
		_, _ = fmt.Fprintln(w, s)
	}
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

// --- 以下、新パッケージの型を再エクスポート ---

// FizzBuzzValue は FizzBuzz の結果を表す値オブジェクトです。
type FizzBuzzValue = model.FizzBuzzValue //nolint:revive

// NewFizzBuzzValue は FizzBuzzValue を生成します。
var NewFizzBuzzValue = model.NewFizzBuzzValue

// FizzBuzzList は FizzBuzzValue のコレクションです。
type FizzBuzzList = model.FizzBuzzList //nolint:revive

// NewFizzBuzzList は FizzBuzzList を生成します。
var NewFizzBuzzList = model.NewFizzBuzzList

// MaxCount はリストの上限件数です。
const MaxCount = model.MaxCount

// Predicate は FizzBuzzValue を受け取り bool を返す関数型です。
type Predicate = model.Predicate

// Mapper は FizzBuzzValue を受け取り string を返す関数型です。
type Mapper = model.Mapper

// MakeValuePredicate は指定した値と一致するかを判定する述語関数を返します。
var MakeValuePredicate = model.MakeValuePredicate

// Compose は f を適用した後に g を適用する合成関数を返します。
var Compose = model.Compose

// Reducer は累積値と要素を受け取り新しい累積値を返す関数型です。
type Reducer = model.Reducer

// FizzBuzzType はタイプごとの FizzBuzz 生成を抽象化するインターフェースです。
type FizzBuzzType = type_.FizzBuzzType //nolint:revive

// FizzBuzzType01 は通常の FizzBuzz を生成します。
type FizzBuzzType01 = type_.FizzBuzzType01 //nolint:revive

// FizzBuzzType02 は数値のみを返します。
type FizzBuzzType02 = type_.FizzBuzzType02 //nolint:revive

// FizzBuzzType03 は FizzBuzz のみ返し、それ以外は数値を返します。
type FizzBuzzType03 = type_.FizzBuzzType03 //nolint:revive

// NewFizzBuzzType は指定されたタイプの FizzBuzzType を生成します。
var NewFizzBuzzType = type_.NewFizzBuzzType

// TryNewFizzBuzzValue は安全なファクトリです。負の値では error を返します。
var TryNewFizzBuzzValue = model.TryNewFizzBuzzValue

// TryNewFizzBuzzType は安全なファクトリです。不正なタイプでは error を返します。
var TryNewFizzBuzzType = type_.TryNewFizzBuzzType

// DescribeFizzBuzzType は FizzBuzzType の種類を文字列で返します。
var DescribeFizzBuzzType = type_.DescribeFizzBuzzType

// FizzBuzzTypeName は FizzBuzz タイプの型安全な識別子です。
type FizzBuzzTypeName = type_.FizzBuzzTypeName //nolint:revive

// FizzBuzzTypeStandard, FizzBuzzTypeNumberOnly, FizzBuzzTypeFizzBuzzOnly は FizzBuzz タイプ定数です。
const (
	FizzBuzzTypeStandard     = type_.FizzBuzzTypeStandard
	FizzBuzzTypeNumberOnly   = type_.FizzBuzzTypeNumberOnly
	FizzBuzzTypeFizzBuzzOnly = type_.FizzBuzzTypeFizzBuzzOnly
)

// CreateFizzBuzzType は FizzBuzzTypeName から FizzBuzzType を生成します。
var CreateFizzBuzzType = type_.CreateFizzBuzzType

// FizzBuzzCommand は FizzBuzz 操作を抽象化するインターフェースです。
type FizzBuzzCommand = application.FizzBuzzCommand //nolint:revive

// FizzBuzzValueCommand は単一の FizzBuzzValue を生成するコマンドです。
type FizzBuzzValueCommand = application.FizzBuzzValueCommand //nolint:revive

// NewFizzBuzzValueCommand は FizzBuzzValueCommand を生成します。
var NewFizzBuzzValueCommand = application.NewFizzBuzzValueCommand

// FizzBuzzListCommand は FizzBuzzList を生成するコマンドです。
type FizzBuzzListCommand = application.FizzBuzzListCommand //nolint:revive

// NewFizzBuzzListCommand は FizzBuzzListCommand を生成します。
var NewFizzBuzzListCommand = application.NewFizzBuzzListCommand
