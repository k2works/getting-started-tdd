//! 題材 C: パイプライン（なでしこ3 の test/pipeline_test.nako3 に対応）

#![allow(non_snake_case)]

use fizzbuzz_jp::パイプライン::{FizzBuzz装飾, パイプライン処理, 装飾};

#[test]
fn 装飾すると角括弧で囲む() {
    assert_eq!(装飾("Fizz"), "[Fizz]");
}

#[test]
fn 変換してから装飾する() {
    assert_eq!(FizzBuzz装飾(15), "[FizzBuzz]");
}

#[test]
fn _5までのパイプライン処理() {
    assert_eq!(
        パイプライン処理(5),
        vec!["[1]", "[2]", "[Fizz]", "[4]", "[Buzz]"]
    );
}
