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
    DotNetBuild("FizzBuzz.sln");
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

Task("Check")
    .IsDependentOn("Test");

RunTarget(target);
