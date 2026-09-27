% 題材 A: FizzBuzz 変換（なでしこ3 の test/fizzbuzz_test.nako3 に対応）
:- use_module('../src/基本変換').
:- use_module('../src/語順').

:- begin_tests(基本変換).

test('3を渡したらFizzを返す') :-
    'FizzBuzz変換'(3, _結果),
    assertion(_結果 == "Fizz").

test('5を渡したらBuzzを返す') :-
    'FizzBuzz変換'(5, _結果),
    assertion(_結果 == "Buzz").

test('15を渡したらFizzBuzzを返す') :-
    'FizzBuzz変換'(15, _結果),
    assertion(_結果 == "FizzBuzz").

test('1を渡したら文字列1を返す') :-
    'FizzBuzz変換'(1, _結果),
    assertion(_結果 == "1").

test('2を渡したら文字列2を返す') :-
    'FizzBuzz変換'(2, _結果),
    assertion(_結果 == "2").

test('15まで作ると15件になる') :-
    'FizzBuzz配列作成'(15, _配列),
    length(_配列, _件数),
    assertion(_件数 == 15).

test('15まで作った配列の並び') :-
    'FizzBuzz配列作成'(15, _配列),
    atomic_list_concat(_配列, ',', _結合),
    assertion(_結合 == '1,2,Fizz,4,Buzz,Fizz,7,8,Fizz,Buzz,11,Fizz,13,14,FizzBuzz').

test('3を FizzBuzz変換 の順で書ける') :-
    _結果 は 3を 'FizzBuzz変換',
    assertion(_結果 == "Fizz").

:- end_tests(基本変換).
