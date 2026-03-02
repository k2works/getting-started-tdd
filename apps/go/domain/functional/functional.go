// Package functional は汎用的な関数型ユーティリティを提供します。
package functional

// MapSlice は任意の型のスライスに関数を適用し、変換結果のスライスを返します。
func MapSlice[T any, R any](slice []T, fn func(T) R) []R {
	result := make([]R, len(slice))
	for i, v := range slice {
		result[i] = fn(v)
	}
	return result
}

// FilterSlice は条件に合致する要素だけを含む新しいスライスを返します。
func FilterSlice[T any](slice []T, pred func(T) bool) []T {
	result := make([]T, 0, len(slice))
	for _, v := range slice {
		if pred(v) {
			result = append(result, v)
		}
	}
	return result
}

// ReduceSlice は初期値から始めて各要素に関数を適用し、単一の値に畳み込みます。
func ReduceSlice[T any, R any](slice []T, initial R, fn func(R, T) R) R {
	acc := initial
	for _, v := range slice {
		acc = fn(acc, v)
	}
	return acc
}
