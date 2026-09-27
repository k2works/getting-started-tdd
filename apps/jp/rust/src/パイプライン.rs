//! 題材 C: パイプライン処理（なでしこ3 の src/pipeline.nako3 に対応）

use std::fmt::Display;

use crate::なでしこ;
use crate::基本変換::FizzBuzz変換;

/// 文字列を角括弧で囲む。
pub fn 装飾(文字列: impl Display) -> String {
    format!("[{文字列}]")
}

/// なでしこ3 の「NをFizzBuzz変換して装飾して戻す」。
pub fn FizzBuzz装飾(数: i64) -> String {
    なでしこ!(数 を FizzBuzz変換 して 装飾)
}

/// 1 から 上限 までを FizzBuzz装飾 した配列を返す。
pub fn パイプライン処理(上限: i64) -> Vec<String> {
    (1..=上限).map(FizzBuzz装飾).collect()
}
