namespace FizzBuzz日本語.テスト;

using FizzBuzz日本語;
using static FizzBuzz日本語.安全;

public class 安全変換のテスト
{
    [Fact(DisplayName = "正の数は成功になる")]
    public void 正の数は成功になる()
    {
        var 結果 = 安全変換(3);
        var 成功 = Assert.IsType<変換結果.成功>(結果);
        Assert.Equal("Fizz", 成功.値);
    }

    [Fact(DisplayName = "0は失敗になる")]
    public void 零は失敗になる()
    {
        var 結果 = 安全変換(0);
        var 失敗 = Assert.IsType<変換結果.失敗>(結果);
        Assert.Equal("正の数を指定してください: 0", 失敗.エラー);
    }

    [Fact(DisplayName = "switch 式で 成功・失敗 を振り分ける")]
    public void 成功と失敗をswitch式で振り分ける()
    {
        var 表示 = 安全変換(-1) switch
        {
            変換結果.成功(var 値) => 値,
            変換結果.失敗(var エラー) => $"失敗: {エラー}",
            _ => "",
        };
        Assert.Equal("失敗: 正の数を指定してください: -1", 表示);
    }
}
