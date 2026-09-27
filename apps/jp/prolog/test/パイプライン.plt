% 題材 C: パイプライン（なでしこ3 の test/pipeline_test.nako3 に対応）
:- use_module('../src/パイプライン').

:- begin_tests(パイプライン).

test('装飾すると角括弧で囲む') :-
    装飾("Fizz", _結果),
    assertion(_結果 == "[Fizz]").

test('変換してから装飾する') :-
    'FizzBuzz装飾'(15, _結果),
    assertion(_結果 == "[FizzBuzz]").

test('5までのパイプライン処理') :-
    パイプライン処理(5, _結果),
    assertion(_結果 == ["[1]", "[2]", "[Fizz]", "[4]", "[Buzz]"]).

:- end_tests(パイプライン).
