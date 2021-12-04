import Data.List

-- Part 1

type Row = Int
type Col = Int
data BingoNumber = BingoNumber String (Row, Col) deriving (Eq, Show)

newtype Board = Board [BingoNumber] deriving (Eq, Show)

wordsWhen :: (Char -> Bool) -> String -> [String]
wordsWhen p s =  case dropWhile p s of
                      "" -> []
                      s' -> w : wordsWhen p s''
                            where (w, s'') = break p s'

splitCommas :: String -> [String]
splitCommas = wordsWhen (== ',')

buildBoard :: [String] -> Board
buildBoard ns = Board $ go ns 1 1 where
  go [] _ _ = []
  go (x:xs) row col = BingoNumber x (row, col) : go xs (if col == 5 then row + 1 else row) (if col == 5 then 1 else col + 1)

buildBoards :: [[String]] -> [Board]
buildBoards [] = []
buildBoards boards = buildBoard (concat $ take 5 boards) : buildBoards (drop 5 boards)

sameRow :: BingoNumber -> BingoNumber -> Bool
sameRow (BingoNumber _ (r, _)) (BingoNumber _ (r', _)) = r == r'

sameColumn :: BingoNumber -> BingoNumber -> Bool
sameColumn (BingoNumber _ (_, c)) (BingoNumber _ (_, c')) = c == c'

checkBoard :: [String] -> Board -> Bool
checkBoard numbers (Board board) =  hasWinningLength filledRows || hasWinningLength filledColumns
  where matchingNumbers = filter (\(BingoNumber v _) -> v `elem` numbers) board
        filledRows = groupBy sameRow matchingNumbers
        filledColumns = groupBy sameColumn matchingNumbers
        hasWinningLength = any ((==5) . length)

checkWinner :: [Board] -> [String] -> Maybe Board
checkWinner boards numbers = find (checkBoard numbers) boards

runGame :: [Board] -> [String] -> (Board, [String])
runGame boards numbers = go numbers 1 where
  go ns i = case checkWinner boards (take i ns) of
    Nothing -> go ns (i + 1)
    Just b -> (b, take i ns)

getTotal ::  Board -> [String] -> Int
getTotal (Board board) winningNumbers = sum ((\(BingoNumber v _) -> read v) <$> leftoverNumbers) where
  leftoverNumbers = filter (\(BingoNumber v _) -> v `notElem` winningNumbers ) board

main :: IO ()
main = do
  inputs <- readFile "./day4.txt"

  let (numbers : boardData) = lines inputs
      ns = words <$> filter (not . null) boardData
      gameBoards = buildBoards ns

      (winningBoard, winningNumbers) = runGame gameBoards (splitCommas numbers)
  print winningNumbers
  print winningBoard
  print $ getTotal winningBoard winningNumbers