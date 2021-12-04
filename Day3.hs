import Data.Char
import Data.List
import Data.Ord

-- Part 1

getMostFrequent :: (Eq a, Ord a) => [a] -> a
getMostFrequent = head . maximumBy (comparing length) . group . sort

getLeastFrequent :: (Eq a, Ord a) => [a] -> a
getLeastFrequent = head . minimumBy (comparing length) . group . sort

getGammaRate :: (Eq a, Ord a)=> [[a]] -> [a]
getGammaRate [rate] = rate
getGammaRate codes = getMostFrequent (head <$> codes) : getGammaRate (tail <$> codes)

getEpsilonRate :: (Eq a, Ord a) => [[a]] -> [a]
getEpsilonRate [rate] = rate
getEpsilonRate codes = getLeastFrequent (head <$> codes) : getEpsilonRate (tail <$> codes)

getOxygenGeneratorRate :: [[Char]] -> [Char]
getOxygenGeneratorRate [rate] = rate
getOxygenGeneratorRate codes = currentDigit : getOxygenGeneratorRate (tail <$> remainingCodes) where
  currentDigit = getMostFrequent $ head <$> codes
  leastFrequent = getLeastFrequent $ head <$> codes
  remainingCodes = filter (\x -> if currentDigit == leastFrequent then head x == '1' else head x == currentDigit) codes

getCo2Rating :: [[Char]] -> [Char]
getCo2Rating [rate] = rate
getCo2Rating codes = currentDigit : getCo2Rating (tail <$> remainingCodes) where
  currentDigit = getLeastFrequent $ head <$> codes
  mostFrequent = getMostFrequent $ head <$> codes
  remainingCodes = filter (\x -> if currentDigit == mostFrequent then head x == '0' else head x == currentDigit) codes

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

      oxygenGeneratorRate = parseAsDec . getOxygenGeneratorRate
      co2Rate = parseAsDec . getCo2Rating 
      answer = (*) <$> co2Rate <*> oxygenGeneratorRate

      in print $ answer codes