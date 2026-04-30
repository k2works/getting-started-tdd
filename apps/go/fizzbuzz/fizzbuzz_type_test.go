package fizzbuzz

import "testing"

func TestBasicGenerate_タイプ1_数を文字列に変換する(t *testing.T) {
	got := BasicGenerate(1, 1)
	if got != "1" {
		t.Fatalf("BasicGenerate(1, 1) = %q, want %q", got, "1")
	}
}

func TestBasicGenerate_タイプ1_3の倍数でFizzを返す(t *testing.T) {
	got := BasicGenerate(3, 1)
	if got != "Fizz" {
		t.Fatalf("BasicGenerate(3, 1) = %q, want %q", got, "Fizz")
	}
}

func TestBasicGenerate_タイプ1_5の倍数でBuzzを返す(t *testing.T) {
	got := BasicGenerate(5, 1)
	if got != "Buzz" {
		t.Fatalf("BasicGenerate(5, 1) = %q, want %q", got, "Buzz")
	}
}

func TestBasicGenerate_タイプ1_15の倍数でFizzBuzzを返す(t *testing.T) {
	got := BasicGenerate(15, 1)
	if got != "FizzBuzz" {
		t.Fatalf("BasicGenerate(15, 1) = %q, want %q", got, "FizzBuzz")
	}
}

func TestBasicGenerate_タイプ2_数を文字列に変換する(t *testing.T) {
	got := BasicGenerate(3, 2)
	if got != "3" {
		t.Fatalf("BasicGenerate(3, 2) = %q, want %q", got, "3")
	}
}

func TestBasicGenerate_タイプ3_FizzBuzzのみ返す(t *testing.T) {
	got := BasicGenerate(15, 3)
	if got != "FizzBuzz" {
		t.Fatalf("BasicGenerate(15, 3) = %q, want %q", got, "FizzBuzz")
	}
}

func TestBasicGenerate_タイプ3_FizzBuzz以外は数値を返す(t *testing.T) {
	got := BasicGenerate(3, 3)
	if got != "3" {
		t.Fatalf("BasicGenerate(3, 3) = %q, want %q", got, "3")
	}
}

func TestBasicGenerate_不正なタイプでパニックする(t *testing.T) {
	defer func() {
		if r := recover(); r == nil {
			t.Fatal("BasicGenerate(1, 99) should panic")
		}
	}()
	BasicGenerate(1, 99)
}

func TestFizzBuzzType01_Generate_数を文字列に変換する(t *testing.T) {
	fizzBuzzType := FizzBuzzType01{}
	got := fizzBuzzType.Generate(1)
	if got.Value() != "1" {
		t.Fatalf("FizzBuzzType01.Generate(1).Value() = %q, want %q", got.Value(), "1")
	}
}

func TestFizzBuzzType01_Generate_3の倍数でFizzを返す(t *testing.T) {
	fizzBuzzType := FizzBuzzType01{}
	got := fizzBuzzType.Generate(3)
	if got.Value() != "Fizz" {
		t.Fatalf("FizzBuzzType01.Generate(3).Value() = %q, want %q", got.Value(), "Fizz")
	}
}

func TestFizzBuzzType02_Generate_常に数値を返す(t *testing.T) {
	fizzBuzzType := FizzBuzzType02{}
	got := fizzBuzzType.Generate(3)
	if got.Value() != "3" {
		t.Fatalf("FizzBuzzType02.Generate(3).Value() = %q, want %q", got.Value(), "3")
	}
}

func TestFizzBuzzType03_Generate_FizzBuzzのみ返す(t *testing.T) {
	fizzBuzzType := FizzBuzzType03{}
	got := fizzBuzzType.Generate(15)
	if got.Value() != "FizzBuzz" {
		t.Fatalf("FizzBuzzType03.Generate(15).Value() = %q, want %q", got.Value(), "FizzBuzz")
	}
}

func TestFizzBuzzType03_Generate_FizzBuzz以外は数値を返す(t *testing.T) {
	fizzBuzzType := FizzBuzzType03{}
	got := fizzBuzzType.Generate(3)
	if got.Value() != "3" {
		t.Fatalf("FizzBuzzType03.Generate(3).Value() = %q, want %q", got.Value(), "3")
	}
}

func TestNewFizzBuzzType_タイプ1を生成する(t *testing.T) {
	fbt := NewFizzBuzzType(1)
	got := fbt.Generate(3)
	if got.Value() != "Fizz" {
		t.Fatalf("NewFizzBuzzType(1).Generate(3).Value() = %q, want %q", got.Value(), "Fizz")
	}
}

func TestNewFizzBuzzType_タイプ2を生成する(t *testing.T) {
	fbt := NewFizzBuzzType(2)
	got := fbt.Generate(3)
	if got.Value() != "3" {
		t.Fatalf("NewFizzBuzzType(2).Generate(3).Value() = %q, want %q", got.Value(), "3")
	}
}

func TestNewFizzBuzzType_タイプ3を生成する(t *testing.T) {
	fbt := NewFizzBuzzType(3)
	got := fbt.Generate(15)
	if got.Value() != "FizzBuzz" {
		t.Fatalf("NewFizzBuzzType(3).Generate(15).Value() = %q, want %q", got.Value(), "FizzBuzz")
	}
}

func TestNewFizzBuzzType_不正なタイプでパニックする(t *testing.T) {
	defer func() {
		if r := recover(); r == nil {
			t.Fatal("NewFizzBuzzType(99) should panic")
		}
	}()
	NewFizzBuzzType(99)
}
