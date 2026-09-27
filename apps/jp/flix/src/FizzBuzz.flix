///
/// 題材 A: FizzBuzz 変換（なでしこ3 の `●(Nを)FizzBuzz変換`）。
///
/// Flix の字句解析器は識別子に ASCII 以外を受け付けない（`Unexpected character '\u5909'.`）。
/// そのため名前はローマ字で書き、なでしこ3 の元の名前をドキュメントコメントに残す。
///
mod FizzBuzz {
    ///
    /// FizzBuzz変換: 15 の倍数で FizzBuzz、3 の倍数で Fizz、5 の倍数で Buzz、それ以外は数の文字列。
    ///
    pub def fizzBuzzHenkan(n: Int32): String =
        if (Int32.remainder(n, 15) == 0)     "FizzBuzz"
        else if (Int32.remainder(n, 3) == 0) "Fizz"
        else if (Int32.remainder(n, 5) == 0) "Buzz"
        else                                 Int32.toString(n)

    ///
    /// FizzBuzz配列作成: 1 から `n` までを変換したリスト。
    ///
    pub def fizzBuzzHairetsuSakusei(n: Int32): List[String] =
        List.range(1, n + 1) |> List.map(fizzBuzzHenkan)

    ///
    /// 助詞「を」の代わり: `x `wo` f` で `f(x)` を返す。
    /// バッククォートの中置記法で `3 `wo` fizzBuzzHenkan`（3 を FizzBuzz変換）と書ける。
    ///
    pub def wo(x: a, f: a -> b \ ef): b \ ef = f(x)
}
