namespace FizzBuzzTest;

using FizzBuzz.Application;
using FizzBuzz.Domain.Type;

public class FizzBuzzCommandTest
{
    [Fact]
    public void ValueCommandで単一値を取得できる()
    {
        var command = new FizzBuzzValueCommand(FizzBuzzTypeFactory.Create(1));
        var result = command.ExecuteValue(3);

        Assert.Equal("Fizz", result.Value);
    }

    [Fact]
    public void ListCommandでリストを生成できる()
    {
        var command = new FizzBuzzListCommand(FizzBuzzTypeFactory.Create(1));
        var result = command.ExecuteList(100);

        Assert.Equal(100, result.Count);
    }
}
