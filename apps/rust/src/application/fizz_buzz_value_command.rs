use crate::domain::types::FizzBuzzType;
use crate::fizz_buzz::create;

use super::FizzBuzzCommand;

pub struct FizzBuzzValueCommand {
    fizz_buzz_type: Box<dyn FizzBuzzType>,
    number: i32,
}

impl FizzBuzzValueCommand {
    pub fn new(type_number: i32, number: i32) -> Result<Self, String> {
        let fizz_buzz_type = create(type_number)?;
        Ok(Self {
            fizz_buzz_type,
            number,
        })
    }
}

impl FizzBuzzCommand for FizzBuzzValueCommand {
    fn execute(&self) -> String {
        self.fizz_buzz_type.generate(self.number).to_string()
    }
}
