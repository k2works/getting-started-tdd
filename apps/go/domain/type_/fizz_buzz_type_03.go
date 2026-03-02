package type_

import (
	"strconv"

	"github.com/k2works/getting-started-tdd/apps/go/domain/model"
)

// FizzBuzzType03 は FizzBuzz のみ返し、それ以外は数値を返します。
type FizzBuzzType03 struct{ fizzBuzzTypeBase }

func (f FizzBuzzType03) Generate(number int) model.FizzBuzzValue {
	if f.isFizz(number) && f.isBuzz(number) {
		return model.NewFizzBuzzValue(number, "FizzBuzz")
	}
	return model.NewFizzBuzzValue(number, strconv.Itoa(number))
}
