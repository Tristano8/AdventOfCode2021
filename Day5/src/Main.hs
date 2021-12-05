module Main where

import Text.Trifecta

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

main :: IO ()
main = do
  input <- readFile "./src/day5.txt"
  let lines = parseString parseLines mempty input

    in print lines
