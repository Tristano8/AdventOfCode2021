import Data.Char
import Data.List
import Data.Ord

-- Part 1

getMostFrequent :: (Eq a, Ord a) => [a] -> a
getMostFrequent = head . maximumBy (comparing length) . group . sort

getLeastFrequent :: (Eq a, Ord a) => [a] -> a
getLeastFrequent = head . minimumBy (comparing length) . group . sort

getGammaRate :: (Eq a, Ord a)=> [[a]] -> [a]
getGammaRate codes = getMostFrequent (head <$> codes) : getGammaRate (tail <$> codes)

getEpsilonRate :: (Eq a, Ord a) => [[a]] -> [a]
getEpsilonRate codes = getLeastFrequent (head <$> codes) : getEpsilonRate (tail <$> codes)

getOxygenGeneratorRate :: [[Char]] -> [Char]
getOxygenGeneratorRate codes = currentDigit : getOxygenGeneratorRate (tail <$> remainingCodes) where
  currentDigit = getMostFrequent $ head <$> codes
  remainingCodes = filter (\x -> head x == currentDigit) codes

getCo2Rating :: [[Char]] -> [Char]
getCo2Rating codes = currentDigit : getOxygenGeneratorRate (tail <$> remainingCodes) where
  currentDigit = getLeastFrequent $ head <$> codes
  remainingCodes = filter (\x -> head x == currentDigit) codes

bintodec :: [Int] -> Int
bintodec = foldl' (\y x -> x + 2*y) 0


-- main' :: IO ()
-- main' = do
--   file <- readFile "./day3.txt"
  
--   let codes = lines file
--       parseAsDec = bintodec . (digitToInt <$>)

--       gamma = parseAsDec "000010111101"
--       epsilon = parseAsDec "111101000010"

--       in print $ gamma * epsilon


-- Part 2
main :: IO ()
main = do
  file <- readFile "./day3.txt"
  
  let codes = lines file
      parseAsDec = bintodec . (digitToInt <$>)

      oxygenGeneratorRate = parseAsDec "010000101111"
      co2Rate = parseAsDec "101100110111"

      -- 1071 -- 3706
      in print co2Rate