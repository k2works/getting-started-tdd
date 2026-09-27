//! 題材 B: タイプ生成（なでしこ3 の test/type_test.nako3 に対応）
#![allow(non_snake_case)]

use fizzbuzz_jp::タイプ別::{タイプ変換, タイプ生成};

#[test]
fn タイプ1は通常の変換をする() {
    let 通常 = タイプ生成(1).unwrap();
    assert_eq!(タイプ変換(&通常, 3), "Fizz");
    assert_eq!(通常.名前(), "通常");
}

#[test]
fn タイプ2は数字だけを返す() {
    let 数字 = タイプ生成(2).unwrap();
    assert_eq!(タイプ変換(&数字, 3), "3");
    assert_eq!(数字.名前(), "数字限定");
}

#[test]
fn タイプ3は15の倍数だけFizzBuzzを返す() {
    let 限定 = タイプ生成(3).unwrap();
    assert_eq!(タイプ変換(&限定, 15), "FizzBuzz");
}

#[test]
fn タイプ3は3の倍数を数字で返す() {
    let 限定 = タイプ生成(3).unwrap();
    assert_eq!(タイプ変換(&限定, 3), "3");
}

#[test]
fn 存在しないタイプはエラーになる() {
    assert_eq!(
        タイプ生成(4).err(),
        Some("該当するタイプは存在しません: 4".to_string())
    );
}
