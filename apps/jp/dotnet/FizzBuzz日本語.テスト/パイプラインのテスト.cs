namespace FizzBuzz日本語.テスト;

using FizzBuzz日本語;
using static FizzBuzz日本語.パイプライン;

public class パイプラインのテスト
{
    [Fact(DisplayName = "装飾すると角括弧で囲む")]
    public void 装飾すると角括弧で囲む()
    {
        Assert.Equal("[Fizz]", 装飾("Fizz"));
    }

    [Fact(DisplayName = "5までのパイプライン処理")]
    public void 五までのパイプライン処理()
    {
        Assert.Equal(["[1]", "[2]", "[Fizz]", "[4]", "[Buzz]"], パイプライン処理(5));
    }

    [Fact(DisplayName = "15を FizzBuzz変換して 装飾する")]
    public void 変換してから装飾する()
    {
        Assert.Equal("[FizzBuzz]", FizzBuzz装飾(15));
    }
}
