:- use_module('../src/fizzbuzz_pipeline').

:- begin_tests(fizzbuzz_pipeline).

test(decorate_wraps_in_brackets) :-
    decorate("Fizz", R),
    assertion(R == "[Fizz]").

test(convert_and_decorate_composes) :-
    convert_and_decorate(3, R),
    assertion(R == "[Fizz]").

test(process_maps_pipeline_over_range) :-
    process(5, Rs),
    assertion(Rs == ["[1]", "[2]", "[Fizz]", "[4]", "[Buzz]"]).

:- end_tests(fizzbuzz_pipeline).
