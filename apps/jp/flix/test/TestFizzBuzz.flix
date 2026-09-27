///
/// 題材 A: FizzBuzz 変換のテスト。
/// Flix の識別子は ASCII のみのため、テスト名はローマ字で書き、なでしこ3 のテスト名はドキュメントコメントに残す。
///
mod TestFizzBuzz {
    /// 3を渡したらFizzを返す
    @Test
    def sanWoWatashitaraFizzWoKaesu(): Unit \ Assert =
        Assert.assertEq(expected = "Fizz", FizzBuzz.fizzBuzzHenkan(3))

    /// 5を渡したらBuzzを返す
    @Test
    def goWoWatashitaraBuzzWoKaesu(): Unit \ Assert =
        Assert.assertEq(expected = "Buzz", FizzBuzz.fizzBuzzHenkan(5))

    /// 15を渡したらFizzBuzzを返す
    @Test
    def juugoWoWatashitaraFizzBuzzWoKaesu(): Unit \ Assert =
        Assert.assertEq(expected = "FizzBuzz", FizzBuzz.fizzBuzzHenkan(15))

    /// 1を渡したら文字列1を返す
    @Test
    def ichiWoWatashitaraMojiretsu1WoKaesu(): Unit \ Assert =
        Assert.assertEq(expected = "1", FizzBuzz.fizzBuzzHenkan(1))

    /// 2を渡したら文字列2を返す
    @Test
    def niWoWatashitaraMojiretsu2WoKaesu(): Unit \ Assert =
        Assert.assertEq(expected = "2", FizzBuzz.fizzBuzzHenkan(2))

    /// 15まで作ると15件になる
    @Test
    def juugoMadeTsukuruTo15KenNiNaru(): Unit \ Assert =
        Assert.assertEq(expected = 15, List.length(FizzBuzz.fizzBuzzHairetsuSakusei(15)))

    /// 15まで作った配列の並び
    @Test
    def juugoMadeTsukuttaHairetsuNoNarabi(): Unit \ Assert =
        Assert.assertEq(
            expected = "1,2,Fizz,4,Buzz,Fizz,7,8,Fizz,Buzz,11,Fizz,13,14,FizzBuzz",
            String.intercalate(",", FizzBuzz.fizzBuzzHairetsuSakusei(15))
        )

    /// 3を FizzBuzz変換（助詞「を」を中置の関数で表す）
    @Test
    def joshiWoDeSanWoHenkanSuru(): Unit \ Assert =
        Assert.assertEq(expected = "Fizz", 3 `FizzBuzz.wo` FizzBuzz.fizzBuzzHenkan)
}
