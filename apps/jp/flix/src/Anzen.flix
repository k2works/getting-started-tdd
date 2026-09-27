///
/// 題材 D: 安全変換（なでしこ3 の `●(Nを)安全変換`）。
///
/// 変換結果は標準の `Result[String, String]` で表す（成功 = Ok、失敗 = Err）。
/// 引数が Int32 のため「数値でなければ失敗」はコンパイル時に弾かれ、実行時の検査は不要になる。
///
mod Anzen {
    ///
    /// 安全変換: 0 以下なら失敗、それ以外は成功。
    ///
    pub def anzenHenkan(n: Int32): Result[String, String] =
        if (n <= 0)
            Err("正の数を指定してください: ${n}")
        else
            Ok(FizzBuzz.fizzBuzzHenkan(n))
}
