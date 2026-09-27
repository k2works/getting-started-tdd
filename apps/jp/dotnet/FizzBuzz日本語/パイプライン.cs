namespace FizzBuzz日本語;

/// <summary>題材 C: 「N を FizzBuzz変換して 装飾して 戻す」を拡張メソッドの連鎖で書く。</summary>
public static class パイプライン
{
    public static string 装飾(string 文字列) => $"[{文字列}]";

    public static string FizzBuzz装飾(int 数) => 数.を(FizzBuzz.FizzBuzz変換).して(装飾);

    public static IReadOnlyList<string> パイプライン処理(int 上限) =>
        Enumerable.Range(1, 上限).Select(FizzBuzz装飾).ToList();
}
