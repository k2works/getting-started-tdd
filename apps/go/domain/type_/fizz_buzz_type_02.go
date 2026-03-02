package type_

import (
	"strconv"

	"github.com/k2works/getting-started-tdd/apps/go/domain/model"
)

// FizzBuzzType02 は数値のみを返します。
type FizzBuzzType02 struct{ fizzBuzzTypeBase }

func (f FizzBuzzType02) Generate(number int) model.FizzBuzzValue {
	return model.NewFizzBuzzValue(number, strconv.Itoa(number))
}
