:- use_module('../src/fizzbuzz_list').
:- use_module('../src/fizzbuzz_value').

:- begin_tests(fizzbuzz_list).

test(create_has_count_elements) :-
    list_create(15, type_01, Values),
    list_count(Values, Count),
    assertion(Count == 15).

test(first_element_is_one) :-
    list_create(15, type_01, [First | _]),
    value_value(First, S),
    assertion(S == "1").

test(fifteenth_element_is_fizzbuzz) :-
    list_create(15, type_01, Values),
    last(Values, Last),
    value_value(Last, S),
    assertion(S == "FizzBuzz").

:- end_tests(fizzbuzz_list).
