mod TestFizzBuzzEff {
    /// 正の数は Ok を返す。
    @Test
    def safeConvert_positive_ok(): Unit \ Assert =
        Assert.assertEq(expected = Ok("Fizz"), FizzBuzzEff.safeConvert(3))

    /// ゼロ以下は Err を返す。
    @Test
    def safeConvert_zero_err(): Unit \ Assert =
        Assert.assertEq(expected = true, Result.isErr(FizzBuzzEff.safeConvert(0)))

    /// Emit 効果を collect ハンドラで解釈すると結果が集まる。
    @Test
    def collect_gathers_results(): Unit \ Assert =
        let result = FizzBuzzEff.collect(5);
        Assert.assertEq(expected = Some("Buzz"), List.nth(4, result))

    /// collect は n 件を返す。
    @Test
    def collect_count(): Unit \ Assert =
        Assert.assertEq(expected = 15, List.length(FizzBuzzEff.collect(15)))
}
