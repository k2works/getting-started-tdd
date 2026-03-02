package application

import (
	"github.com/k2works/getting-started-tdd/apps/go/domain/model"
	type_ "github.com/k2works/getting-started-tdd/apps/go/domain/type_"
)

// FizzBuzzListCommand は FizzBuzzList を生成するコマンドです。
type FizzBuzzListCommand struct {
	count        int
	fizzBuzzType type_.FizzBuzzType
}

// NewFizzBuzzListCommand は FizzBuzzListCommand を生成します。
func NewFizzBuzzListCommand(fizzBuzzType type_.FizzBuzzType, count int) *FizzBuzzListCommand {
	return &FizzBuzzListCommand{count: count, fizzBuzzType: fizzBuzzType}
}

// Execute はリスト生成コマンドを実行し FizzBuzzList を返します。
func (c *FizzBuzzListCommand) Execute() interface{} {
	values := make([]model.FizzBuzzValue, c.count)
	for i := 0; i < c.count; i++ {
		values[i] = c.fizzBuzzType.Generate(i + 1)
	}
	return model.NewFizzBuzzList(values)
}
