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

-- Part 2 - Keep a map of pairs in the template instead of a list

type Template' = M.Map String Int
type StartChar = Char
data Input' = Input' Template' Rules StartChar deriving (Show)

parseInput' :: Parser Input'
parseInput' = do
  template <- token $ some upper
  rules <- some $ token parseRule

  let templateMap = M.fromListWith (+) ((\x -> (x, 1)) <$> (getPairs template))
    in pure $ Input' templateMap (M.fromList rules) (head template)

step' :: Template' -> Rules -> Template'
step' template rules = M.fromListWith (+) $ do
                          (pair@(c:c':_), n) <- M.assocs template
                          let insertChar :: Char
                              insertChar = fromJust $ M.lookup pair rules
                          [(c:[insertChar], n), (insertChar:[c'], n)]

count' :: Template' -> StartChar -> Int
count' t char = maximum charCounts - minimum charCounts where
  charCounts = M.elems (M.insertWith (+) char 1 (M.fromListWith (+) $ do
                      (c:c':_, n) <- M.assocs t
                      [(c', n)]))

                          
part2 :: Input' -> Int
part2 (Input' template rules startChar) = let finalTemplate = (!!40) $ iterate' (`step'` rules) template 
                                          in count' finalTemplate startChar

main :: IO ()
main = do
  input@(Input' template rules startChar) <- fromMaybe (Input' mempty mempty ' ') <$> parseFromFile parseInput' "./src/day14.txt"
  print $ part2 input
