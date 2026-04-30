// Package main provides the FizzBuzz command.
package main

import (
	"log"
	"os"

	"github.com/k2works/getting-started-tdd/apps/go/fizzbuzz"
)

func main() {
	if err := fizzbuzz.Print(os.Stdout); err != nil {
		log.Fatal(err)
	}
}
