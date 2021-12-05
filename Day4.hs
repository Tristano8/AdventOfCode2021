import Data.List
import Data.Maybe

-- Part 1

type BingoNumber = Maybe Int

data Board = Board [[BingoNumber]] [[BingoNumber]] deriving (Eq, Show)

data State = State { lastNumber :: Int, boards :: [Board] } deriving (Show)

wordsWhen :: (Char -> Bool) -> String -> [String]
wordsWhen p s =  case dropWhile p s of
                      "" -> []
                      s' -> w : wordsWhen p s''
                            where (w, s'') = break p s'

splitCommas :: String -> [String]
splitCommas = wordsWhen (== ',')

buildBoard :: [[String]] -> Board
buildBoard rows = Board rowNs colNs where
  rowNs = ((<$>) . (<$>)) (Just . read) rows
  colNs = transpose rowNs

buildBoards :: [String] -> [Board]
buildBoards [] = []
buildBoards boards = buildBoard boardRows : buildBoards (drop 5 boards) where
  boardRows = words <$> take 5 boards
  rest = drop 5 boards

markBoard :: Int -> Board -> Board
markBoard n (Board rows cols) = Board rows' cols' where
  rows' = ((<$>) . (<$>)) mark rows
  cols' = ((<$>) . (<$>)) mark cols
  mark i = case i of
    Nothing -> Nothing
    (Just x) -> if x == n then Nothing else Just x

checkBoard :: Board -> Bool
checkBoard (Board rows cols) =  any isFilled rows || any isFilled cols
  where isFilled = all isNothing

runGame :: [Board] -> [Int] -> [State]
runGame boards numbers = go numbers boards where
  go [] bs = []
  go (n:ns) bs = State n updatedBoards : go ns (filter (not . checkBoard) updatedBoards) where 
    updatedBoards = markBoard n <$> bs

getWinner :: [State] -> (Board, Int)
getWinner [] = error "No winner - should not happen"
getWinner ((State ln boards): ss) = case find checkBoard boards of
  Nothing -> getWinner ss
  Just winner -> (winner, ln)

getTotal ::  Board -> Int
getTotal (Board r _) = sum leftovers where
  leftovers = catMaybes $ concat r

main' :: IO ()
main' = do
  inputs <- readFile "./day4.txt"

  let (numbers : boardData) = lines inputs
      ns = filter (not . null) boardData

      numberInts = read <$> splitCommas numbers :: [Int]
      gameBoards = buildBoards ns

      (winningBoard, winningNumber) = getWinner $ runGame gameBoards numberInts  
    in print $ getTotal winningBoard * winningNumber

-- Part 2


findLastWinningBoard :: [State] -> (Board, Int)
findLastWinningBoard = go where
  go ((State ln [b]) : _) | checkBoard b = (b,ln)
  go (_ : ss) = go ss
  go [] = error "No winner"

main :: IO ()
main = do
  inputs <- readFile "./day4.txt"

  let (numbers : boardData) = lines inputs
      ns = filter (not . null) boardData

      numberInts = read <$> splitCommas numbers :: [Int]
      gameBoards = buildBoards ns

      gameStates = runGame gameBoards numberInts

      (lastBoard, lastWinningNumber) = findLastWinningBoard gameStates
    in print $ getTotal lastBoard * lastWinningNumber