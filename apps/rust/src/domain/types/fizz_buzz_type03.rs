use crate::domain::model::FizzBuzzValue;

use super::FizzBuzzType;

pub struct FizzBuzzType03;

impl FizzBuzzType for FizzBuzzType03 {
    fn generate(&self, number: i32) -> FizzBuzzValue {
        let value = match (number % 3, number % 5) {
            (0, 0) => "FizzBuzz".to_string(),
            (0, _) => "Fizz".to_string(),
            (_, 0) => "Buzz".to_string(),
            _ => String::new(),
        };
        FizzBuzzValue::new(number, value)
    }
}
