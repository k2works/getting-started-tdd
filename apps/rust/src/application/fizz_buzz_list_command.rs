use crate::application::fizz_buzz_command::FizzBuzzCommand;
use crate::domain::model::fizz_buzz_list::FizzBuzzList;
use crate::domain::types::fizz_buzz_type::FizzBuzzType;

pub struct FizzBuzzListCommand {
    pub fizz_buzz_type: Box<dyn FizzBuzzType>,
}

impl FizzBuzzCommand for FizzBuzzListCommand {
    fn execute(&self) -> String {
        FizzBuzzList::new(self.fizz_buzz_type.as_ref()).to_string()
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::domain::types::fizz_buzz_type02::FizzBuzzType02;

    #[test]
    fn test_execute_100件の結果を返す() {
        let command = FizzBuzzListCommand {
            fizz_buzz_type: Box::new(FizzBuzzType02),
        };
        let output = command.execute();
        assert!(output.starts_with("1\n2\n3"));
        assert!(output.ends_with("100"));
    }
}
