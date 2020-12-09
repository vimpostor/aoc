check :: [Int] -> Int -> Int -> Bool
check n p x = let l = drop (x - p) $ take x n
                  comb = [a + b | a <- l, b <- l, a /= b]
              in elem (n!!x) comb

find :: [Int] -> Int -> Int -> Int
find n p x | check n p x = find n p (x+1)
           | otherwise = n!!x

addsup :: [[Int]] -> Int -> (Bool, Int)
addsup (a:as) x | (sum a) == x = (True, minimum a + maximum a)
                | otherwise = addsup as x
addsup [] _ = (False, 0)

cont :: [Int] -> Int -> Int -> Int
cont n x fst = let c = [take l $ drop fst n | l <- [0..(length n - fst)]]
                   (a,b) = addsup c x
               in case a of
                 True -> b
                 False -> cont n x (fst+1)


main = do
    contents <- readFile "input.txt"
    let l = map (read :: String -> Int) (lines contents)
    let p = 25
    let invalid = find l p p
    print $ invalid
    print $ cont l invalid 0
