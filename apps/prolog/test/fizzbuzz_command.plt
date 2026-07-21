:- use_module('../src/fizzbuzz_command').
:- use_module('../src/fizzbuzz_value').
:- use_module('../src/fizzbuzz_list').

:- begin_tests(fizzbuzz_command).

test(value_command_returns_single_value) :-
    execute(value_command(type_01), 3, Values),
    list_count(Values, Count),
    assertion(Count == 1),
    Values = [V],
    value_value(V, S),
    assertion(S == "Fizz").

test(list_command_returns_list) :-
    execute(list_command(type_01), 15, Values),
    list_count(Values, Count),
    assertion(Count == 15).

:- end_tests(fizzbuzz_command).
