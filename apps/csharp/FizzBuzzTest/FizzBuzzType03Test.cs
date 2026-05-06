namespace FizzBuzzTest;

using FizzBuzz.Domain.Type;

public class FizzBuzzType03Test
{
    private readonly IFizzBuzzType _type = new FizzBuzzType03();

    [Fact]
    public void 十五の倍数のときだけFizzBuzzを返す()
    {
        Assert.Equal("1", _type.Generate(1).Value);
        Assert.Equal("3", _type.Generate(3).Value);
        Assert.Equal("5", _type.Generate(5).Value);
        Assert.Equal("FizzBuzz", _type.Generate(15).Value);
    }
}
