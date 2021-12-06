module Main where

import Text.Trifecta

-- Part 1

newtype LanternFish = LanternFish Int deriving (Eq, Show)

ageLanternFish :: LanternFish -> LanternFish
ageLanternFish (LanternFish n) = if n == 0 then LanternFish 6 else LanternFish (n - 1)

elapseDay :: [LanternFish] -> [LanternFish]
elapseDay = foldr (\lf@(LanternFish n) lfs -> if n == 0 then LanternFish 8 : ageLanternFish lf : lfs else ageLanternFish : lfs)

main :: IO ()
main = do
  putStrLn "hello world"
