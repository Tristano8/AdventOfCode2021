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
  signalPattern <- count 10 (token (some letter))
  _ <- token (char '|')
  outputVal <- count 4 $ token (some letter)
  return $ Display signalPattern outputVal


parseInput :: Parser [Display]
parseInput = some (token parseDisplay)

-- 7 has the segment not in 1
-- 3 has all the segments of 7, plus two more
-- 8 has all the segments of 8, plus two more

-- part 1
countUniqueSegments :: [Display] -> Int
countUniqueSegments displays = sum $ foldr (\(Display _ ov) ds ->
  length (filter (\s -> let segs = length s in segs == 2 || segs == 3 || segs == 4 || segs == 7) ov) : ds) [] displays

main = do
  input <- fromMaybe [] <$> parseFromFile parseInput "./src/day8.txt"
  print $ countUniqueSegments input
