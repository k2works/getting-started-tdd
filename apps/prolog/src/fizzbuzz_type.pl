:- module(fizzbuzz_type, [generate/3, type_create/2]).

%% generate(+Type:atom, +N:integer, -Result:string) is det.
%
%  タイプ（type_01 / type_02 / type_03）に従って数 N を変換する。
%  各タイプごとの節が振る舞いを切り替える（State/Strategy 相当）。

% type_01: 通常の FizzBuzz
generate(type_01, N, "FizzBuzz") :- 0 is N mod 15, !.
generate(type_01, N, "Fizz")     :- 0 is N mod 3, !.
generate(type_01, N, "Buzz")     :- 0 is N mod 5, !.
generate(type_01, N, R)          :- format(string(R), "~w", [N]).

% type_02: 数字のみ
generate(type_02, N, R) :- format(string(R), "~w", [N]).

% type_03: Fizz のみ（Buzz なし）
generate(type_03, N, "FizzBuzz") :- 0 is N mod 15, !.
generate(type_03, N, "Fizz")     :- 0 is N mod 3, !.
generate(type_03, N, R)          :- format(string(R), "~w", [N]).

%% type_create(+No:integer, -Result) is det.
%
%  タイプ番号から Type を生成する。未定義の番号は error(Message) を返す。
type_create(1, ok(type_01)) :- !.
type_create(2, ok(type_02)) :- !.
type_create(3, ok(type_03)) :- !.
type_create(No, error(Message)) :-
    format(string(Message), "該当するタイプは存在しません: ~w", [No]).
