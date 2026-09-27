export function FizzBuzz変換(N) {
  if (N % 15 === 0) return "FizzBuzz";
  if (N % 3 === 0) return "Fizz";
  if (N % 5 === 0) return "Buzz";
  return String(N);
}

export function FizzBuzz配列作成(N) {
  return Array.from({ length: N }, (_, 添字) => FizzBuzz変換(添字 + 1));
}
