mod TestFizzBuzzType {
    use Generatable.generate

    /// Type01: 1 を渡すと "1"。
    @Test
    def type01_1_returns_1(): Unit \ Assert =
        Assert.assertEq(expected = "1", generate(FizzBuzzType.Type01, 1))

    /// Type01: 3 の倍数で "Fizz"。
    @Test
    def type01_3_returns_Fizz(): Unit \ Assert =
        Assert.assertEq(expected = "Fizz", generate(FizzBuzzType.Type01, 3))

    /// Type01: 5 の倍数で "Buzz"。
    @Test
    def type01_5_returns_Buzz(): Unit \ Assert =
        Assert.assertEq(expected = "Buzz", generate(FizzBuzzType.Type01, 5))

    /// Type01: 15 の倍数で "FizzBuzz"。
    @Test
    def type01_15_returns_FizzBuzz(): Unit \ Assert =
        Assert.assertEq(expected = "FizzBuzz", generate(FizzBuzzType.Type01, 15))

    /// Type02: 数値をそのまま文字列にする。
    @Test
    def type02_3_returns_3(): Unit \ Assert =
        Assert.assertEq(expected = "3", generate(FizzBuzzType.Type02, 3))

    /// Type03: 1 を渡すと "1"。
    @Test
    def type03_1_returns_1(): Unit \ Assert =
        Assert.assertEq(expected = "1", generate(FizzBuzzType.Type03, 1))

    /// Type03: 3 で "Fizz"。
    @Test
    def type03_3_returns_Fizz(): Unit \ Assert =
        Assert.assertEq(expected = "Fizz", generate(FizzBuzzType.Type03, 3))

    /// Type03: 5 は Buzz にならず "5"。
    @Test
    def type03_5_returns_5(): Unit \ Assert =
        Assert.assertEq(expected = "5", generate(FizzBuzzType.Type03, 5))

    /// Type03: 15 の倍数で "FizzBuzz"。
    @Test
    def type03_15_returns_FizzBuzz(): Unit \ Assert =
        Assert.assertEq(expected = "FizzBuzz", generate(FizzBuzzType.Type03, 15))
}
