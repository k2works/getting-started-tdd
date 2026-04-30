// Package fizzbuzz provides FizzBuzz generation and output helpers.
package fizzbuzz

import (
	"fmt"
	"io"

	"github.com/k2works/getting-started-tdd/apps/go/application"
	"github.com/k2works/getting-started-tdd/apps/go/domain/model"
	type_ "github.com/k2works/getting-started-tdd/apps/go/domain/type_"
)

// Generate は FizzBuzz の文字列を返します。
func Generate(number int) string {
	return type_.FizzBuzzType01{}.Generate(number).String()
}

// GenerateList は start から end までの FizzBuzz 結果をスライスで返します。
func GenerateList(start, end int) []string {
	count := end - start + 1
	command := application.NewFizzBuzzListCommand(type_.FizzBuzzType01{}, count)
	return command.Execute().(*model.FizzBuzzList).ToStringSlice()
}

// Print は FizzBuzz の結果を writer に出力します。
func Print(w io.Writer) error {
	for _, s := range GenerateList(1, 100) {
		if _, err := fmt.Fprintln(w, s); err != nil {
			return err
		}
	}
	return nil
}
