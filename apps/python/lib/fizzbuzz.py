class FizzBuzz:
    def generate(self, number: int) -> str:
        """数を FizzBuzz ルールに従って文字列に変換する。"""
        if number % 15 == 0:
            return "FizzBuzz"
        if number % 3 == 0:
            return "Fizz"
        if number % 5 == 0:
            return "Buzz"
        return str(number)

    def generate_list(self, count: int) -> list[str]:
        """1 から count までの FizzBuzz リストを生成する。"""
        return [self.generate(i) for i in range(1, count + 1)]

    def print_fizzbuzz(self, count: int) -> None:
        """FizzBuzz の結果をプリントする。"""
        result = self.generate_list(count)
        for item in result:
            print(item)
