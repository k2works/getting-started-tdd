"""題材 A: FizzBuzz 変換"""


def FizzBuzz変換(N: int) -> str:
    if N % 15 == 0:
        return "FizzBuzz"
    if N % 3 == 0:
        return "Fizz"
    if N % 5 == 0:
        return "Buzz"
    return str(N)


def FizzBuzz配列作成(N: int) -> list[str]:
    return [FizzBuzz変換(数) for 数 in range(1, N + 1)]
