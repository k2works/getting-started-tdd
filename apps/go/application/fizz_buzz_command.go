// Package application contains FizzBuzz use-case commands.
package application

import (
	"github.com/k2works/getting-started-tdd/apps/go/domain/model"
	type_ "github.com/k2works/getting-started-tdd/apps/go/domain/type_"
)

// FizzBuzzCommand は FizzBuzz 操作を抽象化するインターフェースです。
type FizzBuzzCommand interface { //nolint:revive
	Execute() interface{}
}

// FizzBuzzValueCommand は単一の FizzBuzzValue を生成するコマンドです。
type FizzBuzzValueCommand struct { //nolint:revive
	number       int
	fizzBuzzType type_.FizzBuzzType
}

// NewFizzBuzzValueCommand は FizzBuzzValueCommand を生成します。
func NewFizzBuzzValueCommand(number int, fizzBuzzType type_.FizzBuzzType) *FizzBuzzValueCommand {
	return &FizzBuzzValueCommand{
		number:       number,
		fizzBuzzType: fizzBuzzType,
	}
}

// Execute は FizzBuzzValue を生成して返します。
func (c *FizzBuzzValueCommand) Execute() interface{} {
	return c.fizzBuzzType.Generate(c.number)
}

// FizzBuzzListCommand は FizzBuzzList を生成するコマンドです。
type FizzBuzzListCommand struct { //nolint:revive
	count        int
	fizzBuzzType type_.FizzBuzzType
}

// NewFizzBuzzListCommand は FizzBuzzListCommand を生成します。
func NewFizzBuzzListCommand(fizzBuzzType type_.FizzBuzzType, count int) *FizzBuzzListCommand {
	return &FizzBuzzListCommand{
		count:        count,
		fizzBuzzType: fizzBuzzType,
	}
}

// Execute は FizzBuzzList を生成して返します。
func (c *FizzBuzzListCommand) Execute() interface{} {
	values := make([]model.FizzBuzzValue, c.count)
	for i := 0; i < c.count; i++ {
		values[i] = c.fizzBuzzType.Generate(i + 1)
	}
	return model.NewFizzBuzzList(values)
}
