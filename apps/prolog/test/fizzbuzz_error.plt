:- use_module('../src/fizzbuzz_error').

:- begin_tests(fizzbuzz_error).

test(safe_convert_positive_is_ok) :-
    safe_convert(3, R),
    assertion(R == ok("Fizz")).

test(safe_convert_zero_is_error) :-
    safe_convert(0, R),
    assertion(R = error(_)).

test(convert_or_nil_with_nil) :-
    convert_or_nil(nil, R),
    assertion(R == nil).

test(convert_or_nil_with_number) :-
    convert_or_nil(5, R),
    assertion(R == "Buzz").

:- end_tests(fizzbuzz_error).
