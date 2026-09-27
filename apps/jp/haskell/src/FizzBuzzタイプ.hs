-- | 題材 B: 名前と変換関数を持つタイプ
-- 型名・データ構築子は大文字で始める必要があるため、ASCII の T を接頭辞にしている。
module FizzBuzzタイプ
  ( Tタイプ (..)
  , Tタイプ番号 (..)
  , タイプ生成
  , 番号から生成
  , タイプ変換
  ) where

import FizzBuzz変換 (fizzBuzz変換)

data Tタイプ = Tタイプ
  { 名前 :: String
  , 変換 :: Int -> String
  }

data Tタイプ番号 = T通常 | T数字限定 | TFizzBuzz限定
  deriving (Show, Eq, Enum, Bounded)

番号から生成 :: Tタイプ番号 -> Tタイプ
番号から生成 T通常 = Tタイプ "通常" fizzBuzz変換
番号から生成 T数字限定 = Tタイプ "数字限定" show
番号から生成 TFizzBuzz限定 = Tタイプ "FizzBuzz限定" fizzBuzz限定変換

タイプ生成 :: Int -> Either String Tタイプ
タイプ生成 1 = Right (番号から生成 T通常)
タイプ生成 2 = Right (番号から生成 T数字限定)
タイプ生成 3 = Right (番号から生成 TFizzBuzz限定)
タイプ生成 番号 = Left ("該当するタイプは存在しません: " ++ show 番号)

タイプ変換 :: Tタイプ -> Int -> String
タイプ変換 = 変換

fizzBuzz限定変換 :: Int -> String
fizzBuzz限定変換 数
  | 数 `mod` 15 == 0 = "FizzBuzz"
  | otherwise = show 数
