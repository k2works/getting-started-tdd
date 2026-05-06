namespace FizzBuzz;

using System.Collections.Generic;
using System.IO;
using System.Linq;

public static class FizzBuzzRunner
{
    private const int FizzNumber = 3;
    private const int BuzzNumber = 5;

    public static string Generate(int number)
    {
        if (IsFizzBuzz(number))
        {
            return "FizzBuzz";
        }

        if (IsFizz(number))
        {
            return "Fizz";
        }

        if (IsBuzz(number))
        {
            return "Buzz";
        }

        return number.ToString();
    }

    public static List<string> GenerateList(int count)
    {
        return Enumerable.Range(1, count)
            .Select(Generate)
            .ToList();
    }

    public static void PrintFizzBuzz(TextWriter writer)
    {
        foreach (var item in GenerateList(100))
        {
            writer.WriteLine(item);
        }
    }

    private static bool IsFizz(int number) => number % FizzNumber == 0;

    private static bool IsBuzz(int number) => number % BuzzNumber == 0;

    private static bool IsFizzBuzz(int number) => IsFizz(number) && IsBuzz(number);
}
