:- use_module('../src/fizzbuzz_value').

:- begin_tests(fizzbuzz_value).

test(create_holds_number_and_value) :-
    value_create(type_01, 3, V),
    value_number(V, N),
    value_value(V, S),
    assertion(N == 3),
    assertion(S == "Fizz").

test(value_is_a_compound_term) :-
    value_create(type_01, 5, V),
    assertion(V == fizzbuzz_value(5, "Buzz")).

:- end_tests(fizzbuzz_value).
