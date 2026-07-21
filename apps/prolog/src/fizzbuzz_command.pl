:- module(fizzbuzz_command, [execute/3]).

:- use_module(fizzbuzz_value).
:- use_module(fizzbuzz_list).

%% execute(+Command, +N:integer, -Values:list) is det.
%
%  コマンドを数 N に対して実行し、値オブジェクトのリストを返す。
%  value_command(Type): 単一の値を生成する。
%  list_command(Type):  1 から N までのリストを生成する。
execute(value_command(Type), N, [Value]) :-
    value_create(Type, N, Value).
execute(list_command(Type), N, Values) :-
    list_create(N, Type, Values).
