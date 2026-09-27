namespace FizzBuzz日本語;

/// <summary>題材 D: 成功と失敗を表す結果型。</summary>
public abstract record 変換結果
{
    private 変換結果()
    {
    }

    public sealed record 成功(string 値) : 変換結果;

    public sealed record 失敗(string エラー) : 変換結果;
}

public static class 安全
{
    public static 変換結果 安全変換(int 数) =>
        数 <= 0
            ? new 変換結果.失敗($"正の数を指定してください: {数}")
            : new 変換結果.成功(数.FizzBuzz変換());
}
