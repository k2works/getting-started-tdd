class FizzBuzz:
    FIZZ_NUMBER: int = 3
    BUZZ_NUMBER: int = 5
    FIZZ_BUZZ_NUMBER: int = 15

    def generate(self, number: int) -> str:
        if number % self.FIZZ_BUZZ_NUMBER == 0:
            return "FizzBuzz"
        if number % self.FIZZ_NUMBER == 0:
            return "Fizz"
        if number % self.BUZZ_NUMBER == 0:
            return "Buzz"
        return str(number)

    def generate_list(self, count: int) -> list[str]:
        return [self.generate(i) for i in range(1, count + 1)]

    def print_fizzbuzz(self, count: int) -> None:
        for item in self.generate_list(count):
            print(item)
