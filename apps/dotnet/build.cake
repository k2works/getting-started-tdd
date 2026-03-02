var target = Argument("target", "Check");

Task("Clean")
    .Does(() =>
{
    DotNetClean("FizzBuzz.sln");
});

Task("Build")
    .IsDependentOn("Clean")
    .Does(() =>
{
    DotNetBuild("FizzBuzz.sln", new DotNetBuildSettings
    {
        NoRestore = false
    });
});

Task("Test")
    .IsDependentOn("Build")
    .Does(() =>
{
    DotNetTest("FizzBuzz.sln", new DotNetTestSettings
    {
        Verbosity = DotNetVerbosity.Minimal,
        NoRestore = true,
        NoBuild = true
    });
});

Task("Format")
    .Does(() =>
{
    StartProcess("dotnet", new ProcessSettings
    {
        Arguments = "format --verify-no-changes"
    });
});

Task("Complexity")
    .IsDependentOn("Build")
    .Does(() =>
{
    // C#: S3776 (認知的複雑度) を警告→エラーに昇格してビルド
    var exitCode = StartProcess("dotnet", new ProcessSettings
    {
        Arguments = "build FizzBuzz.sln --no-restore -warnaserror:S3776"
    });
    if (exitCode != 0)
    {
        throw new Exception("C# 認知的複雑度チェックに失敗しました。メソッドの複雑度を下げてください。");
    }
    Information("C# 認知的複雑度チェック: OK（全メソッドが閾値以下）");
});

Task("FSharpLint")
    .Does(() =>
{
    // F#: FSharpLint による循環的複雑度チェック（閾値 7）
    var exitCode = StartProcess("dotnet", new ProcessSettings
    {
        Arguments = "dotnet-fsharplint lint --lint-config fsharplint.json FizzBuzzFSharp/Library.fs"
    });
    if (exitCode != 0)
    {
        throw new Exception("FSharpLint チェックに失敗しました。F# コードの複雑度を下げてください。");
    }
    Information("FSharpLint チェック: OK（全関数が閾値以下）");
});

Task("Check")
    .IsDependentOn("Test")
    .IsDependentOn("Complexity")
    .IsDependentOn("FSharpLint");

RunTarget(target);
