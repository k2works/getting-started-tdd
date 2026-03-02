namespace FizzBuzz.Domain.Type;

using FizzBuzz.Domain.Model;

public interface IFizzBuzzType
{
    FizzBuzzValue Generate(int number);
}
