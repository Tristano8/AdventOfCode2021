module Main where

import Text.Trifecta
import Data.Maybe

-- Part 1

newtype LanternFish = LanternFish Integer deriving (Eq, Show)

ageLanternFish :: LanternFish -> LanternFish
ageLanternFish (LanternFish n) = if n == 0 then LanternFish 6 else LanternFish (n - 1)

elapseDay :: [LanternFish] -> [LanternFish]
elapseDay = foldr (\lf@(LanternFish n) lfs -> if n == 0 then LanternFish 8 : ageLanternFish lf : lfs else ageLanternFish lf : lfs) []

times :: (a -> a) -> Int -> (a -> a)
times f n = foldr (.) id (replicate n f)
 
type Input = String

parseInput :: Parser [LanternFish]
parseInput = do
  fish <- sepBy integer (char ',')
  return $ LanternFish <$> fish

main :: IO ()
main = do
  fish <- fromMaybe [] <$> parseFromFile parseInput "./src/day6.txt"

  print $ length (times elapseDay 80 fish)
