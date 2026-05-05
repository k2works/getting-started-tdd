use crate::domain::model::FizzBuzzList;
use crate::domain::types::FizzBuzzType;
use crate::fizz_buzz::create;

use super::FizzBuzzCommand;

pub struct FizzBuzzListCommand {
    fizz_buzz_type: Box<dyn FizzBuzzType>,
}

impl FizzBuzzListCommand {
    pub fn new(type_number: i32) -> Result<Self, String> {
        let fizz_buzz_type = create(type_number)?;
        Ok(Self { fizz_buzz_type })
    }
}

impl FizzBuzzCommand for FizzBuzzListCommand {
    fn execute(&self) -> String {
        let list = FizzBuzzList::new(self.fizz_buzz_type.as_ref());
        list.to_string()
    }
}
