:- module(main, [main/0]).

:- use_module(fizzbuzz_list).
:- use_module(fizzbuzz_value).

%% main is det.
%
%  1 から 15 までの標準 FizzBuzz を 1 行ずつ出力する。
main :-
    list_create(15, type_01, Values),
    forall(member(V, Values),
           ( value_value(V, S),
             format("~w~n", [S]) )).
