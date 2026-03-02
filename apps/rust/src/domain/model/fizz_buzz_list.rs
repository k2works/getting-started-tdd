use std::collections::HashMap;

use crate::domain::model::fizz_buzz_value::FizzBuzzValue;
use crate::domain::types::fizz_buzz_type::FizzBuzzType;

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

    pub fn group_by_value(&self) -> HashMap<String, Vec<&FizzBuzzValue>> {
        let mut groups: HashMap<String, Vec<&FizzBuzzValue>> = HashMap::new();
        for item in &self.list {
            groups.entry(item.value().to_string()).or_default().push(item);
        }
        groups
    }

    pub fn count_by_value(&self) -> HashMap<String, usize> {
        let mut counts: HashMap<String, usize> = HashMap::new();
        for item in &self.list {
            *counts.entry(item.value().to_string()).or_default() += 1;
        }
        counts
    }

    pub fn take(&self, n: usize) -> Vec<&FizzBuzzValue> {
        self.list.iter().take(n).collect()
    }

    pub fn join(&self, separator: &str) -> String {
        self.list
            .iter()
            .map(|v| v.value())
            .collect::<Vec<_>>()
            .join(separator)
    }
}

impl std::fmt::Display for FizzBuzzList {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{}", self.join("\n"))
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::domain::types::fizz_buzz_type01::FizzBuzzType01;

    #[test]
    fn test_newとlen_100件生成する() {
        let list = FizzBuzzList::new(&FizzBuzzType01);
        assert_eq!(100, list.len());
        assert!(!list.is_empty());
    }

    #[test]
    fn test_filter_by_value_fizzを抽出する() {
        let list = FizzBuzzList::new(&FizzBuzzType01);
        let actual = list.filter_by_value("Fizz");
        assert_eq!(27, actual.len());
    }

    #[test]
    fn test_map_values_値一覧へ変換する() {
        let list = FizzBuzzList::new(&FizzBuzzType01);
        let values = list.map_values();
        assert_eq!("1", values[0]);
        assert_eq!("Fizz", values[2]);
    }

    #[test]
    fn test_find_first_最初のbuzzを取得する() {
        let list = FizzBuzzList::new(&FizzBuzzType01);
        let actual = list.find_first("Buzz").expect("buzz must exist");
        assert_eq!(5, actual.number());
    }

    #[test]
    fn test_any_match_fizzbuzzの存在を判定する() {
        let list = FizzBuzzList::new(&FizzBuzzType01);
        assert!(list.any_match("FizzBuzz"));
    }

    #[test]
    fn test_all_match_全要素を判定する() {
        let list = FizzBuzzList::new(&FizzBuzzType01);
        assert!(list.all_match(|v| !v.value().is_empty()));
    }

    #[test]
    fn test_group_by_value_値ごとにグループ化する() {
        let list = FizzBuzzList::new(&FizzBuzzType01);
        let groups = list.group_by_value();
        assert_eq!(27, groups.get("Fizz").expect("fizz group").len());
    }

    #[test]
    fn test_count_by_value_値ごとの件数を集計する() {
        let list = FizzBuzzList::new(&FizzBuzzType01);
        let counts = list.count_by_value();
        assert_eq!(27, *counts.get("Fizz").expect("fizz count"));
        assert_eq!(6, *counts.get("FizzBuzz").expect("fizzbuzz count"));
    }

    #[test]
    fn test_take_先頭n件を取得する() {
        let list = FizzBuzzList::new(&FizzBuzzType01);
        let actual = list.take(3);
        assert_eq!(3, actual.len());
        assert_eq!("1", actual[0].value());
        assert_eq!("Fizz", actual[2].value());
    }

    #[test]
    fn test_join_区切り文字で連結する() {
        let list = FizzBuzzList::new(&FizzBuzzType01);
        assert_eq!("1,2,Fizz", list.take(3).iter().map(|v| v.value()).collect::<Vec<_>>().join(","));
        assert!(list.join("\n").starts_with("1\n2\nFizz"));
    }
}
