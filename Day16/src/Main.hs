{-# LANGUAGE OverloadedStrings #-}

module Main where

import Control.Applicative
import Data.Char (digitToInt)
import Data.Maybe
import Data.List (foldl')
import Text.Trifecta
import Text.Printf (printf)

data Bit = Zero | One deriving (Eq, Show)

type Version = [Bit]
type TypeID = [Bit]
type LengthTypeID = Bit
type Value = [Bit]

data Packet = Literal Version TypeID Value | Operator Version TypeID [Packet] deriving Show

hexToBin :: Char -> String
hexToBin = printf "%04b" . digitToInt

fromResult :: a -> Result a  -> a
fromResult x (Failure _) = x
fromResult _ (Success x) = x

bitToInt :: Bit -> Int
bitToInt Zero = 0
bitToInt One = 1

bitsToInt :: [Bit] -> Int
bitsToInt = binToDec . (bitToInt <$>) where
  binToDec = foldl' (\y x ->  x + (2 * y)) 0

parseBit :: Parser Bit
parseBit = Zero <$ char '0' <|> One <$ char '1'

parseVersion :: Parser Version
parseVersion = count 3 parseBit

parseTypeID :: Parser TypeID
parseTypeID = count 3 parseBit

parseLiteralValue :: Parser Value
parseLiteralValue = do
  (flag:bits) <- count 5 parseBit

  if flag == Zero then pure bits
  else (++) bits <$> parseLiteralValue

parsePacket :: Parser Packet
parsePacket = do
  vs <- parseVersion
  ts <- parseTypeID

  if bitsToInt ts == literalPacketType then do
    n <- parseLiteralValue
    pure $ Literal vs ts n

  else do
    lengthTypeID <- parseBit

    if lengthTypeID == Zero
      then do
        lengthPackets <- bitsToInt <$> count 15 parseBit
        packetInput <- sliced (count lengthPackets parseBit) 

        let subPackets = fromResult [] $ parseByteString (many parsePacket) mempty packetInput
        pure $ Operator vs ts subPackets
      else do
        nPackets <- bitsToInt <$> count 11 parseBit
        subPackets <- count nPackets parsePacket
        pure $ Operator vs ts subPackets
  where literalPacketType = 4


parseHexAsBinString :: Parser String
parseHexAsBinString = do
  hexDigits <- some anyChar
  pure $ hexToBin =<< hexDigits

-- Part 1
sumVersion :: Packet -> Int
sumVersion (Literal v _ _) = bitsToInt v
sumVersion (Operator v _ xs) = bitsToInt v + sum (sumVersion <$> xs)


-- Part 2
applyOp :: Int -> [Int] -> Int
applyOp 0 = sum
applyOp 1 = product
applyOp 2 = minimum
applyOp 3 = maximum
applyOp 5 = gt
applyOp 6 = lt
applyOp 7 = eq'


boolToBin :: Bool -> Int
boolToBin False = 0
boolToBin True = 1

eq' :: [Int] -> Int
eq' (x:y:xs) = boolToBin (x == y)

gt :: [Int] -> Int
gt (x:y:xs) = boolToBin (x > y)

lt :: [Int] -> Int
lt (x:y:xs) = boolToBin (x < y)

evalPacket :: Packet -> Int
evalPacket (Literal _ _ n) = bitsToInt n
evalPacket (Operator _ t ps) = applyOp (bitsToInt t) (evalPacket <$> ps)

main :: IO ()
main = do
  binaryInput <- fromMaybe [] <$> parseFromFile parseHexAsBinString "./src/day16.txt"
  print binaryInput
  let packet = fromResult (Literal mempty mempty mempty) $ parseString parsePacket mempty binaryInput
  print $ sumVersion packet
  print $ evalPacket packet
