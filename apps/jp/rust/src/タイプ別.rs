//! 題材 B: タイプ別の変換（なでしこ3 の src/type.nako3 に対応）

use crate::基本変換::FizzBuzz変換;

/// タイプの種別。列挙子も日本語で書ける。
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum 種別 {
    通常,
    数字限定,
    FizzBuzz限定,
}

/// 名前と変換（数 → 文字列の関数）を持つタイプ。
#[derive(Debug, Clone, Copy)]
pub struct タイプ {
    種別: 種別,
    変換: fn(i64) -> String,
}

impl タイプ {
    pub fn 名前(&self) -> &'static str {
        match self.種別 {
            種別::通常 => "通常",
            種別::数字限定 => "数字限定",
            種別::FizzBuzz限定 => "FizzBuzz限定",
        }
    }
}

fn 数字限定変換(数: i64) -> String {
    数.to_string()
}

fn FizzBuzz限定変換(数: i64) -> String {
    if 数 % 15 == 0 {
        "FizzBuzz".to_string()
    } else {
        数.to_string()
    }
}

/// 番号からタイプを作る。存在しない番号はエラーメッセージを返す。
pub fn タイプ生成(番号: i64) -> Result<タイプ, String> {
    let (種別, 変換): (種別, fn(i64) -> String) = match 番号 {
        1 => (種別::通常, FizzBuzz変換),
        2 => (種別::数字限定, 数字限定変換),
        3 => (種別::FizzBuzz限定, FizzBuzz限定変換),
        _ => return Err(format!("該当するタイプは存在しません: {番号}")),
    };
    Ok(タイプ { 種別, 変換 })
}

/// タイプの変換を数に適用する。
pub fn タイプ変換(タイプ: &タイプ, 数: i64) -> String {
    (タイプ.変換)(数)
}
