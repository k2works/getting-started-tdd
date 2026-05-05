use crate::domain::model::FizzBuzzValue;

pub trait FizzBuzzType {
    fn generate(&self, number: i32) -> FizzBuzzValue;
}
