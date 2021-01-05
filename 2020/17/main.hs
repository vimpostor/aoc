import Data.List
import Data.Char

neigh :: [Int] -> [[Int]]
neigh (x:xs) = [(x+o):r | o <- [-1..1], r <- neigh xs]
neigh x = [[]]

neighbors :: [Int] -> [[Int]]
neighbors xs = delete xs $ neigh xs

parse :: [String] -> [[Int]]
parse ss = foldl (++) [] $ map (\(x,xs) -> [x:[y] | y <- xs]) $ zip [0..length ss - 1] $ map (\s -> foldl (\x (y,_) -> x ++ [y]) [] $ filter (\(i,a) -> a == '#') $ zip [0..length s - 1] s) ss

expand :: Int -> [[Int]] -> [[Int]]
expand a b = let n = [i * 0 | i <- [1..a - length (head b)]]
             in map (++ n) b

bounds :: [[Int]] -> Int -> [[Int]]
bounds xs _ | null $ head xs = [[]]
bounds xs o = let ys = map head xs
              in [a:r | a <- [minimum ys - o..maximum ys + o], r <- bounds (map (drop 1) xs) o]

nneighbors :: [[Int]] -> [Int] -> Int
nneighbors xs v = length $ intersect xs $ neighbors v

activate :: [[Int]] -> [Int] -> Bool
activate xs v = let n = nneighbors xs v
                in case elem v xs of
                  True -> n == 2 || n == 3
                  False -> n == 3

step :: [[Int]] -> [[Int]]
step xs = [c | c <- bounds xs 1, activate xs c]

activecubes :: [[Int]] -> Int -> Int
activecubes xs n = length $ (iterate step xs)!!n

main = do
    contents <- readFile "input.txt"
    let l = parse $ lines contents
    let init = expand 3 l
    print $ activecubes init 6

    let newinit = expand 4 l
    print $ activecubes newinit 6
