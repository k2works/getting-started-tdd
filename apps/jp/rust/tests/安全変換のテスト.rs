//! 題材 D: 安全変換（なでしこ3 の test/error_test.nako3 に対応）
//!
//! 「数値でなければ失敗になる」は、引数が i64 のため `安全変換("a")` が
//! コンパイルエラー（E0308 mismatched types）になり、テストとして書けない。

use fizzbuzz_jp::エラー処理::{失敗, 安全変換, 成功};

#[test]
fn 正の数は成功になる() {
    assert_eq!(安全変換(3), 成功("Fizz".to_string()));
}

#[test]
fn _0は失敗になる() {
    assert_eq!(安全変換(0), 失敗("正の数を指定してください: 0".to_string()));
}
