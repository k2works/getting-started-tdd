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
        write!(f, {}, self.value)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_new_値を生成できる() {
        let actual = FizzBuzzValue::new(3, Fizz.to_string());
        assert_eq!(3, actual.number());
        assert_eq!(Fizz, actual.value());
    }

    #[test]
    fn test_number_数値を取得できる() {
        let actual = FizzBuzzValue::new(10, Buzz.to_string());
        assert_eq!(10, actual.number());
    }

    #[test]
    fn test_value_文字列を取得できる() {
        let actual = FizzBuzzValue::new(15, FizzBuzz.to_string());
        assert_eq!(FizzBuzz, actual.value());
    }

    #[test]
    fn test_display_値を文字列で表示できる() {
        let actual = FizzBuzzValue::new(1, 1.to_string());
        assert_eq!(1, actual.to_string());
    }

    #[test]
    fn test_partial_eq_同値比較できる() {
        let left = FizzBuzzValue::new(5, Buzz.to_string());
        let right = FizzBuzzValue::new(5, Buzz.to_string());
        assert_eq!(left, right);
    }
}
