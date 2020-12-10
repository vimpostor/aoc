import Data.List

adapters :: [String] -> [Int]
adapters x = let ext = map read x
             in (0:(sort (3 + maximum ext:ext)))

diff :: [Int] -> [Int]
diff x = zipWith (-) (drop 1 x) x

count :: [Int] -> Int -> Int
count x a = length $ filter (a==) x

build :: [Int] -> [(Int, Int)]
build (x:xs) = (x,1):[(a,0) | a <- xs]

comb :: [(Int,Int)] -> [(Int,Int)]
comb ((a,b):xs) = let n = [(c,d) | (c,d) <- xs, c - a <= 3]
                  in ((a,b): comb([(c,d + b) | (c,d) <- n] ++ (xs \\ n)))
comb _ = []

main = do
    contents <- readFile "input.txt"
    let a = adapters $ lines contents
    let d = diff a
    print $ (count d 1) * (count d 3)
    print $ snd $ last $ comb $ build a
