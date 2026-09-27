//! 題材 A: FizzBuzz 変換（なでしこ3 の test/fizzbuzz_test.nako3 に対応）
// テスト名に Fizz などの大文字が入ると non_snake_case 警告になるため抑止する。
#![allow(non_snake_case)]

use fizzbuzz_jp::なでしこ;
use fizzbuzz_jp::基本変換::{FizzBuzz変換, FizzBuzz配列作成, 数の変換};

#[test]
fn _3を渡したらFizzを返す() {
    assert_eq!(FizzBuzz変換(3), "Fizz");
}

#[test]
fn _5を渡したらBuzzを返す() {
    assert_eq!(FizzBuzz変換(5), "Buzz");
}

#[test]
fn _15を渡したらFizzBuzzを返す() {
    assert_eq!(FizzBuzz変換(15), "FizzBuzz");
}

#[test]
fn _1を渡したら文字列1を返す() {
    assert_eq!(FizzBuzz変換(1), "1");
}

#[test]
fn _2を渡したら文字列2を返す() {
    assert_eq!(FizzBuzz変換(2), "2");
}

#[test]
fn _15まで作ると15件になる() {
    assert_eq!(FizzBuzz配列作成(15).len(), 15);
}

#[test]
fn _15まで作った配列の並び() {
    assert_eq!(
        FizzBuzz配列作成(15).join(","),
        "1,2,Fizz,4,Buzz,Fizz,7,8,Fizz,Buzz,11,Fizz,13,14,FizzBuzz"
    );
}

#[test]
fn 語順_3をFizzBuzz変換するとFizzになる() {
    assert_eq!(なでしこ!(3 を FizzBuzz変換), "Fizz");
}

#[test]
fn 語順_後置のメソッド呼び出しでもFizzになる() {
    assert_eq!(3.FizzBuzz変換(), "Fizz");
}
