:- module(基本変換, ['FizzBuzz変換'/2, 'FizzBuzz配列作成'/2]).

/** <module> 題材 A: FizzBuzz の基本変換（なでしこ3 の src/fizzbuzz.nako3 に対応）

  FizzBuzz で始まる名前は大文字始まりで変数と解釈されるため、引用符で囲む。
*/

%!  'FizzBuzz変換'(+数:integer, -結果:string) is det.
'FizzBuzz変換'(_数, "FizzBuzz") :- 0 is _数 mod 15, !.
'FizzBuzz変換'(_数, "Fizz")     :- 0 is _数 mod 3, !.
'FizzBuzz変換'(_数, "Buzz")     :- 0 is _数 mod 5, !.
'FizzBuzz変換'(_数, _結果)      :- number_string(_数, _結果).

%!  'FizzBuzz配列作成'(+上限:integer, -配列:list(string)) is det.
'FizzBuzz配列作成'(_上限, _配列) :-
    numlist(1, _上限, _数列),
    maplist('FizzBuzz変換', _数列, _配列).
