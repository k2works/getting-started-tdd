:- use_module('../src/fizzbuzz_type').

:- begin_tests(fizzbuzz_type).

test(type_01_is_standard_fizzbuzz) :-
    generate(type_01, 15, R),
    assertion(R == "FizzBuzz").

test(type_02_is_number_only) :-
    generate(type_02, 15, R),
    assertion(R == "15").

test(type_03_has_no_buzz) :-
    generate(type_03, 5, R),
    assertion(R == "5").

test(type_03_still_has_fizz) :-
    generate(type_03, 3, R),
    assertion(R == "Fizz").

test(create_known_type) :-
    type_create(1, R),
    assertion(R == ok(type_01)).

test(create_unknown_type_returns_error) :-
    type_create(9, error(_)).

:- end_tests(fizzbuzz_type).
