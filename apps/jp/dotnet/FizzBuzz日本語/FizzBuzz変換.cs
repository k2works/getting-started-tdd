namespace FizzBuzz日本語;

/// <summary>題材 A: FizzBuzz の基本変換。</summary>
public static class FizzBuzz
{
    public static string FizzBuzz変換(this int 数)
    {
        if (数 % 15 == 0)
        {
            return "FizzBuzz";
        }

        if (数 % 3 == 0)
        {
            return "Fizz";
        }

        if (数 % 5 == 0)
        {
            return "Buzz";
        }

        return 数.ToString();
    }

    public static IReadOnlyList<string> FizzBuzz配列作成(int 上限) =>
        Enumerable.Range(1, 上限).Select(FizzBuzz変換).ToList();
}
