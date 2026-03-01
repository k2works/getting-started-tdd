export class FizzBuzz {
  generate(number: number): string {
    if (number % 15 === 0) {
      return "FizzBuzz";
    }
    if (number % 3 === 0) {
      return "Fizz";
    }
    if (number % 5 === 0) {
      return "Buzz";
    }

    return number.toString();
  }

  generateList(count: number): string[] {
    return Array.from({ length: count }, (_, index) =>
      this.generate(index + 1),
    );
  }

  printFizzBuzz(count: number): void {
    this.generateList(count).forEach((value) => {
      console.log(value);
    });
  }
}
