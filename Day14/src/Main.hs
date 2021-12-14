module Main where

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

main :: IO ()
main = do
  input <- fromMaybe (Input mempty mempty) <$> parseFromFile parseInput "./src/day14.txt"
  print input
