:- use_module('../src/fizzbuzz').

:- begin_tests(fizzbuzz).

test(returns_fizz_for_multiple_of_3) :-
    fizzbuzz(3, R),
    assertion(R == "Fizz").

test(returns_buzz_for_multiple_of_5) :-
    fizzbuzz(5, R),
    assertion(R == "Buzz").

test(returns_fizzbuzz_for_multiple_of_15) :-
    fizzbuzz(15, R),
    assertion(R == "FizzBuzz").

test(returns_number_otherwise) :-
    fizzbuzz(1, R),
    assertion(R == "1").

:- end_tests(fizzbuzz).
