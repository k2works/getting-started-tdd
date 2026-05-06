namespace FizzBuzz.Domain.Type;

public static class FizzBuzzTypeFactory
{
    public static IFizzBuzzType Create(FizzBuzzTypeName name)
    {
        return Create((int)name);
    }

    public static IFizzBuzzType Create(int type)
    {
        return type switch
        {
            1 => new FizzBuzzType01(),
            2 => new FizzBuzzType02(),
            3 => new FizzBuzzType03(),
            _ => throw new ArgumentException($"Invalid FizzBuzz type: {type}")
        };
    }
}
