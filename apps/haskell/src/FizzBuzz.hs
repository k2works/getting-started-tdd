module FizzBuzz
  ( generate
  , generateList
  , generateWith
  , transform
  , filterList
  , compose
  , safeGenerate
  , lazyStream
  , safeGenerateList
  ) where

-- | 単一の数値に対して FizzBuzz を生成する
generate :: Int -> String
generate n
  | n `mod` 15 == 0 = "FizzBuzz"
  | n `mod` 3 == 0  = "Fizz"
  | n `mod` 5 == 0  = "Buzz"
  | otherwise        = show n

-- | 1 から n までの FizzBuzz リストを生成する
generateList :: Int -> [String]
generateList n = map generate [1..n]

-- | カスタムルールで生成する（高階関数）
generateWith :: (Int -> String) -> Int -> String
generateWith rule = rule

-- | リストを変換する（高階関数）
transform :: (a -> b) -> [a] -> [b]
transform = map

-- | リストをフィルタリングする（高階関数）
filterList :: (a -> Bool) -> [a] -> [a]
filterList = filter

-- | 2 つの関数を合成する
compose :: (b -> c) -> (a -> b) -> a -> c
compose = (.)

-- | 安全な FizzBuzz 生成（Either モナド）
safeGenerate :: Int -> Either String String
safeGenerate n
  | n <= 0    = Left "正の整数を指定してください"
  | otherwise = Right (generate n)

-- | 遅延 FizzBuzz ストリーム
lazyStream :: [String]
lazyStream = map generate [1..]

-- | 安全な FizzBuzz リスト生成（Either モナド）
safeGenerateList :: Int -> Either String [String]
safeGenerateList n
  | n <= 0    = Left "正の整数を指定してください"
  | otherwise = Right (generateList n)
