module Main where

import Text.Trifecta
import Data.Maybe
import Data.List

data Line = Line (Int, Int) (Int, Int) deriving (Eq, Show)

parseCoord :: Parser (Int, Int)
parseCoord = do
  (x:y:_) <- sepBy integer (char ',')
  return (fromInteger x, fromInteger y)

parseLine :: Parser Line
parseLine = do
 start <- token parseCoord
 _ <- token (string "->")
 end <- token parseCoord

 return $ Line start end

parseLines :: Parser [Line]
parseLines = some parseLine

-- 7,9  -> 9, 7
getPointsInBetween :: Line -> [(Int, Int)]
getPointsInBetween (Line p1 p2) = if min p1 p2 == p1 then listPoints p1 p2 else listPoints p2 p1 
  where
    listPoints (x1, y1) (x2, y2)
      | y1 == y2 = [(x, y) | x <- [x1, x1 + 1..x2],
                            y <- [y1]]
      | x1 == x2 = [(x, y) | x <- [x1],
                            y <- [y1, y1 + 1..y2]]
      | otherwise = getDiagonalPointsBetween (x1, y1) (x2, y2)

-- (0, 0) (9, 9) -> 1 2 3 4 5 6 7 8 9
-- (9, 7) (7, 9) -> 7 8 9  9 8 7
getDiagonalPointsBetween :: (Int, Int) -> (Int, Int) -> [(Int, Int)]
getDiagonalPointsBetween (x1, y1) (x2, y2) = [(x, y) | x <- [x1, x1 + 1..x2],
                                                        y <- [y1, y1 + m..y2],
                                                        x == x2 && y == y2 || gradient (x, y) (x2, y2) == m
                              ] where
                                -- (1, 0) (9, 9)  gradient (0, 1) (1, 2)
    m = gradient (x1, y1) (x2, y2)

gradient :: (Int, Int) -> (Int, Int) -> Int
gradient (x1, y1) (x2, y2) = let m = (fromIntegral y2 - fromIntegral y1) / (fromIntegral x2 - fromIntegral x1) :: Float
  in if fromIntegral (round m) == m then fromIntegral (round m) else 0

horizontal :: Line -> Bool
horizontal (Line (_, y) (_, y')) = y == y'

vertical :: Line -> Bool
vertical (Line (x, _) (x', _)) = x == x'

-- Part 1

numOverlapPoints :: [[(Int, Int)]] -> Int
numOverlapPoints = length . filter ((>1) . length)

main' :: IO ()
main' = do
  input <- fromJust <$> parseFromFile parseLines "./src/day5.txt"
  let hvlines = filter (\s -> vertical s || horizontal s) input
      allPoints = concat $ getPointsInBetween <$> hvlines
      intersectionPoints = group $ sort allPoints
      in print $ numOverlapPoints intersectionPoints


main :: IO ()
main = do
  input <- fromJust <$> parseFromFile parseLines "./src/day5.txt"
  let 
      allPoints = concat $ getPointsInBetween <$> input
      intersectionPoints = group $ sort allPoints
      in print $ numOverlapPoints intersectionPoints
  
