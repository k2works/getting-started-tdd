///
/// 高階関数による FizzBuzz の一般化。
///
mod FizzBuzzHof {
    ///
    /// 変換ルールを関数として受け取り、数 `n` を変換する。
    ///
    pub def generateWith(rule: Int32 -> String, n: Int32): String =
        rule(n)

    ///
    /// 標準の FizzBuzz ルール。
    ///
    pub def defaultRule(n: Int32): String =
        if (Int32.remainder(n, 15) == 0)     "FizzBuzz"
        else if (Int32.remainder(n, 3) == 0) "Fizz"
        else if (Int32.remainder(n, 5) == 0) "Buzz"
        else                                 Int32.toString(n)

    ///
    /// 1 から `n` までのリストに変換関数を適用する。
    ///
    pub def transform(rule: Int32 -> String, n: Int32): List[String] =
        List.range(1, n + 1) |> List.map(rule)

    ///
    /// リストを述語で絞り込む。
    ///
    pub def filterList(pred: String -> Bool, xs: List[String]): List[String] =
        List.filter(pred, xs)
}
