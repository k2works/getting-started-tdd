namespace FizzBuzz.Application;

using FizzBuzz.Domain.Model;
using FizzBuzz.Domain.Type;

public sealed class FizzBuzzListCommand : IFizzBuzzCommand
{
    private readonly IFizzBuzzType _type;

    public FizzBuzzListCommand(IFizzBuzzType type)
    {
        _type = type;
    }

    public FizzBuzzValue ExecuteValue(int number)
    {
        throw new NotSupportedException(
            "FizzBuzzListCommand does not support single value execution.");
    }

    public FizzBuzzList ExecuteList(int count)
    {
        var values = Enumerable.Range(1, count)
            .Select(i => _type.Generate(i))
            .ToList();

        return new FizzBuzzList(values);
    }
}
