package type_

import "testing"

func TestFizzBuzzType01_Generate_3の倍数でFizzを返す(t *testing.T) {
	fbt := FizzBuzzType01{}
	got := fbt.Generate(3)
	if got.Value() != "Fizz" {
		t.Fatalf("Generate(3).Value() = %q, want %q", got.Value(), "Fizz")
	}
}

func TestFizzBuzzType01_Generate_5の倍数でBuzzを返す(t *testing.T) {
	fbt := FizzBuzzType01{}
	got := fbt.Generate(5)
	if got.Value() != "Buzz" {
		t.Fatalf("Generate(5).Value() = %q, want %q", got.Value(), "Buzz")
	}
}

func TestFizzBuzzType01_Generate_15の倍数でFizzBuzzを返す(t *testing.T) {
	fbt := FizzBuzzType01{}
	got := fbt.Generate(15)
	if got.Value() != "FizzBuzz" {
		t.Fatalf("Generate(15).Value() = %q, want %q", got.Value(), "FizzBuzz")
	}
}

func TestFizzBuzzType02_Generate_常に数値を返す(t *testing.T) {
	fbt := FizzBuzzType02{}
	got := fbt.Generate(3)
	if got.Value() != "3" {
		t.Fatalf("Generate(3).Value() = %q, want %q", got.Value(), "3")
	}
}

func TestFizzBuzzType03_Generate_FizzBuzzのみ返す(t *testing.T) {
	fbt := FizzBuzzType03{}
	got := fbt.Generate(15)
	if got.Value() != "FizzBuzz" {
		t.Fatalf("Generate(15).Value() = %q, want %q", got.Value(), "FizzBuzz")
	}
}

func TestFizzBuzzType03_Generate_FizzBuzz以外は数値を返す(t *testing.T) {
	fbt := FizzBuzzType03{}
	got := fbt.Generate(3)
	if got.Value() != "3" {
		t.Fatalf("Generate(3).Value() = %q, want %q", got.Value(), "3")
	}
}

func TestNewFizzBuzzType_タイプ1を生成する(t *testing.T) {
	fbt := NewFizzBuzzType(1)
	got := fbt.Generate(3)
	if got.Value() != "Fizz" {
		t.Fatalf("got.Value() = %q, want %q", got.Value(), "Fizz")
	}
}

func TestNewFizzBuzzType_不正なタイプでパニックする(t *testing.T) {
	defer func() {
		if r := recover(); r == nil {
			t.Fatal("should panic for invalid type")
		}
	}()
	NewFizzBuzzType(99)
}

func TestTryNewFizzBuzzType_正常なタイプを生成できる(t *testing.T) {
	fbt, err := TryNewFizzBuzzType(1)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	got := fbt.Generate(3)
	if got.Value() != "Fizz" {
		t.Fatalf("got.Value() = %q, want %q", got.Value(), "Fizz")
	}
}

func TestTryNewFizzBuzzType_不正なタイプでエラーを返す(t *testing.T) {
	_, err := TryNewFizzBuzzType(99)
	if err == nil {
		t.Fatal("expected error for invalid type")
	}
}

func TestDescribeFizzBuzzType_タイプ名を返す(t *testing.T) {
	tests := []struct {
		input int
		want  string
	}{
		{1, "Standard"},
		{2, "NumberOnly"},
		{3, "FizzBuzzOnly"},
	}

	for _, tt := range tests {
		fbt := NewFizzBuzzType(tt.input)
		got := DescribeFizzBuzzType(fbt)
		if got != tt.want {
			t.Errorf("DescribeFizzBuzzType(%d) = %q, want %q", tt.input, got, tt.want)
		}
	}
}

func TestFizzBuzzTypeName_型安全にタイプを生成する(t *testing.T) {
	fbt := CreateFizzBuzzType(FizzBuzzTypeStandard)
	got := fbt.Generate(3)
	if got.Value() != "Fizz" {
		t.Fatalf("got.Value() = %q, want %q", got.Value(), "Fizz")
	}
}

func TestFizzBuzzTypeName_全てのタイプを生成できる(t *testing.T) {
	types := []FizzBuzzTypeName{
		FizzBuzzTypeStandard,
		FizzBuzzTypeNumberOnly,
		FizzBuzzTypeFizzBuzzOnly,
	}

	for _, tn := range types {
		fbt := CreateFizzBuzzType(tn)
		if fbt == nil {
			t.Fatalf("CreateFizzBuzzType(%v) should not return nil", tn)
		}
	}
}
