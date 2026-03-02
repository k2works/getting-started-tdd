package type_

import (
	"strconv"

	"github.com/k2works/getting-started-tdd/apps/go/domain/model"
)

// FizzBuzzType01 は通常の FizzBuzz を生成します。
type FizzBuzzType01 struct{ fizzBuzzTypeBase }

func (f FizzBuzzType01) Generate(number int) model.FizzBuzzValue {
	if f.isFizz(number) && f.isBuzz(number) {
		return model.NewFizzBuzzValue(number, "FizzBuzz")
	}
	if f.isFizz(number) {
		return model.NewFizzBuzzValue(number, "Fizz")
	}
	if f.isBuzz(number) {
		return model.NewFizzBuzzValue(number, "Buzz")
	}
	return model.NewFizzBuzzValue(number, strconv.Itoa(number))
}
