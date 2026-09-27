///
/// 題材 B: タイプ生成のテスト。
///
mod TestTaipu {
    /// タイプ1は通常の変換をする
    @Test
    def taipu1WaTsuujouNoHenkanWoSuru(): Unit \ Assert =
        let kekka = Taipu.taipuSeisei(1) |> Result.map(t -> (Taipu.namae(t), Taipu.taipuHenkan(t, 3)));
        Assert.assertEq(expected = Ok(("通常", "Fizz")), kekka)

    /// タイプ2は数字だけを返す
    @Test
    def taipu2WaSuujiDakeWoKaesu(): Unit \ Assert =
        let kekka = Taipu.taipuSeisei(2) |> Result.map(t -> (Taipu.namae(t), Taipu.taipuHenkan(t, 3)));
        Assert.assertEq(expected = Ok(("数字限定", "3")), kekka)

    /// タイプ3は15の倍数だけFizzBuzzを返す
    @Test
    def taipu3Wa15NoBaisuDakeFizzBuzzWoKaesu(): Unit \ Assert =
        let kekka = Taipu.taipuSeisei(3) |> Result.map(t -> Taipu.taipuHenkan(t, 15));
        Assert.assertEq(expected = Ok("FizzBuzz"), kekka)

    /// タイプ3は3の倍数を数字で返す
    @Test
    def taipu3Wa3NoBaisuWoSuujiDeKaesu(): Unit \ Assert =
        let kekka = Taipu.taipuSeisei(3) |> Result.map(t -> Taipu.taipuHenkan(t, 3));
        Assert.assertEq(expected = Ok("3"), kekka)

    /// 存在しないタイプはエラーになる
    @Test
    def sonzaiShinaiTaipuWaEraNiNaru(): Unit \ Assert =
        let kekka = Taipu.taipuSeisei(4) |> Result.map(Taipu.namae);
        Assert.assertEq(expected = Err("該当するタイプは存在しません: 4"), kekka)
}
