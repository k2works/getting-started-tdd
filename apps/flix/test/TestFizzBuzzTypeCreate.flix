mod TestFizzBuzzTypeCreate {
    /// 1 は Type01 を返す。
    @Test
    def create_1_is_Type01(): Unit \ Assert =
        Assert.assertEq(expected = Ok(FizzBuzzType.Type01), FizzBuzzType.create(1))

    /// 2 は Type02 を返す。
    @Test
    def create_2_is_Type02(): Unit \ Assert =
        Assert.assertEq(expected = Ok(FizzBuzzType.Type02), FizzBuzzType.create(2))

    /// 3 は Type03 を返す。
    @Test
    def create_3_is_Type03(): Unit \ Assert =
        Assert.assertEq(expected = Ok(FizzBuzzType.Type03), FizzBuzzType.create(3))

    /// 未定義の番号は Err を返す。
    @Test
    def create_99_is_Err(): Unit \ Assert =
        Assert.assertEq(expected = true, Result.isErr(FizzBuzzType.create(99)))
}
