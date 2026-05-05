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

    pub fn filter_by_value(&self, target: &str) -> Vec<&FizzBuzzValue> {
        self.list.iter().filter(|v| v.value() == target).collect()
    }

    pub fn map_values(&self) -> Vec<String> {
        self.list.iter().map(|v| v.value().to_string()).collect()
    }

    pub fn find_first(&self, target: &str) -> Option<&FizzBuzzValue> {
        self.list.iter().find(|v| v.value() == target)
    }

    pub fn any_match(&self, target: &str) -> bool {
        self.list.iter().any(|v| v.value() == target)
    }

    pub fn all_match(&self, predicate: impl Fn(&FizzBuzzValue) -> bool) -> bool {
        self.list.iter().all(predicate)
    }

    pub fn take(&self, n: usize) -> Vec<&FizzBuzzValue> {
        self.list.iter().take(n).collect()
    }

    pub fn join(&self, separator: &str) -> String {
        self.list
            .iter()
            .map(|v| v.value().to_string())
            .collect::<Vec<_>>()
            .join(separator)
    }

    pub fn reduce<F>(&self, f: F) -> String
    where
        F: Fn(String, &FizzBuzzValue) -> String,
    {
        self.list.iter().fold(String::new(), f)
    }
}

impl std::fmt::Display for FizzBuzzList {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        let values: Vec<String> = self.list.iter().map(|v| v.value().to_string()).collect();
        write!(f, "{}", values.join("\n"))
    }
}
