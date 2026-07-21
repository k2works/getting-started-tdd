:- use_module('../src/fizzbuzz_hof').

:- begin_tests(fizzbuzz_hof).

test(generate_with_default_rule) :-
    generate_with(default_rule, 15, R),
    assertion(R == "FizzBuzz").

test(generate_with_lambda_rule) :-
    generate_with([N, R]>>format(string(R), "~w!", [N]), 7, R),
    assertion(R == "7!").

test(transform_maps_over_range) :-
    transform(default_rule, 5, Rs),
    assertion(Rs == ["1", "2", "Fizz", "4", "Buzz"]).

test(filter_list_keeps_matching) :-
    filter_list([X]>>(X == "Fizz"), ["1", "2", "Fizz", "4", "Buzz"], Ys),
    assertion(Ys == ["Fizz"]).

:- end_tests(fizzbuzz_hof).
