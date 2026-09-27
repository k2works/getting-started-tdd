% 題材 D: 安全変換（なでしこ3 の test/error_test.nako3 に対応）
:- use_module('../src/エラー処理').

:- begin_tests(エラー処理).

test('正の数は成功になる') :-
    安全変換(3, _結果),
    assertion(_結果 == 成功("Fizz")).

test('0は失敗になる') :-
    安全変換(0, _結果),
    assertion(_結果 == 失敗("正の数を指定してください: 0")).

test('数値でなければ失敗になる') :-
    安全変換(a, _結果),
    assertion(_結果 == 失敗("数値を指定してください: a")).

:- end_tests(エラー処理).
