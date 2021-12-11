module Main where

import Data.List
import Data.Maybe
import Text.Trifecta

type Paren = Char
type Row = [Char]

parenP :: Parser Paren
parenP = choice (char <$> ['{', '}', '[', ']', '(', ')', '<', '>'])

parseInput :: Parser [Row]
parseInput = some $ token (some parenP)

isOpener :: Paren -> Bool
isOpener c = c `elem` ['{', '[', '(', '<']

errVal :: Paren -> Int
errVal c = case c of
  ')' -> 3
  ']' -> 57
  '}' -> 1197
  '>' -> 25137
  _ -> 0

matchingCloser :: Paren -> Paren
matchingCloser c = case c of
  '(' -> ')'
  '[' -> ']'
  '{' -> '}'
  '<' -> '>'
  _ -> undefined

-- Part 1

evaluateRow :: Row -> Int
evaluateRow = go [] 0 where
  go stack score [] = score
  go [] score (x:xs) = if isOpener x then go [x] score xs else errVal x
  go (y:ys) score (x:xs)
    | x == matchingCloser y = go ys score xs
    | isOpener x = go (x : y : ys) score xs
    | otherwise = errVal x


-- Part 2

completionValue :: Paren -> Int
completionValue c = case c of
  ')' -> 1
  ']' -> 2
  '}' -> 3
  '>' -> 4
  _ -> 0

evaluateRow' :: Row -> Maybe [Paren]
evaluateRow' = go [] 0 where
  go stack score [] = Just stack
  go [] score (x:xs) = if isOpener x then go [x] score xs else Nothing
  go (y:ys) score (x:xs)
    | x == matchingCloser y = go ys score xs
    | isOpener x = go (x : y : ys) score xs
    | otherwise = Nothing

getCompletionString :: [Paren] -> [Paren]
getCompletionString = fmap matchingCloser

scoreCompletionString :: [Paren] -> Int
scoreCompletionString = foldr (\x xs -> xs * 5 + completionValue x) 0 . reverse

middle :: [a] -> a
middle l = l !! (length l `div` 2)

main :: IO ()
main = do
  input <- fromMaybe [] <$> parseFromFile parseInput "./src/day10.txt"


  let completionStrings = getCompletionString . fromMaybe [] . evaluateRow' <$> input
      completionScores = filter (/=0) $ scoreCompletionString . getCompletionString . fromMaybe [] . evaluateRow' <$> input
      answer = middle (sort completionScores)
  print answer