package フィズバズ

import org.scalatest.funsuite.AnyFunSuite

class FizzBuzzテスト extends AnyFunSuite:
  test("3を渡したらFizzを返す") {
    assert(FizzBuzz変換(3) === "Fizz")
  }

  test("5を渡したらBuzzを返す") {
    assert(FizzBuzz変換(5) === "Buzz")
  }

  test("15を渡したらFizzBuzzを返す") {
    assert(FizzBuzz変換(15) === "FizzBuzz")
  }

  test("1を渡したら文字列1を返す") {
    assert(FizzBuzz変換(1) === "1")
  }

  test("2を渡したら文字列2を返す") {
    assert(FizzBuzz変換(2) === "2")
  }

  test("15まで作ると15件になる") {
    assert(FizzBuzz配列作成(15).size === 15)
  }

  test("15まで作った配列の並び") {
    assert(
      FizzBuzz配列作成(15).mkString(",") === "1,2,Fizz,4,Buzz,Fizz,7,8,Fizz,Buzz,11,Fizz,13,14,FizzBuzz"
    )
  }

  test("3 を FizzBuzz変換 と書ける（中置の拡張メソッド）") {
    assert((3 を FizzBuzz変換) === "Fizz")
  }
