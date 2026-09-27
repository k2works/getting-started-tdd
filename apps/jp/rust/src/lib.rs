//! なでしこ3 実装（apps/nadesiko）を日本語識別子で Rust に移植する。
//!
//! モジュール名を日本語にすると、ファイルから読み込むときに
//! E0754（non-ascii identifier name）になるため、`#[path]` でファイルを指定する。
// `FizzBuzz変換` のように大文字を含む関数名が non_snake_case 警告になるため抑止する。
#![allow(non_snake_case)]

#[path = "語順.rs"]
pub mod 語順;

#[path = "基本変換.rs"]
pub mod 基本変換;

#[path = "タイプ別.rs"]
pub mod タイプ別;

#[path = "パイプライン.rs"]
pub mod パイプライン;

#[path = "エラー処理.rs"]
pub mod エラー処理;
