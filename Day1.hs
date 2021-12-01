import Data.List


-- Zip with the list compared to the list that has the first element dropped

-- Part 1
-- main :: IO ()
-- main = do
--   file <- readFile "./day1.txt"
--   let numbers = read <$> lines file :: [Int]
--       zipped = zipWith (-) numbers (drop 1 numbers)
--     in print (length $ filter (<0) zipped)

-- Part 2

-- Make a list of totals from the windows
-- a window would be first three numbers plus, first three numbers (drop 1)

-- sum take 3 xs : 

windowN :: [Int] -> [Int] -> [Int]
windowN ns sums = if length ns < 3 then sums else windowN (drop 1 ns) (sum (take 3 ns) : sums)

main :: IO ()
main = do
  file <- readFile "./day1.txt"
  let numbers = read <$> lines file :: [Int]
      windowedNumbers = reverse $ windowN numbers []

      zipped = zipWith (-) windowedNumbers (drop 1 windowedNumbers)
    in print (length $ filter (<0) zipped)