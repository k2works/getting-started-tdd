% test/ 配下の全 .plt を読み込んで plunit をまとめて実行するランナー。
:- initialization(main, main).

main :-
    expand_file_name('test/*.plt', Files),
    forall(member(F, Files), consult(F)),
    ( run_tests -> halt(0) ; halt(1) ).
