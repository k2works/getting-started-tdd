from lib.application.fizz_buzz_list_command import FizzBuzzListCommand
from lib.domain.type.fizz_buzz_type import FizzBuzzType, FizzBuzzTypeName


def main() -> None:
    type_ = FizzBuzzType.create_from_name(FizzBuzzTypeName.STANDARD)
    command = FizzBuzzListCommand(type_)
    result = command.execute()
    for i in range(result.size()):
        print(result.get(i).value)


if __name__ == "__main__":
    main()
