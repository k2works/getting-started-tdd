use crate::domain::types::FizzBuzzType;

use super::FizzBuzzValue;

pub struct FizzBuzzList {
    list: Vec<FizzBuzzValue>,
}

impl FizzBuzzList {
    const MAX_COUNT: usize = 100;

    pub fn new(fizz_buzz_type: &dyn FizzBuzzType) -> Self {
        let list = (1..=Self::MAX_COUNT as i32)
            .map(|n| fizz_buzz_type.generate(n))
            .collect();
        Self { list }
    }

    pub fn value(&self) -> &[FizzBuzzValue] {
        &self.list
    }

    pub fn len(&self) -> usize {
        self.list.len()
    }

    pub fn is_empty(&self) -> bool {
        self.list.is_empty()
    }
}

impl std::fmt::Display for FizzBuzzList {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        let values: Vec<String> = self.list.iter().map(|v| v.value().to_string()).collect();
        write!(f, "{}", values.join("\n"))
    }
}
