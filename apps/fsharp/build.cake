var target = Argument("target", "Default");

var libraryProject = "./FizzBuzzFSharp/FizzBuzzFSharp.fsproj";
var testProject = "./FizzBuzzFSharpTest/FizzBuzzFSharpTest.fsproj";

void RunDotNetOrThrow(string arguments)
{
    var exitCode = StartProcess("dotnet", new ProcessSettings
    {
        Arguments = arguments
    });

    if (exitCode != 0)
    {
        throw new Exception($"Command failed: dotnet {arguments}");
    }
}

Task("Clean")
    .Does(() =>
{
    DotNetClean(libraryProject);
    DotNetClean(testProject);
});

Task("Restore")
    .Does(() =>
{
    DotNetRestore(libraryProject);
    DotNetRestore(testProject);
});

Task("Format")
    .Does(() =>
{
    RunDotNetOrThrow("fantomas FizzBuzzFSharp FizzBuzzFSharpTest");
});

Task("Format-Check")
    .Does(() =>
{
    RunDotNetOrThrow("fantomas --check FizzBuzzFSharp FizzBuzzFSharpTest");
});

Task("Build")
    .IsDependentOn("Restore")
    .Does(() =>
{
    DotNetBuild(libraryProject, new DotNetBuildSettings
    {
        NoRestore = true
    });

    DotNetBuild(testProject, new DotNetBuildSettings
    {
        NoRestore = true
    });
});

Task("Test")
    .IsDependentOn("Build")
    .Does(() =>
{
    DotNetTest(testProject, new DotNetTestSettings
    {
        NoRestore = true,
        NoBuild = true
    });
});

Task("FSharpLint")
    .Does(() =>
{
    RunDotNetOrThrow("dotnet-fsharplint lint --lint-config fsharplint.json FizzBuzzFSharp/Library.fs");
});

Task("Check")
    .IsDependentOn("Format-Check")
    .IsDependentOn("Build")
    .IsDependentOn("Test")
    .IsDependentOn("FSharpLint");

Task("Default")
    .IsDependentOn("Check");

RunTarget(target);
