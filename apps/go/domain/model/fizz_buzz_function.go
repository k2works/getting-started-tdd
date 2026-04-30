package model

// Predicate は FizzBuzzValue を受け取り bool を返す関数型です。
type Predicate func(FizzBuzzValue) bool

// Mapper は FizzBuzzValue を受け取り string を返す関数型です。
type Mapper func(FizzBuzzValue) string

// Filter は条件に合致する要素だけを含む新しいリストを返します。
func (l *FizzBuzzList) Filter(pred Predicate) *FizzBuzzList {
	var result []FizzBuzzValue
	for _, v := range l.value {
		if pred(v) {
			result = append(result, v)
		}
	}
	return &FizzBuzzList{value: result}
}

// MakeValuePredicate は指定した値と一致するかを判定する述語関数を返します。
func MakeValuePredicate(target string) Predicate {
	return func(v FizzBuzzValue) bool {
		return v.Value() == target
	}
}

// Map は各要素に関数を適用した結果のスライスを返します。
func (l *FizzBuzzList) Map(fn Mapper) []string {
	result := make([]string, len(l.value))
	for i, v := range l.value {
		result[i] = fn(v)
	}
	return result
}

// Compose は f を適用した後に g を適用する合成関数を返します。
func Compose(f, g func(int) int) func(int) int {
	return func(n int) int {
		return g(f(n))
	}
}
