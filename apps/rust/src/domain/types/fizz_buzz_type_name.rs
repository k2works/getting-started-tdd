use super::{FizzBuzzType, FizzBuzzType01, FizzBuzzType02, FizzBuzzType03};

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
            _ => Err(format!("タイプ{}は見つかりません", n)),
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
            Self::Standard => "通常",
            Self::NumberOnly => "数値のみ",
            Self::FizzBuzzOnly => "FizzBuzzのみ",
        }
    }
}
