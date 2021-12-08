module Main where

import Text.Trifecta
import Data.List (sort)
import Data.Maybe (fromMaybe)

type Destination = Int
type Position = Int

parseInput :: Parser [Int]
parseInput = fmap fromIntegral <$> sepBy integer (char ',')

-- Given n points in a one-dimensional plane, the point that is closest to all of them will be the median

-- Can write this with an S combinator, but it's less readable IMO
-- This assumes the list is sorted
findMedian :: [Int] -> Int
findMedian s = (!!) s $ ((`div` 2) . length) s

getFuelConsumption :: Position -> Destination -> Int
getFuelConsumption = (abs .) . (-)


-- part 1

main' :: IO ()
main' = do
  nums <- sort . fromMaybe [] <$> parseFromFile parseInput "./src/day7.txt"

  print $ sum (getFuelConsumption (findMedian nums) <$> nums)


-- part 2
-- TODO Minimise the distance sum 1..n for each crab: ie. (x - T) * (x - T + 1) / 2

-- Brute force
getCheapest :: [Int] -> Int
getCheapest nums = minimum $ do
  pos <- [min..max]
  pure . sum . fmap (getFuelConsumption' . abs . (pos -)) $ nums where
    min = minimum nums
    max = maximum nums
    getFuelConsumption' d = d * (d + 1) `div` 2

main :: IO ()
main = do
  nums <- sort . fromMaybe [] <$> parseFromFile parseInput "./src/day7.txt"

  print $ getCheapest nums
