///
/// FizzBuzz の出力を抽象化する代数的効果。
///
eff Emit {
    def line(s: String): Unit
}

///
/// エラーハンドリングと代数的効果。
///
mod FizzBuzzEff {
    ///
    /// 正の数のみ受け付ける安全な変換。負数・ゼロは Err を返す。
    ///
    pub def safeConvert(n: Int32): Result[String, String] =
        if (n <= 0)
            Err("正の数を指定してください: ${n}")
        else
            Ok(FizzBuzzPipeline.convert(n))

    ///
    /// Emit 効果を使って 1..n の FizzBuzz を発行する。
    /// どこへ出力するかは効果ハンドラに委ねる（純粋なロジックと副作用の分離）。
    ///
    pub def emitAll(n: Int32): Unit \ Emit =
        List.range(1, n + 1)
            |> List.forEach(i -> Emit.line(FizzBuzzPipeline.convert(i)))

    ///
    /// Emit 効果を「リストへ集める」ハンドラで解釈し、結果を返す。
    /// 各 line は自身の文字列を継続の結果に cons することでリストを組み立てる。
    ///
    pub def collect(n: Int32): List[String] =
        run {
            emitAll(n);
            Nil
        } with handler Emit {
            def line(s, resume) = s :: resume(())
        }

    ///
    /// Emit 効果を「標準出力へ書く」ハンドラで解釈する。
    ///
    pub def printAll(n: Int32): Unit \ IO =
        run {
            emitAll(n)
        } with handler Emit {
            def line(s, resume) = { println(s); resume(()) }
        }
}
