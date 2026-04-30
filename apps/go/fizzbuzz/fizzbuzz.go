// Package fizzbuzz provides FizzBuzz generation and output helpers.
package fizzbuzz

import (
	"fmt"
	"io"
)

// Generate は FizzBuzz の文字列を返します。
func Generate(number int) string {
	return FizzBuzzType01{}.Generate(number)
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
func Print(w io.Writer) error {
	for _, s := range GenerateList(1, 100) {
		if _, err := fmt.Fprintln(w, s); err != nil {
			return err
		}
	}
	return nil
}
