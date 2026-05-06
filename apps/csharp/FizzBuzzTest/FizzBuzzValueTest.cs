namespace FizzBuzzTest;

using FizzBuzz.Domain.Model;

public class FizzBuzzValueTest
{
    [Fact]
    public void 値を保持する()
    {
        var value = new FizzBuzzValue(1, "1");

        Assert.Equal(1, value.Number);
        Assert.Equal("1", value.Value);
    }

    [Fact]
    public void 同じ値のオブジェクトは等しい()
    {
        var value1 = new FizzBuzzValue(1, "1");
        var value2 = new FizzBuzzValue(1, "1");

        Assert.Equal(value1, value2);
    }
}
