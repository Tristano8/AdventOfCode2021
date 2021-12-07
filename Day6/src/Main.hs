{-# LANGUAGE TupleSections #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module Main where

import Text.Trifecta
import Data.Maybe
import qualified Data.Map as M

-- Part 1

newtype Age = Age Integer deriving (Eq, Enum, Show, Ord, Num)
newtype Count = Count Integer deriving (Eq, Show, Num)

type School = M.Map Age Count

-- left union keeps new fish
elapseDay :: School -> School
elapseDay s = M.unionWith (+) aged born where
  aged = M.fromList $ do
    currentAge <- Age <$> [1..8]
    pure (currentAge - 1, M.findWithDefault 0 currentAge s) -- lookup values at previous age key
  born = M.fromList [(Age 6, M.findWithDefault 0 (Age 0) s), (Age 8, M.findWithDefault 0 (Age 0) s)]

times :: (a -> a) -> Int -> (a -> a)
times f n = foldr (.) id (replicate n f)
 
type Input = String

parseInput :: Parser School
parseInput = do
  ages <- fmap (fmap Age) (sepBy integer (char ','))
  -- Tally each age
  let agePairs = (,1) <$> ages
  pure $ M.fromListWith (+) agePairs

countFish :: School -> Count
countFish = sum

main' :: IO ()
main' = do
  fish <- fromMaybe M.empty <$> parseFromFile parseInput "./src/day6.txt"

  print $ sum (times elapseDay 80 fish)


main :: IO ()
main = do
  fish <- fromMaybe M.empty <$> parseFromFile parseInput "./src/day6.txt"

  print $ sum (times elapseDay 256 fish)
