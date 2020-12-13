import Data.List

parse :: String -> [Int]
parse x = map (\as -> toint [a | a <- as, a /= ',']) (groupBy (\a b -> b /= ',') x)

toint :: String -> Int
toint ('x':[]) = 0
toint x = read x

totuples :: [Int] -> [(Int, Int)]
totuples x = filter (\(a,b) -> b /= 0) (zip [0..length x] x)

busses :: [Int] -> [Int]
busses x = filter (0/=) x

wait :: Int -> Int -> Int
wait a b = b - (a `mod` b)

bestwait :: Int -> [Int] -> (Int,Int)
bestwait a b = head $ sort [(wait a x, x) | x <- b]

san :: Int -> Int -> (Int,Int) -> Int
san n j (o,m) = case () of
                  () | (n + o) `mod` m == 0 -> n
                  () | otherwise -> san (n + j) j (o,m)

fin :: Int -> Int -> [(Int,Int)] -> Int
fin n j (x:xs) = fin (san n j x) (j * snd x) xs
fin n _ [] = n


main = do
    contents <- readFile "input.txt"
    let l = lines contents
    let a = read $ head $ l :: Int
    let p = parse $ last $ l
    let b = busses p
    let w = map (wait a) b
    let r = bestwait a b
    print $ fst r * snd r

    let t = totuples $ p
    print $ fin 0 1 t
