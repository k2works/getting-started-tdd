namespace FizzBuzz.Domain.Type;

using FizzBuzz.Domain.Model;

public sealed class FizzBuzzType02 : IFizzBuzzType
{
    public FizzBuzzValue Generate(int number)
    {
        return new FizzBuzzValue(number, number.ToString());
    }
}
