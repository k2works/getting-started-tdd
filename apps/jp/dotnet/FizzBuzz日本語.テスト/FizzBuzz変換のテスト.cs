namespace FizzBuzz日本語.テスト;

using FizzBuzz日本語;

public class FizzBuzz変換のテスト
{
    [Fact(DisplayName = "3を渡したらFizzを返す")]
    public void 三を渡したらFizzを返す()
    {
        Assert.Equal("Fizz", FizzBuzz.FizzBuzz変換(3));
    }

    [Fact(DisplayName = "5を渡したらBuzzを返す")]
    public void 五を渡したらBuzzを返す()
    {
        Assert.Equal("Buzz", FizzBuzz.FizzBuzz変換(5));
    }

    [Fact(DisplayName = "15を渡したらFizzBuzzを返す")]
    public void 十五を渡したらFizzBuzzを返す()
    {
        Assert.Equal("FizzBuzz", FizzBuzz.FizzBuzz変換(15));
    }

    [Fact(DisplayName = "1を渡したら文字列1を返す")]
    public void 一を渡したら文字列1を返す()
    {
        Assert.Equal("1", FizzBuzz.FizzBuzz変換(1));
    }

    [Fact(DisplayName = "2を渡したら文字列2を返す")]
    public void 二を渡したら文字列2を返す()
    {
        Assert.Equal("2", FizzBuzz.FizzBuzz変換(2));
    }

    [Fact(DisplayName = "15まで作ると15件になる")]
    public void 十五まで作ると15件になる()
    {
        Assert.Equal(15, FizzBuzz.FizzBuzz配列作成(15).Count);
    }

    [Fact(DisplayName = "15まで作った配列の並び")]
    public void 十五まで作った配列の並び()
    {
        Assert.Equal(
            "1,2,Fizz,4,Buzz,Fizz,7,8,Fizz,Buzz,11,Fizz,13,14,FizzBuzz",
            string.Join(",", FizzBuzz.FizzBuzz配列作成(15)));
    }

    [Fact(DisplayName = "拡張メソッドで 3.FizzBuzz変換() と書ける")]
    public void 拡張メソッドで後置呼び出しできる()
    {
        Assert.Equal("Fizz", 3.FizzBuzz変換());
    }

    [Fact(DisplayName = "助詞メソッドで 3.を(FizzBuzz.FizzBuzz変換) と書ける")]
    public void 助詞メソッドでSOV順に書ける()
    {
        Assert.Equal("Fizz", 3.を(FizzBuzz.FizzBuzz変換));
    }
}
