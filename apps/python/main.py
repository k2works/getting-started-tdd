from lib.application.fizz_buzz_list_command import FizzBuzzListCommand
from lib.domain.type.fizz_buzz_type import FizzBuzzType

if __name__ == "__main__":
    type_ = FizzBuzzType.create(1)
    command = FizzBuzzListCommand(type_)
    result = command.execute()
    for i in range(result.size()):
        print(result.get(i))
