:- module(fizzbuzz_error, [safe_convert/2, convert_or_nil/2]).

:- use_module(fizzbuzz).

%% safe_convert(+N:integer, -Result) is det.
%
%  正の数のみ受け付ける安全な変換。ゼロ以下は error(Message) を返す。
%  ok(Value) / error(Message) の直和型でエラーを値として表現する。
safe_convert(N, error(Message)) :-
    N =< 0, !,
    format(string(Message), "正の数を指定してください: ~w", [N]).
safe_convert(N, ok(Value)) :-
    fizzbuzz(N, Value).

%% convert_or_nil(+N, -Result) is det.
%
%  入力が nil の場合は nil を返す。整数なら変換結果を返す（Option 相当）。
convert_or_nil(nil, nil) :- !.
convert_or_nil(N, Value) :-
    integer(N),
    fizzbuzz(N, Value).
