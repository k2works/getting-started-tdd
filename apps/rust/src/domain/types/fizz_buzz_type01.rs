use crate::domain::model::fizz_buzz_value::FizzBuzzValue;
use crate::domain::types::fizz_buzz_type::FizzBuzzType;

pub struct FizzBuzzType01;

impl FizzBuzzType for FizzBuzzType01 {
    fn generate(&self, number: i32) -> FizzBuzzValue {
        let value = match (number % 3, number % 5) {
            (0, 0) => FizzBuzz.to_string(),
            (0, _) => Fizz.to_string(),
            (_, 0) => Buzz.to_string(),
            _ => number.to_string(),
        };
        FizzBuzzValue::new(number, value)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_generate_3でfizzを返す() {
        let sut = FizzBuzzType01;
        assert_eq!(Fizz, sut.generate(3).value());
    }

    #[test]
    fn test_generate_5でbuzzを返す() {
        let sut = FizzBuzzType01;
        assert_eq!(Buzz, sut.generate(5).value());
    }

    #[test]
    fn test_generate_15でfizzbuzzを返す() {
        let sut = FizzBuzzType01;
        assert_eq!(FizzBuzz, sut.generate(15).value());
    }
}
