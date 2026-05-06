namespace FizzBuzzTest;

using FizzBuzz;
using System.IO;

public class FizzBuzzRunnerTest
{
    [Fact]
    public void 数を文字列にして返す_1を渡したら文字列1を返す()
    {
        Assert.Equal("1", FizzBuzzRunner.Generate(1));
    }

    [Fact]
    public void 数を文字列にして返す_2を渡したら文字列2を返す()
    {
        Assert.Equal("2", FizzBuzzRunner.Generate(2));
    }

    [Fact]
    public void 三の倍数のときはFizzを返す_3を渡したらFizzを返す()
    {
        Assert.Equal("Fizz", FizzBuzzRunner.Generate(3));
    }

    [Fact]
    public void 五の倍数のときはBuzzを返す_5を渡したらBuzzを返す()
    {
        Assert.Equal("Buzz", FizzBuzzRunner.Generate(5));
    }

    [Fact]
    public void 三と五の倍数のときはFizzBuzzを返す_15を渡したらFizzBuzzを返す()
    {
        Assert.Equal("FizzBuzz", FizzBuzzRunner.Generate(15));
    }

    [Fact]
    public void 一から百までのリストを生成する()
    {
        var list = FizzBuzzRunner.GenerateList(100);

        Assert.Equal(100, list.Count);
        Assert.Equal("1", list[0]);
        Assert.Equal("Fizz", list[2]);
        Assert.Equal("Buzz", list[4]);
        Assert.Equal("FizzBuzz", list[14]);
    }

    [Fact]
    public void 学習用テスト_StringWriterで出力をキャプチャできる()
    {
        var writer = new StringWriter();

        writer.WriteLine("hello");

        Assert.Contains("hello", writer.ToString());
    }

    [Fact]
    public void FizzBuzzの結果を出力する()
    {
        var writer = new StringWriter();

        FizzBuzzRunner.PrintFizzBuzz(writer);

        var output = writer.ToString();

        Assert.Contains("1", output);
        Assert.Contains("Fizz", output);
        Assert.Contains("Buzz", output);
        Assert.Contains("FizzBuzz", output);
    }
}
