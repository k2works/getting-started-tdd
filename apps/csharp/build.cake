var target = Argument("target", "Default");

var libraryProject = "./FizzBuzz/FizzBuzz.csproj";
var testProject = "./FizzBuzzTest/FizzBuzzTest.csproj";

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

Task("Format-Check")
    .Does(() =>
{
    RunDotNetOrThrow("format FizzBuzz/FizzBuzz.csproj --verify-no-changes");
    RunDotNetOrThrow("format FizzBuzzTest/FizzBuzzTest.csproj --verify-no-changes");
});

Task("Check")
    .IsDependentOn("Format-Check")
    .IsDependentOn("Build")
    .IsDependentOn("Test");

Task("Default")
    .IsDependentOn("Check");

RunTarget(target);
