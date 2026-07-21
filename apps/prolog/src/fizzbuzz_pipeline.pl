:- module(fizzbuzz_pipeline, [compose/4, decorate/2, convert_and_decorate/2, process/2]).

:- use_module(fizzbuzz).

%% compose(:F, :G, +X, -Y) is det.
%
%  2 つの述語を合成する（F を適用してから G を適用）。
compose(F, G, X, Y) :-
    call(F, X, Tmp),
    call(G, Tmp, Y).

%% decorate(+S:string, -Decorated:string) is det.
%
%  文字列を括弧で装飾する。
decorate(S, Decorated) :-
    format(string(Decorated), "[~w]", [S]).

%% convert_and_decorate(+N:integer, -Result:string) is det.
%
%  convert と decorate を合成した変換。
convert_and_decorate(N, Result) :-
    compose(fizzbuzz:fizzbuzz, decorate, N, Result).

%% process(+N:integer, -Results:list) is det.
%
%  パイプラインで 1..N を変換・装飾する。元のデータは変更しない（不変）。
process(N, Results) :-
    numlist(1, N, Ns),
    maplist(convert_and_decorate, Ns, Results).
