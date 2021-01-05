import Data.List

fastpow :: Int -> Int -> Int -> Int
fastpow _ 0 _ = 1
fastpow a n p = (fastpow a (n-1) p * a) `mod` p

fastlog :: Int -> Int -> Int -> Int -> Int
fastlog x a n p | n == x = 0
                | otherwise = 1 + fastlog x a ((n * a) `mod` p) p

main = do
    contents <- readFile "input.txt"
    let l = lines contents
    let base = 7
    let card = read $ head l
    let door = read $ last l
    let mod = 20201227
    let privdoor = fastlog door base 1 mod
    let key = fastpow card privdoor mod
    print key
