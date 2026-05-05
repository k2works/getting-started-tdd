#![warn(clippy::cognitive_complexity)]

use std::io::Write;

#[derive(Debug, Clone, PartialEq)]
pub struct FizzBuzzValue {
    number: i32,
    value: String,
}

impl FizzBuzzValue {
    pub fn new(number: i32, value: String) -> Self {
        Self { number, value }
    }

    pub fn number(&self) -> i32 {
        self.number
    }

    pub fn value(&self) -> &str {
        &self.value
    }
}

impl std::fmt::Display for FizzBuzzValue {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{}", self.value)
    }
}

pub trait FizzBuzzType {
    fn generate(&self, number: i32) -> FizzBuzzValue;
}

pub struct FizzBuzzType01;

impl FizzBuzzType for FizzBuzzType01 {
    fn generate(&self, number: i32) -> FizzBuzzValue {
        let value = match (number % 3, number % 5) {
            (0, 0) => "FizzBuzz".to_string(),
            (0, _) => "Fizz".to_string(),
            (_, 0) => "Buzz".to_string(),
            _ => number.to_string(),
        };
        FizzBuzzValue::new(number, value)
    }
}

pub struct FizzBuzzType02;

impl FizzBuzzType for FizzBuzzType02 {
    fn generate(&self, number: i32) -> FizzBuzzValue {
        FizzBuzzValue::new(number, number.to_string())
    }
}

pub struct FizzBuzzType03;

impl FizzBuzzType for FizzBuzzType03 {
    fn generate(&self, number: i32) -> FizzBuzzValue {
        let value = match (number % 3, number % 5) {
            (0, 0) => "FizzBuzz".to_string(),
            (0, _) => "Fizz".to_string(),
            (_, 0) => "Buzz".to_string(),
            _ => String::new(),
        };
        FizzBuzzValue::new(number, value)
    }
}

pub fn create(type_number: i32) -> Result<Box<dyn FizzBuzzType>, String> {
    match type_number {
        1 => Ok(Box::new(FizzBuzzType01)),
        2 => Ok(Box::new(FizzBuzzType02)),
        3 => Ok(Box::new(FizzBuzzType03)),
        _ => Err(format!("タイプ{}は見つかりません", type_number)),
    }
}

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

pub trait FizzBuzzCommand {
    fn execute(&self) -> String;
}

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

#[cfg(test)]
mod tests {
    use super::*;

    mod fizz_buzz_valueの場合 {
        use super::*;

        #[test]
        fn test_数値と文字列を保持できる() {
            let value = FizzBuzzValue::new(1, "1".to_string());

            assert_eq!(1, value.number());
            assert_eq!("1", value.value());
        }

        #[test]
        fn test_displayで値を文字列として表示できる() {
            let value = FizzBuzzValue::new(3, "Fizz".to_string());

            assert_eq!("Fizz", value.to_string());
        }
    }

    mod fizz_buzz_type01の場合 {
        use super::*;

        #[test]
        fn test_1を渡したら文字列1を持つ値を返す() {
            let fizz_buzz_type = FizzBuzzType01;

            let value = fizz_buzz_type.generate(1);

            assert_eq!(1, value.number());
            assert_eq!("1", value.value());
        }

        #[test]
        fn test_3を渡したらfizzを持つ値を返す() {
            let fizz_buzz_type = FizzBuzzType01;

            let value = fizz_buzz_type.generate(3);

            assert_eq!(3, value.number());
            assert_eq!("Fizz", value.value());
        }

        #[test]
        fn test_5を渡したらbuzzを持つ値を返す() {
            let fizz_buzz_type = FizzBuzzType01;

            let value = fizz_buzz_type.generate(5);

            assert_eq!(5, value.number());
            assert_eq!("Buzz", value.value());
        }

        #[test]
        fn test_15を渡したらfizzbuzzを持つ値を返す() {
            let fizz_buzz_type = FizzBuzzType01;

            let value = fizz_buzz_type.generate(15);

            assert_eq!(15, value.number());
            assert_eq!("FizzBuzz", value.value());
        }
    }

    mod fizz_buzz_type02の場合 {
        use super::*;

        #[test]
        fn test_3を渡しても文字列3を持つ値を返す() {
            let fizz_buzz_type = FizzBuzzType02;

            let value = fizz_buzz_type.generate(3);

            assert_eq!(3, value.number());
            assert_eq!("3", value.value());
        }

        #[test]
        fn test_5を渡しても文字列5を持つ値を返す() {
            let fizz_buzz_type = FizzBuzzType02;

            let value = fizz_buzz_type.generate(5);

            assert_eq!(5, value.number());
            assert_eq!("5", value.value());
        }
    }

    mod fizz_buzz_type03の場合 {
        use super::*;

        #[test]
        fn test_1を渡したら空文字を持つ値を返す() {
            let fizz_buzz_type = FizzBuzzType03;

            let value = fizz_buzz_type.generate(1);

            assert_eq!(1, value.number());
            assert_eq!("", value.value());
        }

        #[test]
        fn test_3を渡したらfizzを持つ値を返す() {
            let fizz_buzz_type = FizzBuzzType03;

            let value = fizz_buzz_type.generate(3);

            assert_eq!(3, value.number());
            assert_eq!("Fizz", value.value());
        }

        #[test]
        fn test_5を渡したらbuzzを持つ値を返す() {
            let fizz_buzz_type = FizzBuzzType03;

            let value = fizz_buzz_type.generate(5);

            assert_eq!(5, value.number());
            assert_eq!("Buzz", value.value());
        }

        #[test]
        fn test_15を渡したらfizzbuzzを持つ値を返す() {
            let fizz_buzz_type = FizzBuzzType03;

            let value = fizz_buzz_type.generate(15);

            assert_eq!(15, value.number());
            assert_eq!("FizzBuzz", value.value());
        }
    }

    mod createの場合 {
        use super::*;

        #[test]
        fn test_タイプ1を指定すると通常のfizzbuzzを生成する() {
            let fizz_buzz_type = create(1).unwrap();

            let value = fizz_buzz_type.generate(15);

            assert_eq!("FizzBuzz", value.value());
        }

        #[test]
        fn test_タイプ2を指定すると数値のみを生成する() {
            let fizz_buzz_type = create(2).unwrap();

            let value = fizz_buzz_type.generate(15);

            assert_eq!("15", value.value());
        }

        #[test]
        fn test_タイプ3を指定するとfizzbuzzのみを生成する() {
            let fizz_buzz_type = create(3).unwrap();

            let value = fizz_buzz_type.generate(1);

            assert_eq!("", value.value());
        }

        #[test]
        fn test_存在しないタイプを指定するとエラーを返す() {
            let result = create(99);

            match result {
                Ok(_) => panic!("エラーが返ることを期待しています"),
                Err(message) => assert_eq!("タイプ99は見つかりません", message),
            }
        }
    }

    mod fizz_buzz_listの場合 {
        use super::*;

        #[test]
        fn test_通常のfizzbuzzを100件生成できる() {
            let fizz_buzz_type = FizzBuzzType01;

            let list = FizzBuzzList::new(&fizz_buzz_type);

            assert_eq!(100, list.len());
            assert!(!list.is_empty());
            assert_eq!("1", list.value()[0].value());
            assert_eq!("Fizz", list.value()[2].value());
            assert_eq!("Buzz", list.value()[4].value());
            assert_eq!("FizzBuzz", list.value()[14].value());
        }

        #[test]
        fn test_displayで改行区切りの文字列にできる() {
            let fizz_buzz_type = FizzBuzzType01;

            let list = FizzBuzzList::new(&fizz_buzz_type);
            let output = list.to_string();

            assert!(output.starts_with("1\n2\nFizz"));
            assert!(output.contains("FizzBuzz"));
        }
    }

    mod fizz_buzz_value_commandの場合 {
        use super::*;

        #[test]
        fn test_タイプ1と数値15を指定してfizzbuzzを実行できる() {
            let command = FizzBuzzValueCommand::new(1, 15).unwrap();

            assert_eq!("FizzBuzz", command.execute());
        }

        #[test]
        fn test_タイプ2と数値15を指定して数値文字列を実行できる() {
            let command = FizzBuzzValueCommand::new(2, 15).unwrap();

            assert_eq!("15", command.execute());
        }

        #[test]
        fn test_存在しないタイプを指定するとエラーを返す() {
            let result = FizzBuzzValueCommand::new(99, 1);

            match result {
                Ok(_) => panic!("エラーが返ることを期待しています"),
                Err(message) => assert_eq!("タイプ99は見つかりません", message),
            }
        }
    }

    mod fizz_buzz_list_commandの場合 {
        use super::*;

        #[test]
        fn test_タイプ1を指定して100件のfizzbuzzを実行できる() {
            let command = FizzBuzzListCommand::new(1).unwrap();

            let output = command.execute();

            assert!(output.starts_with("1\n2\nFizz"));
            assert!(output.contains("Buzz"));
            assert!(output.contains("FizzBuzz"));
        }

        #[test]
        fn test_タイプ3を指定してfizzbuzzのみを実行できる() {
            let command = FizzBuzzListCommand::new(3).unwrap();

            let output = command.execute();

            assert!(output.starts_with("\n\nFizz"));
            assert!(output.contains("FizzBuzz"));
        }

        #[test]
        fn test_存在しないタイプを指定するとエラーを返す() {
            let result = FizzBuzzListCommand::new(99);

            match result {
                Ok(_) => panic!("エラーが返ることを期待しています"),
                Err(message) => assert_eq!("タイプ99は見つかりません", message),
            }
        }
    }

    mod その他の場合 {
        use super::*;

        #[test]
        fn test_1を渡したら文字列1を返す() {
            assert_eq!("1", generate(1));
        }

        #[test]
        fn test_2を渡したら文字列2を返す() {
            assert_eq!("2", generate(2));
        }
    }

    mod 三の倍数の場合 {
        use super::*;

        #[test]
        fn test_3を渡したらfizzを返す() {
            assert_eq!("Fizz", generate(3));
        }

        #[test]
        fn test_6を渡したらfizzを返す() {
            assert_eq!("Fizz", generate(6));
        }
    }

    mod 五の倍数の場合 {
        use super::*;

        #[test]
        fn test_5を渡したらbuzzを返す() {
            assert_eq!("Buzz", generate(5));
        }

        #[test]
        fn test_10を渡したらbuzzを返す() {
            assert_eq!("Buzz", generate(10));
        }
    }

    mod 三と五の倍数の場合 {
        use super::*;

        #[test]
        fn test_15を渡したらfizzbuzzを返す() {
            assert_eq!("FizzBuzz", generate(15));
        }
    }

    #[test]
    fn test_generate_list_1から100までのfizzbuzzを返す() {
        let result = generate_list(1, 100);
        assert_eq!(100, result.len());
        assert_eq!("1", result[0]);
        assert_eq!("2", result[1]);
        assert_eq!("Fizz", result[2]);
        assert_eq!("4", result[3]);
        assert_eq!("Buzz", result[4]);
        assert_eq!("FizzBuzz", result[14]);
    }

    #[test]
    fn test_learning_write_バッファに出力できる() {
        let mut buf = Vec::new();
        writeln!(buf, "hello").unwrap();
        assert_eq!("hello\n", String::from_utf8(buf).unwrap());
    }

    #[test]
    fn test_print_fizzbuzzの結果を出力する() {
        let mut buf = Vec::new();
        print_fizzbuzz(&mut buf);
        let output = String::from_utf8(buf).unwrap();
        assert!(output.contains("1\n"));
        assert!(output.contains("Fizz\n"));
        assert!(output.contains("Buzz\n"));
        assert!(output.contains("FizzBuzz\n"));
    }
}
