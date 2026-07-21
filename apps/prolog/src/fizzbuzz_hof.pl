:- module(fizzbuzz_hof, [generate_with/3, default_rule/2, transform/3, filter_list/3]).

%% generate_with(:Rule, +N:integer, -Result:string) is det.
%
%  変換ルールを述語（ゴール）として受け取り、数 N を変換する。
generate_with(Rule, N, Result) :-
    call(Rule, N, Result).

%% default_rule(+N:integer, -Result:string) is det.
%
%  標準の FizzBuzz ルール。
default_rule(N, "FizzBuzz") :- 0 is N mod 15, !.
default_rule(N, "Fizz")     :- 0 is N mod 3, !.
default_rule(N, "Buzz")     :- 0 is N mod 5, !.
default_rule(N, R)          :- format(string(R), "~w", [N]).

%% transform(:Rule, +N:integer, -Results:list) is det.
%
%  1 から N までのリストに変換ルールを適用する（maplist による高階処理）。
transform(Rule, N, Results) :-
    numlist(1, N, Ns),
    maplist(Rule, Ns, Results).

%% filter_list(:Pred, +Xs:list, -Ys:list) is det.
%
%  リストを述語で絞り込む（include による高階処理）。
filter_list(Pred, Xs, Ys) :-
    include(Pred, Xs, Ys).
