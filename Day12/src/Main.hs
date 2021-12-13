module Main where

import qualified Data.Map as M
import Data.Char
import Data.List
import Data.Maybe
import Text.Trifecta

type Caves = M.Map String [String]

parseInput :: Parser Caves
parseInput = do
  connections <- manyTill caveConnection eof

  let twoWayConnections = connections ++ (reverse <$> connections)
      pairs = (\(from:to:xs) -> (from,[to])) <$> twoWayConnections
      allConnections = foldr (\(k, v) xs -> M.insertWith (++) k v xs) M.empty pairs

   in return allConnections where
    caveConnection = token (sepBy (some letter) (char '-'))
  

-- Part 1
canVisitCave :: String -> [String] -> Bool
canVisitCave cave visited = all isUpper cave || cave `notElem` visited

findPaths :: (String -> [String] -> Bool) -> Caves -> [[String]]
findPaths canVisit caves = followPath [] "start" where
  followPath visited cave =
    let connected = fromMaybe [] $ M.lookup cave caves
        neighbouringPaths = concatMap (followPath (cave : visited)) connected in
        if cave == "end" then [reverse (cave : visited)]
        else if canVisit cave visited then
          neighbouringPaths
          else [] 

-- Part 2

hasVisitedTwice :: String -> [String] -> Bool
hasVisitedTwice cave = (==2) . length . filter (cave==)

canVisitCave' :: String -> [String] -> Bool
canVisitCave' cave visited = all isUpper cave || cave == "start" && null visited || cave /= "start" && (cave `notElem` visited || not (any (\c -> all isLower c && hasVisitedTwice c visited) visited))

main :: IO ()
main = do
  caves <- fromMaybe M.empty <$> parseFromFile parseInput "./src/day12.txt"
  print $ length (findPaths canVisitCave' caves)
