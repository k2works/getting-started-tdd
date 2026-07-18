mod TestFizzBuzzHof {
    /// generateWith は渡したルールで変換する。
    @Test
    def generateWith_uses_rule(): Unit \ Assert =
        Assert.assertEq(expected = "Fizz", FizzBuzzHof.generateWith(FizzBuzzHof.defaultRule, 3))

    /// generateWith にカスタムルールを渡せる。
    @Test
    def generateWith_custom_rule(): Unit \ Assert =
        let rule = n -> if (Int32.remainder(n, 2) == 0) "Even" else "Odd";
        Assert.assertEq(expected = "Even", FizzBuzzHof.generateWith(rule, 4))

    /// transform は 1..n をルールで変換する。
    @Test
    def transform_maps_range(): Unit \ Assert =
        let result = FizzBuzzHof.transform(FizzBuzzHof.defaultRule, 5);
        Assert.assertEq(expected = "Fizz" :: Nil, List.drop(2, result) |> List.take(1))

    /// filterList は述語で絞り込む。
    @Test
    def filterList_filters(): Unit \ Assert =
        let xs = FizzBuzzHof.transform(FizzBuzzHof.defaultRule, 15);
        let fizzes = FizzBuzzHof.filterList(s -> s == "Fizz", xs);
        Assert.assertEq(expected = 4, List.length(fizzes))
}
