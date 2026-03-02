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

// FizzBuzzValue は model.FizzBuzzValue の型エイリアスです。
type FizzBuzzValue = model.FizzBuzzValue

// NewFizzBuzzValue は model.NewFizzBuzzValue を呼び出します。
var NewFizzBuzzValue = model.NewFizzBuzzValue

// FizzBuzzList は model.FizzBuzzList の型エイリアスです。
type FizzBuzzList = model.FizzBuzzList

// NewFizzBuzzList は model.NewFizzBuzzList を呼び出します。
var NewFizzBuzzList = model.NewFizzBuzzList

// MaxCount はリストの上限件数です。
const MaxCount = model.MaxCount

// 章 10 の再エクスポート
type Predicate = model.Predicate
type Mapper = model.Mapper

var MakeValuePredicate = model.MakeValuePredicate
var Compose = model.Compose

// 章 11 の再エクスポート
type Reducer = model.Reducer

// FizzBuzzType は type_.FizzBuzzType の型エイリアスです。
type FizzBuzzType = type_.FizzBuzzType

// FizzBuzzType01 は type_.FizzBuzzType01 の型エイリアスです。
type FizzBuzzType01 = type_.FizzBuzzType01

// FizzBuzzType02 は type_.FizzBuzzType02 の型エイリアスです。
type FizzBuzzType02 = type_.FizzBuzzType02

// FizzBuzzType03 は type_.FizzBuzzType03 の型エイリアスです。
type FizzBuzzType03 = type_.FizzBuzzType03

// NewFizzBuzzType は type_.NewFizzBuzzType を呼び出します。
var NewFizzBuzzType = type_.NewFizzBuzzType

// 章 12 の再エクスポート
var TryNewFizzBuzzValue = model.TryNewFizzBuzzValue
var TryNewFizzBuzzType = type_.TryNewFizzBuzzType
var DescribeFizzBuzzType = type_.DescribeFizzBuzzType

type FizzBuzzTypeName = type_.FizzBuzzTypeName

const (
	FizzBuzzTypeStandard     = type_.FizzBuzzTypeStandard
	FizzBuzzTypeNumberOnly   = type_.FizzBuzzTypeNumberOnly
	FizzBuzzTypeFizzBuzzOnly = type_.FizzBuzzTypeFizzBuzzOnly
)

var CreateFizzBuzzType = type_.CreateFizzBuzzType

// FizzBuzzCommand は application.FizzBuzzCommand の型エイリアスです。
type FizzBuzzCommand = application.FizzBuzzCommand

// FizzBuzzValueCommand は application.FizzBuzzValueCommand の型エイリアスです。
type FizzBuzzValueCommand = application.FizzBuzzValueCommand

// NewFizzBuzzValueCommand は application.NewFizzBuzzValueCommand を呼び出します。
var NewFizzBuzzValueCommand = application.NewFizzBuzzValueCommand

// FizzBuzzListCommand は application.FizzBuzzListCommand の型エイリアスです。
type FizzBuzzListCommand = application.FizzBuzzListCommand

// NewFizzBuzzListCommand は application.NewFizzBuzzListCommand を呼び出します。
var NewFizzBuzzListCommand = application.NewFizzBuzzListCommand
