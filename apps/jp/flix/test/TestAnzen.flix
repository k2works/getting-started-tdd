///
/// 題材 D: 安全変換のテスト。
/// 「数値でなければ失敗になる」は、引数が Int32 のため型検査で弾かれるので書かない。
///
mod TestAnzen {
    /// 正の数は成功になる
    @Test
    def seiNoSuuWaSeikouNiNaru(): Unit \ Assert =
        Assert.assertEq(expected = Ok("Fizz"), Anzen.anzenHenkan(3))

    /// 0は失敗になる
    @Test
    def zeroWaShippaiNiNaru(): Unit \ Assert =
        Assert.assertEq(expected = Err("正の数を指定してください: 0"), Anzen.anzenHenkan(0))
}
