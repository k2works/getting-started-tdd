namespace FizzBuzz.Application;

using FizzBuzz.Domain.Model;
using FizzBuzz.Domain.Type;

public class FizzBuzzValueCommand : IFizzBuzzCommand
{
    private readonly IFizzBuzzType _type;

    public FizzBuzzValueCommand(IFizzBuzzType type)
    {
        _type = type;
    }

    public FizzBuzzValue ExecuteValue(int number)
    {
        return _type.Generate(number);
    }

    public FizzBuzzList ExecuteList(int count)
    {
        throw new NotSupportedException("FizzBuzzValueCommand does not support list execution.");
    }
}
