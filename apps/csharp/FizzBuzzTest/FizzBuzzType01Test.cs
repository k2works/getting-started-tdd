namespace FizzBuzzTest;

using FizzBuzz.Domain.Type;

public class FizzBuzzType01Test
{
    private readonly IFizzBuzzType _type = new FizzBuzzType01();

    [Fact]
    public void 数を文字列にして返す()
    {
        Assert.Equal("1", _type.Generate(1).Value);
    }

    [Fact]
    public void 三の倍数のときはFizzを返す()
    {
        Assert.Equal("Fizz", _type.Generate(3).Value);
    }

    [Fact]
    public void 五の倍数のときはBuzzを返す()
    {
        Assert.Equal("Buzz", _type.Generate(5).Value);
    }

    [Fact]
    public void 三と五の倍数のときはFizzBuzzを返す()
    {
        Assert.Equal("FizzBuzz", _type.Generate(15).Value);
    }
}
