///
/// 題材 C: パイプライン（なでしこ3 の `NをFizzBuzz変換して装飾して戻す`）。
///
mod Paipurain {
    ///
    /// 装飾: 角括弧で囲む。
    ///
    pub def soushoku(s: String): String = "[${s}]"

    ///
    /// FizzBuzz装飾: `|>` で「FizzBuzz変換して装飾して」の順に左から右へ流す。
    ///
    pub def fizzBuzzSoushoku(n: Int32): String =
        n |> FizzBuzz.fizzBuzzHenkan |> soushoku

    ///
    /// パイプライン処理: 1 から `n` までを FizzBuzz装飾したリスト。
    ///
    pub def paipurainShori(n: Int32): List[String] =
        List.range(1, n + 1) |> List.map(fizzBuzzSoushoku)
}
