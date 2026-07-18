mod TestFizzBuzzValue {
    /// 値オブジェクトは数値を保持する。
    @Test
    def value_holds_number(): Unit \ Assert =
        let v = FizzBuzzValue.create(FizzBuzzType.Type01, 3);
        Assert.assertEq(expected = 3, FizzBuzzValue.number(v))

    /// 値オブジェクトは変換結果を保持する。
    @Test
    def value_holds_value(): Unit \ Assert =
        let v = FizzBuzzValue.create(FizzBuzzType.Type01, 3);
        Assert.assertEq(expected = "Fizz", FizzBuzzValue.value(v))

    /// 100 件のコレクションを生成する。
    @Test
    def list_has_100(): Unit \ Assert =
        let list = FizzBuzzList.create(100, FizzBuzzType.Type01);
        Assert.assertEq(expected = 100, FizzBuzzList.count(list))

    /// コレクションの 15 番目は "FizzBuzz"。
    @Test
    def list_15th_is_FizzBuzz(): Unit \ Assert =
        let list = FizzBuzzList.create(100, FizzBuzzType.Type01);
        let v = List.nth(14, FizzBuzzList.values(list));
        Assert.assertEq(expected = Some("FizzBuzz"), Option.map(FizzBuzzValue.value, v))
}
