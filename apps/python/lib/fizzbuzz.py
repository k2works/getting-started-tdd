class FizzBuzz:
    def generate(self, number: int) -> str:
        if number % 15 == 0:
            return "FizzBuzz"
        if number % 3 == 0:
            return "Fizz"
        if number % 5 == 0:
            return "Buzz"
        return str(number)

    def generate_list(self, count: int) -> list[str]:
        return [self.generate(i) for i in range(1, count + 1)]

    def print_fizzbuzz(self, count: int) -> None:
        for item in self.generate_list(count):
            print(item)
