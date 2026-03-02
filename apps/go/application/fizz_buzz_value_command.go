package application

import (
	type_ "github.com/k2works/getting-started-tdd/apps/go/domain/type_"
)

// FizzBuzzValueCommand は単一の FizzBuzzValue を生成するコマンドです。
type FizzBuzzValueCommand struct {
	number       int
	fizzBuzzType type_.FizzBuzzType
}

// NewFizzBuzzValueCommand は FizzBuzzValueCommand を生成します。
func NewFizzBuzzValueCommand(number int, fizzBuzzType type_.FizzBuzzType) *FizzBuzzValueCommand {
	return &FizzBuzzValueCommand{number: number, fizzBuzzType: fizzBuzzType}
}

// Execute は値生成コマンドを実行し FizzBuzzValue を返します。
func (c *FizzBuzzValueCommand) Execute() interface{} {
	return c.fizzBuzzType.Generate(c.number)
}
