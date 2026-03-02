namespace FizzBuzz;

using FizzBuzz.Application;
using FizzBuzz.Domain.Type;

public static class FizzBuzzRunner
{
    public static string Generate(int number)
    {
        var type = FizzBuzzTypeFactory.Create(FizzBuzzTypeName.Standard);
        var value = type.Generate(number);
        return value.Value;
    }

    public static List<string> GenerateList(int count)
    {
        var command = new FizzBuzzListCommand(
            FizzBuzzTypeFactory.Create(FizzBuzzTypeName.Standard));
        var list = command.ExecuteList(count);
        return list.ToStringValues();
    }
}
