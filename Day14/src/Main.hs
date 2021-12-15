module Main where

import Data.List
import Data.Maybe
import qualified Data.Map as M

import Text.Trifecta

type Template = String
type Rules = M.Map String Char

data Input = Input Template Rules deriving (Show)

parseRule :: Parser (String, Char)
parseRule = do
  k <- some upper
  _ <- string " -> "
  v <- upper

  pure (k, v)

parseInput :: Parser Input
parseInput = do
  template <- token $ some upper
  rules <- some $ token parseRule

  pure $ Input template (M.fromList rules)

-- NNGA -> ["NN", "NG", "GA"]
getPairs :: Template -> [String]
getPairs t = zipWith (\x y -> x : [y]) t (tail t)

-- Part 1

step :: Template -> Rules -> String
step template rules = let pairs = getPairs template
                          insertChars = fromMaybe [] $ traverse (`M.lookup` rules) pairs
                          in concat $ transpose [template, insertChars]

part1 :: Input -> Int
part1 (Input template rules) = let polymer = (!!10) $ iterate' (`step` rules) template
                                   frequencies = group (sort polymer)
                                   result = sortOn length frequencies
                                   in length (head (reverse result)) - length (head result)

part2 :: Input -> String
part2 = undefined

main :: IO ()
main = do
  input@(Input template rules) <- fromMaybe (Input mempty mempty) <$> parseFromFile parseInput "./src/day14.txt"
  print $ part1 input
