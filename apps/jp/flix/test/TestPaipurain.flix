///
/// 題材 C: パイプラインのテスト。
///
mod TestPaipurain {
    /// 装飾すると角括弧で囲む
    @Test
    def soushokuSuruToKakukakkoDeKakomu(): Unit \ Assert =
        Assert.assertEq(expected = "[Fizz]", Paipurain.soushoku("Fizz"))

    /// 5までのパイプライン処理
    @Test
    def goMadeNoPaipurainShori(): Unit \ Assert =
        Assert.assertEq(expected = List#{"[1]", "[2]", "[Fizz]", "[4]", "[Buzz]"}, Paipurain.paipurainShori(5))
}
