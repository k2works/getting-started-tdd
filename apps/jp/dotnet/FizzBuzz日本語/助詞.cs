namespace FizzBuzz日本語;

/// <summary>助詞に見立てた拡張メソッドで「3を FizzBuzz変換して 装飾する」の語順を作る。</summary>
public static class 助詞
{
    public static TResult を<T, TResult>(this T 対象, Func<T, TResult> 処理) => 処理(対象);

    public static TResult して<T, TResult>(this T 対象, Func<T, TResult> 処理) => 処理(対象);
}
