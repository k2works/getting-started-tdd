use std::io::Write;

use crate::domain::types::{FizzBuzzType, FizzBuzzType01, FizzBuzzTypeName};

pub fn create(type_number: i32) -> Result<Box<dyn FizzBuzzType>, String> {
    Ok(FizzBuzzTypeName::from_number(type_number)?.create_type())
}

pub fn generate(number: i32) -> String {
    FizzBuzzType01.generate(number).to_string()
}

pub fn generate_list(start: i32, end: i32) -> Vec<String> {
    (start..=end).map(generate).collect()
}

pub fn print_fizzbuzz(writer: &mut dyn Write) {
    for s in generate_list(1, 100) {
        writeln!(writer, "{}", s).unwrap();
    }
}
