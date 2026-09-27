//! 題材 A: FizzBuzz の基本変換（なでしこ3 の src/fizzbuzz.nako3 に対応）

/// 15 の倍数で FizzBuzz、3 の倍数で Fizz、5 の倍数で Buzz、それ以外は数の文字列を返す。
pub fn FizzBuzz変換(数: i64) -> String {
    match (数 % 3, 数 % 5) {
        (0, 0) => "FizzBuzz".to_string(),
        (0, _) => "Fizz".to_string(),
        (_, 0) => "Buzz".to_string(),
        _ => 数.to_string(),
    }
}

/// 1 から 上限 までを FizzBuzz変換 した配列を返す。
pub fn FizzBuzz配列作成(上限: i64) -> Vec<String> {
    (1..=上限).map(FizzBuzz変換).collect()
}

/// 数の後ろに変換を置く（`3.FizzBuzz変換()`）ための拡張トレイト。
pub trait 数の変換 {
    fn FizzBuzz変換(self) -> String;
}

impl 数の変換 for i64 {
    fn FizzBuzz変換(self) -> String {
        FizzBuzz変換(self)
    }
}
