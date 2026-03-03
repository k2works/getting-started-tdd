module Main (main) where

import FizzBuzz (generateList)

main :: IO ()
main = mapM_ putStrLn (generateList 100)
