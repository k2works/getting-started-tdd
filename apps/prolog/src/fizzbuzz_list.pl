:- module(fizzbuzz_list, [list_create/3, list_count/2]).

:- use_module(fizzbuzz_value).

%% list_create(+Count:integer, +Type:atom, -Values:list) is det.
%
%  1 から Count までの値オブジェクトを生成するファーストクラスコレクション。
list_create(Count, Type, Values) :-
    numlist(1, Count, Ns),
    maplist([N, V]>>value_create(Type, N, V), Ns, Values).

%% list_count(+Values:list, -Count:integer) is det.
list_count(Values, Count) :-
    length(Values, Count).
