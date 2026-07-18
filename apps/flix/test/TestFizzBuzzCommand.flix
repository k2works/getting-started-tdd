mod TestFizzBuzzCommand {
    /// ValueCommand は単一要素のコレクションを返す。
    @Test
    def value_command_returns_single(): Unit \ Assert =
        let cmd = FizzBuzzCommand.ValueCommand(FizzBuzzType.Type01);
        let result = FizzBuzzCommand.execute(cmd, 3);
        Assert.assertEq(expected = 1, FizzBuzzList.count(result))

    /// ValueCommand の要素はタイプに従って変換される。
    @Test
    def value_command_converts(): Unit \ Assert =
        let cmd = FizzBuzzCommand.ValueCommand(FizzBuzzType.Type01);
        let result = FizzBuzzCommand.execute(cmd, 3);
        let v = List.nth(0, FizzBuzzList.values(result));
        Assert.assertEq(expected = Some("Fizz"), Option.map(FizzBuzzValue.value, v))

    /// ListCommand は 1 から n までのコレクションを返す。
    @Test
    def list_command_returns_n(): Unit \ Assert =
        let cmd = FizzBuzzCommand.ListCommand(FizzBuzzType.Type01);
        let result = FizzBuzzCommand.execute(cmd, 100);
        Assert.assertEq(expected = 100, FizzBuzzList.count(result))
}
