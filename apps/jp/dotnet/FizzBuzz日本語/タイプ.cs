namespace FizzBuzz日本語;

public enum タイプ番号
{
    通常 = 1,
    数字限定 = 2,
    FizzBuzz限定 = 3,
}

/// <summary>題材 B: 名前と変換関数を持つタイプ。</summary>
public sealed record タイプ(string 名前, Func<int, string> 変換)
{
    public static タイプ タイプ生成(int 番号) => 番号 switch
    {
        1 => new タイプ("通常", FizzBuzz.FizzBuzz変換),
        2 => new タイプ("数字限定", 数字限定変換),
        3 => new タイプ("FizzBuzz限定", FizzBuzz限定変換),
        _ => throw new タイプ未定義例外(番号),
    };

    public static タイプ タイプ生成(タイプ番号 番号) => タイプ生成((int)番号);

    public static string タイプ変換(タイプ 種類, int 数) => 種類.変換(数);

    private static string 数字限定変換(int 数) => 数.ToString();

    private static string FizzBuzz限定変換(int 数) => 数 % 15 == 0 ? "FizzBuzz" : 数.ToString();
}

public sealed class タイプ未定義例外(int 番号) : Exception($"該当するタイプは存在しません: {番号}");
