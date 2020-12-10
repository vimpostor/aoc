import Data.List

adapters :: [String] -> [Int]
adapters x = let ext = map read x
             in (0:(sort (3 + maximum ext:ext)))

diff :: [Int] -> [Int]
diff x = zipWith (-) (drop 1 x) x

count :: [Int] -> Int -> Int
count x a = length $ filter (a==) x

comb :: [Int] -> Int
comb (x:y:z:xs) = let n = comb (y:z:xs)
                    in case () of
                      () | z - x <= 3 -> n + comb (x:z:xs)
                      () | otherwise -> n
comb _ = 1

main = do
    contents <- readFile "input.txt"
    let a = adapters $ lines contents
    let d = diff a
    print $ (count d 1) * (count d 3)
    print $ comb a
