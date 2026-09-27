:- module(パイプライン, [装飾/2, 'FizzBuzz装飾'/2, パイプライン処理/2]).

/** <module> 題材 C: パイプライン処理（なでしこ3 の src/pipeline.nako3 に対応）
*/

:- use_module(基本変換).
:- use_module(語順).

%!  装飾(+文字列, -結果:string) is det.
装飾(_文字列, _結果) :-
    format(string(_結果), "[~w]", [_文字列]).

%!  'FizzBuzz装飾'(+数:integer, -結果:string) is det.
%
%   なでしこ3 の「NをFizzBuzz変換して装飾して戻す」。
'FizzBuzz装飾'(_数, _結果) :-
    _結果 は _数 を 'FizzBuzz変換' して 装飾.

%!  パイプライン処理(+上限:integer, -結果:list(string)) is det.
パイプライン処理(_上限, _結果) :-
    numlist(1, _上限, _数列),
    maplist('FizzBuzz装飾', _数列, _結果).
