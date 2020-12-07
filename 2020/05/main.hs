import Data.List

passid :: String -> Int
passid p = (row $ take 7 p) * 8 + col (drop 7 p)

row :: String -> Int
row x = todec ('B'==) x

col :: String -> Int
col x = todec ('R'==) x

todec :: (Char -> Bool) -> String -> Int
todec f x = binToDec $ reverse $ map f x

binToDec :: [Bool] -> Int
binToDec (x:xs) = fromEnum x + 2 * binToDec xs
binToDec [] = 0

main = do
    contents <- readFile "input.txt"
    let p = lines contents
    let pids = map passid p
    print $ maximum pids

    let s = sort pids
    let diff = zipWith (-) (drop 1 s) s
    print $ s!!(sum $ takeWhile (1==) diff) + 1
