export LANG := C.UTF-8
export LC_ALL := C.UTF-8
export DOTNET_CLI_TELEMETRY_OPTOUT := 1
export DOTNET_NOLOGO := 1

SLN := FizzBuzz日本語.sln

.PHONY: test test-csharp test-fsharp build fmt-check lint lint-csharp lint-fsharp check clean

build:
	dotnet build $(SLN)

test:
	dotnet test $(SLN) --logger "console;verbosity=normal"

test-csharp:
	dotnet test FizzBuzz日本語.テスト --logger "console;verbosity=normal"

test-fsharp:
	dotnet test FizzBuzz日本語FSharp.テスト --logger "console;verbosity=normal"

fmt-check:
	dotnet format $(SLN) --verify-no-changes

lint: lint-csharp lint-fsharp

lint-csharp:
	dotnet build FizzBuzz日本語.テスト/FizzBuzz日本語.テスト.csproj --no-incremental -warnaserror:S3776
	dotnet format $(SLN) --verify-no-changes --severity info

lint-fsharp:
	dotnet tool restore
	dotnet dotnet-fsharplint lint --lint-config fsharplint.json FizzBuzz日本語FSharp/FizzBuzz日本語FSharp.fsproj
	dotnet dotnet-fsharplint lint --lint-config fsharplint.json FizzBuzz日本語FSharp.テスト/FizzBuzz日本語FSharp.テスト.fsproj

check: lint test

clean:
	dotnet clean $(SLN)
