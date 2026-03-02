// Package main は FizzBuzz プログラムのエントリポイントです。
package main

import (
	"os"

	"github.com/k2works/getting-started-tdd/apps/go/fizzbuzz"
)

func main() {
	fizzbuzz.Print(os.Stdout)
}
