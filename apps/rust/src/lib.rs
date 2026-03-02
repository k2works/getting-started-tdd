use std::io::Write;

pub fn generate(number: i32) -> String {
    match (number % 3, number % 5) {
        (0, 0) => "FizzBuzz".to_string(),
        (0, _) => "Fizz".to_string(),
        (_, 0) => "Buzz".to_string(),
        _ => number.to_string(),
    }
}

pub fn generate_list(start: i32, end: i32) -> Vec<String> {
    (start..=end).map(generate).collect()
}

pub fn print_fizzbuzz(writer: &mut dyn Write) {
    for line in generate_list(1, 100) {
        writeln!(writer, "{line}").expect("failed to write fizzbuzz output");
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    mod learning {
        #[test]
        fn test_to_string_整数を文字列へ変換できる() {
            assert_eq!("42", 42.to_string());
        }

        #[test]
        fn test_write_バッファに出力できる() {
            use std::io::Write;
            let mut buf = Vec::new();
            writeln!(buf, "hello").unwrap();
            assert_eq!("hello\n", String::from_utf8(buf).unwrap());
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

        #[test]
        fn test_30を渡したらfizzbuzzを返す() {
            assert_eq!("FizzBuzz", generate(30));
        }
    }

    mod リスト生成 {
        use super::*;

        #[test]
        fn test_1から100までのfizzbuzzを返す() {
            let result = generate_list(1, 100);
            assert_eq!(100, result.len());
            assert_eq!("1", result[0]);
            assert_eq!("Fizz", result[2]);
            assert_eq!("Buzz", result[4]);
            assert_eq!("FizzBuzz", result[14]);
        }
    }

    mod プリント {
        use super::*;

        #[test]
        fn test_fizzbuzzの結果を出力する() {
            let mut buf = Vec::new();
            print_fizzbuzz(&mut buf);
            let output = String::from_utf8(buf).unwrap();
            assert!(output.contains("1\n"));
            assert!(output.contains("Fizz\n"));
            assert!(output.contains("Buzz\n"));
            assert!(output.contains("FizzBuzz\n"));
        }
    }
}
