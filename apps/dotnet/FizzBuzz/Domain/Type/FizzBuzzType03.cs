namespace FizzBuzz.Domain.Type;

using FizzBuzz.Domain.Model;

public class FizzBuzzType03 : IFizzBuzzType
{
    private const int FizzBuzzNumber = 15;

    public FizzBuzzValue Generate(int number)
    {
        var value = number % FizzBuzzNumber == 0 ? "FizzBuzz" : number.ToString();
        return new FizzBuzzValue(number, value);
    }
}
