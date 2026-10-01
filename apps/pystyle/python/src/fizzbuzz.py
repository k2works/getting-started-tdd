"""FizzBuzz（なでしこ3 の Python 風構文と並べるための Python 版）"""


def FizzBuzz変換処理(N: int) -> str:
    if N % 15 == 0:
        return "FizzBuzz"
    elif N % 3 == 0:
        return "Fizz"
    elif N % 5 == 0:
        return "Buzz"
    else:
        return str(N)


def FizzBuzzリスト作成処理(N: int) -> list[str]:
    結果 = []
    for 番号 in range(1, N + 1):
        結果.append(FizzBuzz変換処理(番号))
    return 結果


def FizzBuzz表示処理(N: int) -> None:
    for 値 in FizzBuzzリスト作成処理(N):
        print(値)
