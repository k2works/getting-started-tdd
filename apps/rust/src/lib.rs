#![warn(clippy::cognitive_complexity)]

pub mod application;
pub mod domain;
pub mod fizz_buzz;

pub use application::{FizzBuzzCommand, FizzBuzzListCommand, FizzBuzzValueCommand};
pub use domain::model::{FizzBuzzList, FizzBuzzValue};
pub use domain::types::{
    FizzBuzzType, FizzBuzzType01, FizzBuzzType02, FizzBuzzType03, FizzBuzzTypeName,
};
pub use fizz_buzz::{create, generate, generate_list, print_fizzbuzz};

#[cfg(test)]
mod tests {
    use std::io::Write;

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

    mod fizz_buzz_type_nameの場合 {
        use super::*;

        #[test]
        fn test_数値からタイプ名へ変換できる() {
            assert_eq!(
                FizzBuzzTypeName::Standard,
                FizzBuzzTypeName::from_number(1).unwrap()
            );
            assert_eq!(
                FizzBuzzTypeName::NumberOnly,
                FizzBuzzTypeName::from_number(2).unwrap()
            );
            assert_eq!(
                FizzBuzzTypeName::FizzBuzzOnly,
                FizzBuzzTypeName::from_number(3).unwrap()
            );
        }

        #[test]
        fn test_存在しない数値はエラーを返す() {
            let result = FizzBuzzTypeName::from_number(99);

            match result {
                Ok(_) => panic!("エラーが返ることを期待しています"),
                Err(message) => assert_eq!("タイプ99は見つかりません", message),
            }
        }

        #[test]
        fn test_タイプ名から表示ラベルを取得できる() {
            assert_eq!("通常", FizzBuzzTypeName::Standard.label());
            assert_eq!("数値のみ", FizzBuzzTypeName::NumberOnly.label());
            assert_eq!("FizzBuzzのみ", FizzBuzzTypeName::FizzBuzzOnly.label());
        }

        #[test]
        fn test_タイプ名からfizzbuzz_typeを生成できる() {
            let fizz_buzz_type = FizzBuzzTypeName::Standard.create_type();

            let value = fizz_buzz_type.generate(15);

            assert_eq!("FizzBuzz", value.value());
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

        #[test]
        fn test_filter_by_valueで指定した値だけを抽出できる() {
            let fizz_buzz_type = FizzBuzzType01;

            let list = FizzBuzzList::new(&fizz_buzz_type);
            let fizz_values = list.filter_by_value("Fizz");

            assert_eq!(27, fizz_values.len());
            assert!(fizz_values.iter().all(|v| v.value() == "Fizz"));
        }

        #[test]
        fn test_map_valuesで値の文字列リストに変換できる() {
            let fizz_buzz_type = FizzBuzzType01;

            let list = FizzBuzzList::new(&fizz_buzz_type);
            let values = list.map_values();

            assert_eq!(100, values.len());
            assert_eq!("1", values[0]);
            assert_eq!("Fizz", values[2]);
            assert_eq!("Buzz", values[4]);
            assert_eq!("FizzBuzz", values[14]);
        }

        #[test]
        fn test_find_firstで最初に一致した値を取得できる() {
            let fizz_buzz_type = FizzBuzzType01;

            let list = FizzBuzzList::new(&fizz_buzz_type);
            let first_buzz = list.find_first("Buzz").unwrap();

            assert_eq!(5, first_buzz.number());
            assert_eq!("Buzz", first_buzz.value());
        }

        #[test]
        fn test_any_matchで一致する値があるか判定できる() {
            let fizz_buzz_type = FizzBuzzType01;

            let list = FizzBuzzList::new(&fizz_buzz_type);

            assert!(list.any_match("FizzBuzz"));
            assert!(!list.any_match("NotFound"));
        }

        #[test]
        fn test_all_matchで全ての値が条件を満たすか判定できる() {
            let fizz_buzz_type = FizzBuzzType01;

            let list = FizzBuzzList::new(&fizz_buzz_type);

            assert!(list.all_match(|v| v.number() >= 1));
            assert!(!list.all_match(|v| v.value() == "Fizz"));
        }

        #[test]
        fn test_takeで先頭n件を取得できる() {
            let fizz_buzz_type = FizzBuzzType01;

            let list = FizzBuzzList::new(&fizz_buzz_type);
            let values = list.take(5);

            assert_eq!(5, values.len());
            assert_eq!("1", values[0].value());
            assert_eq!("2", values[1].value());
            assert_eq!("Fizz", values[2].value());
            assert_eq!("4", values[3].value());
            assert_eq!("Buzz", values[4].value());
        }

        #[test]
        fn test_joinで指定した区切り文字で連結できる() {
            let fizz_buzz_type = FizzBuzzType01;

            let list = FizzBuzzList::new(&fizz_buzz_type);
            let joined = list.join(",");

            assert!(joined.starts_with("1,2,Fizz,4,Buzz"));
            assert!(joined.contains("FizzBuzz"));
        }

        #[test]
        fn test_reduceで値を集約できる() {
            let fizz_buzz_type = FizzBuzzType01;

            let list = FizzBuzzList::new(&fizz_buzz_type);
            let joined = list.reduce(|acc, v| {
                if acc.is_empty() {
                    v.value().to_string()
                } else {
                    format!("{}|{}", acc, v.value())
                }
            });

            assert!(joined.starts_with("1|2|Fizz|4|Buzz"));
            assert!(joined.contains("FizzBuzz"));
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
