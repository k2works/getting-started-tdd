:- module(fizzbuzz_value, [value_create/3, value_number/2, value_value/2]).

:- use_module(fizzbuzz_type).

%% value_create(+Type:atom, +N:integer, -Value) is det.
%
%  数値と変換結果をまとめた値オブジェクト fizzbuzz_value(Number, Value) を生成する。
value_create(Type, N, fizzbuzz_value(N, V)) :-
    generate(Type, N, V).

%% value_number(+Value, -Number) is det.
value_number(fizzbuzz_value(N, _), N).

%% value_value(+Value, -Str) is det.
value_value(fizzbuzz_value(_, V), V).
