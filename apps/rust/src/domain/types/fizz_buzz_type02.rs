use crate::domain::model::fizz_buzz_value::FizzBuzzValue;
use crate::domain::types::fizz_buzz_type::FizzBuzzType;

pub struct FizzBuzzType02;

impl FizzBuzzType for FizzBuzzType02 {
    fn generate(&self, number: i32) -> FizzBuzzValue {
        FizzBuzzValue::new(number, number.to_string())
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_generate_3で3を返す() {
        let sut = FizzBuzzType02;
        assert_eq!("3", sut.generate(3).value());
    }

    #[test]
    fn test_generate_5で5を返す() {
        let sut = FizzBuzzType02;
        assert_eq!("5", sut.generate(5).value());
    }

    #[test]
    fn test_generate_15で15を返す() {
        let sut = FizzBuzzType02;
        assert_eq!("15", sut.generate(15).value());
    }
}
