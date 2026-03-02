// Package application は FizzBuzz のアプリケーション層コマンドを提供します。
package application

// FizzBuzzCommand は FizzBuzz 操作を抽象化するインターフェースです。
type FizzBuzzCommand interface {
	Execute() interface{}
}
