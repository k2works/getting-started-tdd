package type_ //nolint:revive

import "testing"

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
