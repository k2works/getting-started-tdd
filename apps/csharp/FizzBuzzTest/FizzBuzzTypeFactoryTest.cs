namespace FizzBuzzTest;

using FizzBuzz.Domain.Type;

public class FizzBuzzTypeFactoryTest
{
    [Fact]
    public void タイプ1を生成できる()
    {
        Assert.IsType<FizzBuzzType01>(FizzBuzzTypeFactory.Create(1));
    }

    [Fact]
    public void タイプ2を生成できる()
    {
        Assert.IsType<FizzBuzzType02>(FizzBuzzTypeFactory.Create(2));
    }

    [Fact]
    public void タイプ3を生成できる()
    {
        Assert.IsType<FizzBuzzType03>(FizzBuzzTypeFactory.Create(3));
    }

    [Fact]
    public void enumでタイプ1を生成できる()
    {
        Assert.IsType<FizzBuzzType01>(
            FizzBuzzTypeFactory.Create(FizzBuzzTypeName.Standard));
    }

    [Fact]
    public void 不正なタイプは例外を投げる()
    {
        Assert.Throws<ArgumentException>(
            () => FizzBuzzTypeFactory.Create(0));
    }
}
