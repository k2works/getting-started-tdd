namespace FizzBuzzTest;

using System.IO;

public class DebugHarnessTest
{
    [Fact]
    public void list_tests_テスト名をソートして出力する()
    {
        var standardOutput = new StringWriter();
        var standardError = new StringWriter();

        var exitCode = DebugHarness.Run(
            ["--list-tests"],
            () =>
            [
                new DebugTestCase("Tests.Zeta", () => { }),
                new DebugTestCase("Tests.Alpha", () => { }),
            ],
            (_, _) => throw new InvalidOperationException("default runner should not be called"),
            standardOutput,
            standardError);

        Assert.Equal(0, exitCode);
        Assert.Equal($"Tests.Alpha{Environment.NewLine}Tests.Zeta{Environment.NewLine}", standardOutput.ToString());
        Assert.Equal(string.Empty, standardError.ToString());
    }

    [Fact]
    public void test_単一一致したテストだけを実行する()
    {
        var wasInvoked = false;

        var exitCode = DebugHarness.Run(
            ["--test", "Alpha"],
            () =>
            [
                new DebugTestCase("Tests.Alpha", () => wasInvoked = true),
                new DebugTestCase("Tests.Beta", () => throw new InvalidOperationException("unexpected test invocation")),
            ],
            (_, _) => throw new InvalidOperationException("default runner should not be called"),
            new StringWriter(),
            new StringWriter());

        Assert.Equal(0, exitCode);
        Assert.True(wasInvoked);
    }

    [Fact]
    public void test_一致しない場合はエラーを返す()
    {
        var standardError = new StringWriter();

        var exitCode = DebugHarness.Run(
            ["--test", "Gamma"],
            () => [new DebugTestCase("Tests.Alpha", () => { })],
            (_, _) => throw new InvalidOperationException("default runner should not be called"),
            new StringWriter(),
            standardError);

        Assert.Equal(1, exitCode);
        Assert.Equal($"No test matched: Gamma{Environment.NewLine}", standardError.ToString());
    }

    [Fact]
    public void test_複数一致した場合は候補を表示してエラーを返す()
    {
        var standardError = new StringWriter();

        var exitCode = DebugHarness.Run(
            ["--test", "Alpha"],
            () =>
            [
                new DebugTestCase("Tests.Alpha", () => { }),
                new DebugTestCase("Tests.AlphaExtra", () => { }),
            ],
            (_, _) => throw new InvalidOperationException("default runner should not be called"),
            new StringWriter(),
            standardError);

        Assert.Equal(1, exitCode);
        Assert.Equal(
            $"Multiple tests matched: Alpha{Environment.NewLine}  Tests.Alpha{Environment.NewLine}  Tests.AlphaExtra{Environment.NewLine}",
            standardError.ToString());
    }

    [Fact]
    public void 通常実行ではデフォルトランナーを呼び出す()
    {
        var standardOutput = new StringWriter();
        var wasInvoked = false;
        string[]? actualArguments = null;

        var exitCode = DebugHarness.Run(
            ["15"],
            () => [],
            (arguments, output) =>
            {
                wasInvoked = true;
                actualArguments = arguments;
                output.Write("ran");
            },
            standardOutput,
            new StringWriter());

        Assert.Equal(0, exitCode);
        Assert.True(wasInvoked);
        Assert.Equal(["15"], actualArguments);
        Assert.Equal("ran", standardOutput.ToString());
    }
}
