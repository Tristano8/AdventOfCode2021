{-# LANGUAGE DeriveFunctor #-}

module Main where

import Text.Trifecta
import Data.Maybe (fromMaybe)

data Four a = Four a a a a deriving (Eq, Show, Functor)

-- TODO would be great to work out how to use the above datatype instead of [String]
type OutputValue = [String];
type SignalPattern = [String];

data Display = Display SignalPattern OutputValue deriving (Eq, Show)

parseDisplay :: Parser Display
parseDisplay = do
  signalPattern <- count 10 segments
  _ <- token (char '|')
  outputVal <- count 4 segments
  return $ Display signalPattern outputVal where
    segments = token (some letter)


parseInput :: Parser [Display]
parseInput = some (token parseDisplay)

-- 7 has the segment not in 1
-- 3 has all the segments of 7, plus two more
-- 8 has all the segments of 8, plus two more

-- part 1
countUniqueSegments :: [Display] -> Int
countUniqueSegments displays = sum $ foldr (\(Display _ ov) ds ->
  length (filter ((`elem` [2, 3, 4, 7]) . length) ov) : ds) [] displays

main' = do
  input <- fromMaybe [] <$> parseFromFile parseInput "./src/day8.txt"
  print $ countUniqueSegments input

-- part 2 
main = do
  input <- fromMaybe [] <$> parseFromFile parseInput "./src/day8.txt"
  print $ countUniqueSegments input