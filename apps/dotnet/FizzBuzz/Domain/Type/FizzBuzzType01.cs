namespace FizzBuzz.Domain.Type;

using FizzBuzz.Domain.Model;

public class FizzBuzzType01 : IFizzBuzzType
{
    private const int FizzNumber = 3;
    private const int BuzzNumber = 5;

    public FizzBuzzValue Generate(int number)
    {
        string value;
        if (IsFizzBuzz(number))
            value = "FizzBuzz";
        else if (IsFizz(number))
            value = "Fizz";
        else if (IsBuzz(number))
            value = "Buzz";
        else
            value = number.ToString();

        return new FizzBuzzValue(number, value);
    }

    private static bool IsFizz(int number) => number % FizzNumber == 0;
    private static bool IsBuzz(int number) => number % BuzzNumber == 0;
    private static bool IsFizzBuzz(int number) => IsFizz(number) && IsBuzz(number);
}
