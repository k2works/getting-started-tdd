use crate::application::fizz_buzz_command::FizzBuzzCommand;
use crate::domain::types::fizz_buzz_type::FizzBuzzType;

pub struct FizzBuzzValueCommand {
    pub fizz_buzz_type: Box<dyn FizzBuzzType>,
    pub number: i32,
}

impl FizzBuzzCommand for FizzBuzzValueCommand {
    fn execute(&self) -> String {
        self.fizz_buzz_type.generate(self.number).to_string()
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::domain::types::fizz_buzz_type01::FizzBuzzType01;

    #[test]
    fn test_execute_指定数値の結果を返す() {
        let command = FizzBuzzValueCommand {
            fizz_buzz_type: Box::new(FizzBuzzType01),
            number: 15,
        };
        assert_eq!("FizzBuzz", command.execute());
    }
}
