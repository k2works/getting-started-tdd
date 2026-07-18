mod TestFizzBuzz {
    /// 1 を渡したら文字列 "1" を返す。
    @Test
    def convert_1_returns_1(): Unit \ Assert =
        Assert.assertEq(expected = "1", FizzBuzz.convert(1))

    /// 2 を渡したら文字列 "2" を返す。
    @Test
    def convert_2_returns_2(): Unit \ Assert =
        Assert.assertEq(expected = "2", FizzBuzz.convert(2))

    /// 3 の倍数を渡したら "Fizz" を返す。
    @Test
    def convert_3_returns_Fizz(): Unit \ Assert =
        Assert.assertEq(expected = "Fizz", FizzBuzz.convert(3))

    /// 6 を渡したら "Fizz" を返す（三角測量）。
    @Test
    def convert_6_returns_Fizz(): Unit \ Assert =
        Assert.assertEq(expected = "Fizz", FizzBuzz.convert(6))

    /// 5 の倍数を渡したら "Buzz" を返す。
    @Test
    def convert_5_returns_Buzz(): Unit \ Assert =
        Assert.assertEq(expected = "Buzz", FizzBuzz.convert(5))

    /// 10 を渡したら "Buzz" を返す（三角測量）。
    @Test
    def convert_10_returns_Buzz(): Unit \ Assert =
        Assert.assertEq(expected = "Buzz", FizzBuzz.convert(10))

    /// 15 の倍数を渡したら "FizzBuzz" を返す。
    @Test
    def convert_15_returns_FizzBuzz(): Unit \ Assert =
        Assert.assertEq(expected = "FizzBuzz", FizzBuzz.convert(15))

    /// 30 を渡したら "FizzBuzz" を返す（三角測量）。
    @Test
    def convert_30_returns_FizzBuzz(): Unit \ Assert =
        Assert.assertEq(expected = "FizzBuzz", FizzBuzz.convert(30))

    /// 100 件のリストを生成する。
    @Test
    def generateList_has_100_elements(): Unit \ Assert =
        Assert.assertEq(expected = 100, List.length(FizzBuzz.generateList(100)))

    /// 最初の要素は "1"。
    @Test
    def generateList_first_is_1(): Unit \ Assert =
        Assert.assertEq(expected = Some("1"), List.nth(0, FizzBuzz.generateList(100)))

    /// 3 番目の要素は "Fizz"。
    @Test
    def generateList_third_is_Fizz(): Unit \ Assert =
        Assert.assertEq(expected = Some("Fizz"), List.nth(2, FizzBuzz.generateList(100)))

    /// 5 番目の要素は "Buzz"。
    @Test
    def generateList_fifth_is_Buzz(): Unit \ Assert =
        Assert.assertEq(expected = Some("Buzz"), List.nth(4, FizzBuzz.generateList(100)))

    /// 15 番目の要素は "FizzBuzz"。
    @Test
    def generateList_fifteenth_is_FizzBuzz(): Unit \ Assert =
        Assert.assertEq(expected = Some("FizzBuzz"), List.nth(14, FizzBuzz.generateList(100)))
}
