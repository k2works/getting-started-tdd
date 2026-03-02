use crate::domain::types::fizz_buzz_type::FizzBuzzType;
use crate::domain::types::fizz_buzz_type01::FizzBuzzType01;
use crate::domain::types::fizz_buzz_type02::FizzBuzzType02;
use crate::domain::types::fizz_buzz_type03::FizzBuzzType03;

#[derive(Debug, Clone, Copy, PartialEq)]
pub enum FizzBuzzTypeName {
    Standard = 1,
    NumberOnly = 2,
    FizzBuzzOnly = 3,
}

impl FizzBuzzTypeName {
    pub fn from_number(n: i32) -> Result<Self, String> {
        match n {
            1 => Ok(Self::Standard),
            2 => Ok(Self::NumberOnly),
            3 => Ok(Self::FizzBuzzOnly),
            _ => Err(format!("invalid fizzbuzz type number: {n}")),
        }
    }

    pub fn create_type(&self) -> Box<dyn FizzBuzzType> {
        match self {
            Self::Standard => Box::new(FizzBuzzType01),
            Self::NumberOnly => Box::new(FizzBuzzType02),
            Self::FizzBuzzOnly => Box::new(FizzBuzzType03),
        }
    }

    pub fn label(&self) -> &str {
        match self {
            Self::Standard => "Standard",
            Self::NumberOnly => "NumberOnly",
            Self::FizzBuzzOnly => "FizzBuzzOnly",
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_from_number_有効値を変換できる() {
        assert_eq!(
            Ok(FizzBuzzTypeName::Standard),
            FizzBuzzTypeName::from_number(1)
        );
    }

    #[test]
    fn test_from_number_無効値はエラーを返す() {
        assert!(FizzBuzzTypeName::from_number(99).is_err());
    }

    #[test]
    fn test_create_type_種別に応じた振る舞いを生成する() {
        let t = FizzBuzzTypeName::FizzBuzzOnly.create_type();
        assert_eq!("", t.generate(1).value());
        assert_eq!("Fizz", t.generate(3).value());
    }

    #[test]
    fn test_label_表示名を返す() {
        assert_eq!("NumberOnly", FizzBuzzTypeName::NumberOnly.label());
    }
}
