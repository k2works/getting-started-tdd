///
/// 関数合成と不変データのパイプライン処理。
///
mod FizzBuzzPipeline {
    ///
    /// 2 つの関数を合成する（f を適用してから g を適用）。
    ///
    pub def compose(f: a -> b \ ef, g: b -> c \ ef): a -> c \ ef =
        x -> g(f(x))

    ///
    /// 数を FizzBuzz 文字列に変換する。
    ///
    pub def convert(n: Int32): String =
        if (Int32.remainder(n, 15) == 0)     "FizzBuzz"
        else if (Int32.remainder(n, 3) == 0) "Fizz"
        else if (Int32.remainder(n, 5) == 0) "Buzz"
        else                                 Int32.toString(n)

    ///
    /// 文字列を括弧で装飾する。
    ///
    pub def decorate(s: String): String =
        "[${s}]"

    ///
    /// convert と decorate を合成した変換。
    ///
    pub def convertAndDecorate(n: Int32): String =
        compose(convert, decorate)(n)

    ///
    /// パイプラインで 1..n を変換・装飾する。
    /// 不変データを段階的に変換し、元のリストは変更しない。
    ///
    pub def process(n: Int32): List[String] =
        List.range(1, n + 1)
            |> List.map(convert)
            |> List.map(decorate)
}
