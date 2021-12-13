module Main where

import Control.Applicative
import Data.Functor
import Data.Maybe
import qualified Data.Set as S

import Text.Trifecta

data Point = Point { _x, _y :: Integer } deriving (Eq, Ord, Show)

data Axis = X | Y
data Fold = Fold Axis Integer

type Paper = S.Set Point

data Input = Input Paper [Fold]

parsePoint :: Parser Point
parsePoint = do
  (x:y:_) <- sepBy integer (char ',')

  pure $ Point (fromIntegral x) (fromIntegral y)

parseFold :: Parser Fold
parseFold = Fold <$> (string "fold along " *> axis) <* char '=' <*> decimal where
  axis = X <$ char 'x' <|> Y <$ char 'y'

parseInput :: Parser Input
parseInput = do
  points <- some $ token parsePoint
  folds <- some $ token parseFold

  pure $ Input (S.fromList points) folds

main :: IO ()
main = do
  input <- fromMaybe (Input mempty mempty) <$> parseFromFile parseInput "./src/day13.txt"
  print "OK"
