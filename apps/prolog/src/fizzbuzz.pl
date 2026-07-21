:- module(fizzbuzz, [fizzbuzz/2]).

%% fizzbuzz(+N:integer, -Result:string) is det.
%
%  数 N を FizzBuzz 変換した文字列 Result を返す。
%  3 の倍数は "Fizz"、5 の倍数は "Buzz"、両方の倍数は "FizzBuzz"、
%  それ以外は数値そのものを文字列化して返す。

fizzbuzz(N, "FizzBuzz") :- 0 is N mod 15, !.
fizzbuzz(N, "Fizz")     :- 0 is N mod 3, !.
fizzbuzz(N, "Buzz")     :- 0 is N mod 5, !.
fizzbuzz(N, Result)     :- format(string(Result), "~w", [N]).
