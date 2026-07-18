mod TestFizzBuzzPipeline {
    /// compose は f のあとに g を適用する。
    @Test
    def compose_applies_in_order(): Unit \ Assert =
        let inc = x -> x + 1;
        let dbl = x -> x * 2;
        let f = FizzBuzzPipeline.compose(inc, dbl);
        Assert.assertEq(expected = 8, f(3))

    /// 合成で変換と装飾を連結する。
    @Test
    def convertAndDecorate_composes(): Unit \ Assert =
        Assert.assertEq(expected = "[Fizz]", FizzBuzzPipeline.convertAndDecorate(3))

    /// パイプラインは各要素を変換・装飾する。
    @Test
    def process_pipeline(): Unit \ Assert =
        let result = FizzBuzzPipeline.process(5);
        Assert.assertEq(expected = Some("[Buzz]"), List.nth(4, result))

    /// パイプラインは元の範囲と同じ件数を返す。
    @Test
    def process_preserves_length(): Unit \ Assert =
        Assert.assertEq(expected = 15, List.length(FizzBuzzPipeline.process(15)))
}
