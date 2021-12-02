import qualified Data.Text as T
import Data.List

-- Part 1

getNumberFromDirection :: T.Text -> Int
getNumberFromDirection = read . T.unpack . last . T.words

forward = T.pack "forward"
up = T.pack "up"
down = T.pack "down"

main' :: IO ()
main' = do
  inputData <- readFile "./day2.txt"

  let directions = T.pack <$> lines inputData
      forwards = filter (T.isInfixOf forward) directions
      ups = filter (T.isInfixOf up) directions
      downs = filter (T.isInfixOf down) directions

      horizontalPosition = sum $ getNumberFromDirection <$> forwards
      depth = sum $ (negate . getNumberFromDirection <$> ups) ++ (getNumberFromDirection <$> downs)
  print depth
  print horizontalPosition
  print $ depth * horizontalPosition

-- Part 2
data Direction = Up | Down | Forward

parseDirection :: T.Text -> Direction
parseDirection s
  | T.isInfixOf up s = Up
  | T.isInfixOf down s = Down
  | otherwise = Forward

getChangeInAimFromDirection :: T.Text -> Int
getChangeInAimFromDirection s = case parseDirection s of
  Up -> negate $ getNumberFromDirection s
  Down -> getNumberFromDirection s
  Forward -> 0

main :: IO ()
main = do
  directions <- lines <$> readFile "./day2.txt"

  let textDirections = T.pack <$> directions 
      aims = scanl1 (+) (getChangeInAimFromDirection <$> textDirections)
      depthChangesFromAim = zipWith (\aim' dir -> case parseDirection dir of
                                                    Forward -> getNumberFromDirection dir * aim'
                                                    _ -> 0) aims textDirections

      forwards = filter (T.isInfixOf forward) textDirections

      horizontalPosition = sum $ getNumberFromDirection <$> forwards
  print $ sum depthChangesFromAim * horizontalPosition
