use std::io::Write;

use crate::domain::types::{FizzBuzzType, FizzBuzzType01, FizzBuzzType02, FizzBuzzType03};

pub fn create(type_number: i32) -> Result<Box<dyn FizzBuzzType>, String> {
    match type_number {
        1 => Ok(Box::new(FizzBuzzType01)),
        2 => Ok(Box::new(FizzBuzzType02)),
        3 => Ok(Box::new(FizzBuzzType03)),
        _ => Err(format!("タイプ{}は見つかりません", type_number)),
    }
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
