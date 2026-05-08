namespace FizzBuzzTest;

using System.Reflection;
using FizzBuzz;
using Xunit;

public static class Program
{
    public static int Main(string[] arguments)
    {
        return DebugHarness.Run(
            arguments,
            DiscoverTests,
            RunFizzBuzz,
            Console.Out,
            Console.Error);
    }

    private static IReadOnlyList<DebugTestCase> DiscoverTests()
    {
        return Assembly.GetExecutingAssembly()
            .GetTypes()
            .OrderBy(testType => testType.Name, StringComparer.Ordinal)
            .SelectMany(testType => testType
                .GetMethods(BindingFlags.Instance | BindingFlags.Public | BindingFlags.NonPublic)
                .Where(method =>
                    method.GetCustomAttributes(typeof(FactAttribute), true).Length > 0 &&
                    method.GetParameters().Length == 0)
                .Select(method => new DebugTestCase(
                    $"{testType.Name}.{method.Name}",
                    () => InvokeFact(testType, method))))
            .OrderBy(test => test.Name, StringComparer.Ordinal)
            .ToArray();
    }

    private static void InvokeFact(Type testType, MethodInfo method)
    {
        var instance = Activator.CreateInstance(testType) ??
            throw new InvalidOperationException($"Could not create test class: {testType.FullName}");
        var result = method.Invoke(instance, []);

        switch (result)
        {
            case Task task:
                task.GetAwaiter().GetResult();
                break;
            case ValueTask valueTask:
                valueTask.GetAwaiter().GetResult();
                break;
        }
    }

    private static void RunFizzBuzz(string[] arguments, TextWriter writer)
    {
        foreach (var item in FizzBuzzRunner.GenerateList(ParseCount(arguments)))
        {
            writer.WriteLine(item);
        }
    }

    private static int ParseCount(string[] arguments)
    {
        return arguments.Length > 0 &&
            int.TryParse(arguments[0], out var count) &&
            count > 0
            ? count
            : 15;
    }
}
