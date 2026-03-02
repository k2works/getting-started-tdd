namespace FizzBuzz.Application;

using FizzBuzz.Domain.Model;

public interface IFizzBuzzCommand
{
    FizzBuzzValue ExecuteValue(int number);
    FizzBuzzList ExecuteList(int count);
}
