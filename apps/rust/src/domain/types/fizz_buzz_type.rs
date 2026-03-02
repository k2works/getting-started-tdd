use crate::domain::model::fizz_buzz_value::FizzBuzzValue;

pub trait FizzBuzzType {
    fn generate(&self, number: i32) -> FizzBuzzValue;
}
