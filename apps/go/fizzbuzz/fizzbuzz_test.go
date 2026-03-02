package fizzbuzz

import (
	"bytes"
	"strconv"
	"strings"
	"testing"

	"github.com/k2works/getting-started-tdd/apps/go/domain/functional"
)

// TODO リスト（章 1-3）
/*
- [x] 数を文字列にして返す
  - [x] 1 を渡したら文字列 "1" を返す
  - [x] 2 を渡したら文字列 "2" を返す
- [x] 3 の倍数のときは "Fizz" を返す
- [x] 5 の倍数のときは "Buzz" を返す
- [x] 3 と 5 両方の倍数のときは "FizzBuzz" を返す
- [x] 1 から 100 までの数
- [x] プリントする
*/

func assertGenerate(t *testing.T, input int, want string) {
	t.Helper()
	got := Generate(input)
	if got != want {
		t.Fatalf("Generate(%d) = %q, want %q", input, got, want)
	}
}

func TestGenerate_1を渡したら文字列1を返す(t *testing.T) {
	assertGenerate(t, 1, "1")
}

func TestGenerate_2を渡したら文字列2を返す(t *testing.T) {
	assertGenerate(t, 2, "2")
}

func TestGenerate_3を渡したらFizzを返す(t *testing.T) {
	assertGenerate(t, 3, "Fizz")
}

func TestGenerate_6を渡したらFizzを返す(t *testing.T) {
	assertGenerate(t, 6, "Fizz")
}

func TestGenerate_5を渡したらBuzzを返す(t *testing.T) {
	assertGenerate(t, 5, "Buzz")
}

func TestGenerate_10を渡したらBuzzを返す(t *testing.T) {
	assertGenerate(t, 10, "Buzz")
}

func TestGenerate_15を渡したらFizzBuzzを返す(t *testing.T) {
	assertGenerate(t, 15, "FizzBuzz")
}

func TestGenerateList_1から100までのFizzBuzzを返す(t *testing.T) {
	got := GenerateList(1, 100)

	if len(got) != 100 {
		t.Fatalf("len(GenerateList(1,100)) = %d, want 100", len(got))
	}
	if got[0] != "1" {
		t.Errorf("got[0] = %q, want %q", got[0], "1")
	}
	if got[2] != "Fizz" {
		t.Errorf("got[2] = %q, want %q", got[2], "Fizz")
	}
	if got[4] != "Buzz" {
		t.Errorf("got[4] = %q, want %q", got[4], "Buzz")
	}
	if got[14] != "FizzBuzz" {
		t.Errorf("got[14] = %q, want %q", got[14], "FizzBuzz")
	}
}

func TestPrint_FizzBuzzの結果を出力する(t *testing.T) {
	var buf bytes.Buffer
	Print(&buf)
	output := buf.String()

	if !strings.Contains(output, "1\n") {
		t.Error("output should contain '1'")
	}
	if !strings.Contains(output, "Fizz\n") {
		t.Error("output should contain 'Fizz'")
	}
	if !strings.Contains(output, "Buzz\n") {
		t.Error("output should contain 'Buzz'")
	}
	if !strings.Contains(output, "FizzBuzz\n") {
		t.Error("output should contain 'FizzBuzz'")
	}
}

// --- 第 7 章: カプセル化とポリモーフィズム ---

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

func TestFizzBuzzType01_Generate_数を文字列に変換する(t *testing.T) {
	fbt := FizzBuzzType01{}
	got := fbt.Generate(1)
	if got.Value() != "1" {
		t.Fatalf("got.Value() = %q, want %q", got.Value(), "1")
	}
}

func TestFizzBuzzType01_Generate_3の倍数でFizzを返す(t *testing.T) {
	fbt := FizzBuzzType01{}
	got := fbt.Generate(3)
	if got.Value() != "Fizz" {
		t.Fatalf("got.Value() = %q, want %q", got.Value(), "Fizz")
	}
}

func TestFizzBuzzType01_Generate_5の倍数でBuzzを返す(t *testing.T) {
	fbt := FizzBuzzType01{}
	got := fbt.Generate(5)
	if got.Value() != "Buzz" {
		t.Fatalf("got.Value() = %q, want %q", got.Value(), "Buzz")
	}
}

func TestFizzBuzzType01_Generate_15の倍数でFizzBuzzを返す(t *testing.T) {
	fbt := FizzBuzzType01{}
	got := fbt.Generate(15)
	if got.Value() != "FizzBuzz" {
		t.Fatalf("got.Value() = %q, want %q", got.Value(), "FizzBuzz")
	}
}

func TestFizzBuzzType02_Generate_常に数値を返す(t *testing.T) {
	fbt := FizzBuzzType02{}
	got := fbt.Generate(3)
	if got.Value() != "3" {
		t.Fatalf("got.Value() = %q, want %q", got.Value(), "3")
	}
}

func TestFizzBuzzType03_Generate_FizzBuzzのみ返す(t *testing.T) {
	fbt := FizzBuzzType03{}
	got := fbt.Generate(15)
	if got.Value() != "FizzBuzz" {
		t.Fatalf("got.Value() = %q, want %q", got.Value(), "FizzBuzz")
	}
}

func TestFizzBuzzType03_Generate_FizzBuzz以外は数値を返す(t *testing.T) {
	fbt := FizzBuzzType03{}
	got := fbt.Generate(3)
	if got.Value() != "3" {
		t.Fatalf("got.Value() = %q, want %q", got.Value(), "3")
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
			t.Fatal("NewFizzBuzzType(99) should panic")
		}
	}()
	NewFizzBuzzType(99)
}

// --- 第 8 章: デザインパターン ---

func TestNewFizzBuzzValue_正の値で生成できる(t *testing.T) {
	v := NewFizzBuzzValue(1, "1")
	if v.Number() != 1 {
		t.Fatalf("Number() = %d, want %d", v.Number(), 1)
	}
	if v.Value() != "1" {
		t.Fatalf("Value() = %q, want %q", v.Value(), "1")
	}
}

func TestNewFizzBuzzValue_負の値でパニックする(t *testing.T) {
	defer func() {
		if r := recover(); r == nil {
			t.Fatal("NewFizzBuzzValue(-1, ...) should panic")
		}
	}()
	NewFizzBuzzValue(-1, "-1")
}

func TestFizzBuzzValue_Equal_同じ値は等しい(t *testing.T) {
	v1 := NewFizzBuzzValue(1, "1")
	v2 := NewFizzBuzzValue(1, "1")
	if !v1.Equal(v2) {
		t.Fatal("v1.Equal(v2) should be true")
	}
}

func TestFizzBuzzValue_Equal_異なる値は等しくない(t *testing.T) {
	v1 := NewFizzBuzzValue(1, "1")
	v2 := NewFizzBuzzValue(2, "2")
	if v1.Equal(v2) {
		t.Fatal("v1.Equal(v2) should be false")
	}
}

func TestFizzBuzzValue_String_文字列表現を返す(t *testing.T) {
	v := NewFizzBuzzValue(3, "Fizz")
	if v.String() != "Fizz" {
		t.Fatalf("String() = %q, want %q", v.String(), "Fizz")
	}
}

func TestNewFizzBuzzList_スライスからリストを生成する(t *testing.T) {
	values := []FizzBuzzValue{
		NewFizzBuzzValue(1, "1"),
		NewFizzBuzzValue(2, "2"),
	}
	list := NewFizzBuzzList(values)
	if list.Count() != 2 {
		t.Fatalf("Count() = %d, want %d", list.Count(), 2)
	}
}

func TestNewFizzBuzzList_上限を超えるとパニックする(t *testing.T) {
	defer func() {
		if r := recover(); r == nil {
			t.Fatal("should panic when exceeding MaxCount")
		}
	}()
	values := make([]FizzBuzzValue, 101)
	for i := range values {
		values[i] = NewFizzBuzzValue(i, strconv.Itoa(i))
	}
	NewFizzBuzzList(values)
}

func TestFizzBuzzList_Value_防御的コピーを返す(t *testing.T) {
	values := []FizzBuzzValue{NewFizzBuzzValue(1, "1")}
	list := NewFizzBuzzList(values)
	got := list.Value()
	got[0] = NewFizzBuzzValue(99, "99")
	if list.Value()[0].Number() != 1 {
		t.Fatal("internal state should not be modified")
	}
}

func TestFizzBuzzList_ToStringSlice_文字列スライスを返す(t *testing.T) {
	values := []FizzBuzzValue{
		NewFizzBuzzValue(1, "1"),
		NewFizzBuzzValue(3, "Fizz"),
	}
	list := NewFizzBuzzList(values)
	got := list.ToStringSlice()
	if got[0] != "1" || got[1] != "Fizz" {
		t.Fatalf("ToStringSlice() = %v", got)
	}
}

func TestFizzBuzzValueCommand_Execute_値を生成する(t *testing.T) {
	fbt := FizzBuzzType01{}
	cmd := NewFizzBuzzValueCommand(3, fbt)
	result := cmd.Execute()
	v, ok := result.(FizzBuzzValue)
	if !ok {
		t.Fatal("Execute() should return FizzBuzzValue")
	}
	if v.Value() != "Fizz" {
		t.Fatalf("Value() = %q, want %q", v.Value(), "Fizz")
	}
}

func TestFizzBuzzListCommand_Execute_リストを生成する(t *testing.T) {
	fbt := FizzBuzzType01{}
	cmd := NewFizzBuzzListCommand(fbt, 100)
	result := cmd.Execute()
	list, ok := result.(*FizzBuzzList)
	if !ok {
		t.Fatal("Execute() should return *FizzBuzzList")
	}
	if list.Count() != 100 {
		t.Fatalf("Count() = %d, want %d", list.Count(), 100)
	}
}

func TestPredicate_Fizzを判定する(t *testing.T) {
	isFizz := func(v FizzBuzzValue) bool { return v.Value() == "Fizz" }

	v := NewFizzBuzzValue(3, "Fizz")
	if !isFizz(v) {
		t.Fatal("isFizz should return true for Fizz")
	}
}

func TestFizzBuzzList_Filter_Fizzだけを抽出する(t *testing.T) {
	cmd := NewFizzBuzzListCommand(FizzBuzzType01{}, 15)
	list := cmd.Execute().(*FizzBuzzList)

	isFizz := func(v FizzBuzzValue) bool { return v.Value() == "Fizz" }
	filtered := list.Filter(isFizz)

	for _, v := range filtered.Value() {
		if v.Value() != "Fizz" {
			t.Fatalf("expected Fizz, got %q", v.Value())
		}
	}
}

func TestMakeValuePredicate_指定した値と一致する述語を返す(t *testing.T) {
	isFizz := MakeValuePredicate("Fizz")
	isBuzz := MakeValuePredicate("Buzz")
	v := NewFizzBuzzValue(3, "Fizz")
	if !isFizz(v) {
		t.Fatal("isFizz should return true")
	}
	if isBuzz(v) {
		t.Fatal("isBuzz should return false for Fizz")
	}
}

func TestFizzBuzzList_Map_値を変換する(t *testing.T) {
	list := NewFizzBuzzList([]FizzBuzzValue{
		NewFizzBuzzValue(1, "1"),
		NewFizzBuzzValue(3, "Fizz"),
	})
	got := list.Map(func(v FizzBuzzValue) string {
		return strings.ToUpper(v.Value())
	})

	if got[0] != "1" || got[1] != "FIZZ" {
		t.Fatalf("Map result = %v", got)
	}
}

func TestCompose_2つの関数を合成する(t *testing.T) {
	double := func(n int) int { return n * 2 }
	addOne := func(n int) int { return n + 1 }
	if got := Compose(double, addOne)(5); got != 11 {
		t.Fatalf("Compose(double, addOne)(5) = %d, want 11", got)
	}
}

func TestFizzBuzzList_FilterとMapを組み合わせる(t *testing.T) {
	cmd := NewFizzBuzzListCommand(FizzBuzzType01{}, 15)
	list := cmd.Execute().(*FizzBuzzList)

	result := list.Filter(MakeValuePredicate("Fizz")).Map(func(v FizzBuzzValue) string {
		return v.Value()
	})
	for _, s := range result {
		if s != "Fizz" {
			t.Fatalf("expected Fizz, got %q", s)
		}
	}
}

func TestFizzBuzzList_Filterは元のリストを変更しない(t *testing.T) {
	cmd := NewFizzBuzzListCommand(FizzBuzzType01{}, 15)
	original := cmd.Execute().(*FizzBuzzList)
	originalCount := original.Count()

	_ = original.Filter(MakeValuePredicate("Fizz"))

	if original.Count() != originalCount {
		t.Fatal("original list should not be modified")
	}
}

func TestFizzBuzzList_GroupByValue_値でグルーピングする(t *testing.T) {
	cmd := NewFizzBuzzListCommand(FizzBuzzType01{}, 15)
	list := cmd.Execute().(*FizzBuzzList)

	grouped := list.GroupByValue()

	if _, ok := grouped["Fizz"]; !ok {
		t.Fatal("grouped should contain 'Fizz' key")
	}
	if _, ok := grouped["Buzz"]; !ok {
		t.Fatal("grouped should contain 'Buzz' key")
	}
	if _, ok := grouped["FizzBuzz"]; !ok {
		t.Fatal("grouped should contain 'FizzBuzz' key")
	}
}

func TestFizzBuzzList_CountByValue_値ごとの出現回数を数える(t *testing.T) {
	cmd := NewFizzBuzzListCommand(FizzBuzzType01{}, 15)
	list := cmd.Execute().(*FizzBuzzList)

	counts := list.CountByValue()
	if counts["FizzBuzz"] != 1 {
		t.Fatalf("FizzBuzz count = %d, want 1", counts["FizzBuzz"])
	}
}

func TestFizzBuzzList_Take_先頭N件を取得する(t *testing.T) {
	cmd := NewFizzBuzzListCommand(FizzBuzzType01{}, 15)
	list := cmd.Execute().(*FizzBuzzList)

	taken := list.Take(5)
	if taken.Count() != 5 {
		t.Fatalf("Take(5).Count() = %d, want 5", taken.Count())
	}
}

func TestFizzBuzzList_Join_要素を文字列で結合する(t *testing.T) {
	values := []FizzBuzzValue{
		NewFizzBuzzValue(1, "1"),
		NewFizzBuzzValue(2, "2"),
		NewFizzBuzzValue(3, "Fizz"),
	}
	list := NewFizzBuzzList(values)

	got := list.Join(", ")
	if got != "1, 2, Fizz" {
		t.Fatalf("Join(', ') = %q, want %q", got, "1, 2, Fizz")
	}
}

func TestFizzBuzzList_メソッドチェーンでパイプラインを構築する(t *testing.T) {
	cmd := NewFizzBuzzListCommand(FizzBuzzType01{}, 100)
	list := cmd.Execute().(*FizzBuzzList)

	result := list.Filter(MakeValuePredicate("Fizz")).Take(3).Join(", ")
	if result != "Fizz, Fizz, Fizz" {
		t.Fatalf("pipeline result = %q, want %q", result, "Fizz, Fizz, Fizz")
	}
}

func TestFizzBuzzList_Reduce_数値の合計を計算する(t *testing.T) {
	values := []FizzBuzzValue{
		NewFizzBuzzValue(1, "1"),
		NewFizzBuzzValue(2, "2"),
		NewFizzBuzzValue(3, "Fizz"),
	}
	list := NewFizzBuzzList(values)

	sum := list.Reduce(0, func(acc int, v FizzBuzzValue) int {
		return acc + v.Number()
	})
	if sum != 6 {
		t.Fatalf("Reduce sum = %d, want 6", sum)
	}
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
	if got := fbt.Generate(3).Value(); got != "Fizz" {
		t.Fatalf("got = %q, want %q", got, "Fizz")
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

func TestTryNewFizzBuzzValue_正の値で生成できる(t *testing.T) {
	v, err := TryNewFizzBuzzValue(1, "1")
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if v.Number() != 1 {
		t.Fatalf("Number() = %d, want 1", v.Number())
	}
}

func TestTryNewFizzBuzzValue_負の値でエラーを返す(t *testing.T) {
	_, err := TryNewFizzBuzzValue(-1, "-1")
	if err == nil {
		t.Fatal("expected error for negative number")
	}
}

func TestFizzBuzzList_FindFirst_最初のFizzBuzzを見つける(t *testing.T) {
	cmd := NewFizzBuzzListCommand(FizzBuzzType01{}, 100)
	list := cmd.Execute().(*FizzBuzzList)

	v, found := list.FindFirst(MakeValuePredicate("FizzBuzz"))
	if !found {
		t.Fatal("should find FizzBuzz")
	}
	if v.Number() != 15 {
		t.Fatalf("Number() = %d, want 15", v.Number())
	}
}

func TestFizzBuzzList_FindFirst_見つからない場合(t *testing.T) {
	list := NewFizzBuzzList([]FizzBuzzValue{NewFizzBuzzValue(1, "1")})
	_, found := list.FindFirst(MakeValuePredicate("FizzBuzz"))
	if found {
		t.Fatal("should not find FizzBuzz")
	}
}

func TestFizzBuzzList_AnyMatch_Fizzが存在する(t *testing.T) {
	cmd := NewFizzBuzzListCommand(FizzBuzzType01{}, 15)
	list := cmd.Execute().(*FizzBuzzList)

	if !list.AnyMatch(MakeValuePredicate("Fizz")) {
		t.Fatal("should contain Fizz")
	}
}

func TestFizzBuzzList_AllMatch_全て数値ではない(t *testing.T) {
	cmd := NewFizzBuzzListCommand(FizzBuzzType01{}, 15)
	list := cmd.Execute().(*FizzBuzzList)
	isNumber := func(v FizzBuzzValue) bool {
		return v.Value() != "Fizz" && v.Value() != "Buzz" && v.Value() != "FizzBuzz"
	}
	if list.AllMatch(isNumber) {
		t.Fatal("not all values should be numbers")
	}
}

func TestGenericMap_FizzBuzzValueを文字列に変換する(t *testing.T) {
	values := []FizzBuzzValue{
		NewFizzBuzzValue(1, "1"),
		NewFizzBuzzValue(3, "Fizz"),
	}
	result := functional.MapSlice(values, func(v FizzBuzzValue) string {
		return v.Value()
	})
	if result[0] != "1" || result[1] != "Fizz" {
		t.Fatalf("MapSlice result = %v", result)
	}
}

func TestGenericFilter_正の値だけを抽出する(t *testing.T) {
	numbers := []int{-2, -1, 0, 1, 2, 3}
	positives := functional.FilterSlice(numbers, func(n int) bool { return n > 0 })
	if len(positives) != 3 {
		t.Fatalf("len(positives) = %d, want 3", len(positives))
	}
}

func TestGenericReduce_合計を計算する(t *testing.T) {
	numbers := []int{1, 2, 3, 4, 5}
	sum := functional.ReduceSlice(numbers, 0, func(acc, n int) int { return acc + n })
	if sum != 15 {
		t.Fatalf("ReduceSlice sum = %d, want 15", sum)
	}
}
