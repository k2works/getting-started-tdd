//! 題材 D: 安全変換（なでしこ3 の src/error.nako3 に対応）

use crate::基本変換::FizzBuzz変換;

/// 標準の Result の列挙子に日本語の別名を付けて再公開する。
pub use std::result::Result::{Err as 失敗, Ok as 成功};

/// 成功（値）か失敗（エラーメッセージ）を表す変換結果。
pub type 変換結果 = Result<String, String>;

/// 0 以下なら失敗、それ以外は FizzBuzz変換 の結果で成功を返す。
///
/// 引数は i64 なので「数値でなければ失敗」の分岐は型検査で不要になる。
pub fn 安全変換(数: i64) -> 変換結果 {
    if 数 <= 0 {
        return 失敗(format!("正の数を指定してください: {数}"));
    }
    成功(FizzBuzz変換(数))
}
