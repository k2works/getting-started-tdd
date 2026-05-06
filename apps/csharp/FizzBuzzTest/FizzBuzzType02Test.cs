namespace FizzBuzzTest;

using FizzBuzz.Domain.Type;

public class FizzBuzzType02Test
{
    private readonly IFizzBuzzType _type = new FizzBuzzType02();

    [Fact]
    public void 常に数値文字列を返す()
    {
        Assert.Equal("1", _type.Generate(1).Value);
        Assert.Equal("3", _type.Generate(3).Value);
        Assert.Equal("5", _type.Generate(5).Value);
        Assert.Equal("15", _type.Generate(15).Value);
    }
}
