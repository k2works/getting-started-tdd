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
    // S3776 (認知的複雑度) を警告→エラーに昇格してビルド
    // 閾値はデフォルト 15 だが、.editorconfig で warning に設定済み
    var exitCode = StartProcess("dotnet", new ProcessSettings
    {
        Arguments = "build FizzBuzz.sln --no-restore -warnaserror:S3776"
    });
    if (exitCode != 0)
    {
        throw new Exception("認知的複雑度チェックに失敗しました。メソッドの複雑度を下げてください。");
    }
    Information("認知的複雑度チェック: OK（全メソッドが閾値以下）");
});

Task("Check")
    .IsDependentOn("Test")
    .IsDependentOn("Complexity");

RunTarget(target);
