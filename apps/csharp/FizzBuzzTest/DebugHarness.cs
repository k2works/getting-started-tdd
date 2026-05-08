namespace FizzBuzzTest;

using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

public sealed record DebugTestCase(string Name, Action Invoke);

public static class DebugHarness
{
    public static int Run(
        string[] arguments,
        Func<IReadOnlyList<DebugTestCase>> discoverTests,
        Action<string[], TextWriter> runDefault,
        TextWriter standardOutput,
        TextWriter standardError)
    {
        if (arguments.Length == 1 && arguments[0] == "--list-tests")
        {
            return ListTests(discoverTests, standardOutput);
        }

        if (arguments.Length == 2 && arguments[0] == "--test")
        {
            return RunTestByPattern(arguments[1], discoverTests, standardError);
        }

        runDefault(arguments, standardOutput);
        return 0;
    }

    private static int ListTests(
        Func<IReadOnlyList<DebugTestCase>> discoverTests,
        TextWriter standardOutput)
    {
        foreach (var test in discoverTests().OrderBy(test => test.Name, StringComparer.Ordinal))
        {
            standardOutput.WriteLine(test.Name);
        }

        return 0;
    }

    private static int RunTestByPattern(
        string pattern,
        Func<IReadOnlyList<DebugTestCase>> discoverTests,
        TextWriter standardError)
    {
        var matches = discoverTests()
            .Where(test => test.Name.Contains(pattern, StringComparison.Ordinal))
            .OrderBy(test => test.Name, StringComparer.Ordinal)
            .ToArray();

        if (matches.Length == 0)
        {
            standardError.WriteLine($"No test matched: {pattern}");
            return 1;
        }

        if (matches.Length > 1)
        {
            standardError.WriteLine($"Multiple tests matched: {pattern}");

            foreach (var test in matches)
            {
                standardError.WriteLine($"  {test.Name}");
            }

            return 1;
        }

        matches[0].Invoke();
        return 0;
    }
}
