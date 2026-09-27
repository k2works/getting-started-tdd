-- | 題材 D: 成功と失敗を表す結果型
module FizzBuzz安全変換 (T変換結果 (..), 安全変換) where

import FizzBuzz変換 (fizzBuzz変換)

data T変換結果 = T成功 String | T失敗 String
  deriving (Show, Eq)

安全変換 :: Int -> T変換結果
安全変換 数
  | 数 <= 0 = T失敗 ("正の数を指定してください: " ++ show 数)
  | otherwise = T成功 (fizzBuzz変換 数)
