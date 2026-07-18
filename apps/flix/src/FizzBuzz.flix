///
/// FizzBuzz を解くモジュール。
///
mod FizzBuzz {
    ///
    /// 数 `n` を FizzBuzz の規則に従って文字列に変換する。
    ///
    pub def convert(n: Int32): String =
        if (Int32.remainder(n, 15) == 0)     "FizzBuzz"
        else if (Int32.remainder(n, 3) == 0) "Fizz"
        else if (Int32.remainder(n, 5) == 0) "Buzz"
        else                                 Int32.toString(n)
}
