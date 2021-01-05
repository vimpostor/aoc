import Data.List

parse :: String -> (Int, Int)
parse [] = (0, 0)
parse xs = let (a,b) = parse $ drop (2 - fromEnum (elem (head xs) "ew")) xs
               (x,y) = case (take 2 xs) of
                 'e':_ -> (2, 0)
                 "se" -> (1, -1)
                 "sw" -> (-1, -1)
                 'w':_ -> (-2, 0)
                 "nw" -> (-1, 1)
                 "ne" -> (1, 1)
           in (x+a, b+y)

xor :: [(Int, Int)] -> [(Int, Int)]
xor (x:xs) = let ys = xor xs
             in case (elem x ys) of
               True -> delete x ys
               False -> x:ys
xor [] = []

neighbors :: (Int, Int) -> [(Int, Int)]
neighbors (a, b) = [(a+2,b), (a-2,b)] ++ [(a+x,b+y) | x <- [-1,1], y <- [-1,1]]

outneighbors :: [(Int, Int)] -> [(Int, Int)]
outneighbors xs = foldl union [] (map neighbors xs) \\ xs

black :: (Int, Int) -> [(Int, Int)] -> Int
black a xs = length $ intersect (neighbors a) xs

step :: [(Int, Int)] -> [(Int, Int)]
step xs = union (filter (\a -> elem (black a xs) [1,2]) xs) (filter (\a -> black a xs == 2) (outneighbors xs))


main = do
    contents <- readFile "input.txt"
    let l = lines contents
    let h = map parse l
    let x = xor h
    print $ length x

    let g = iterate step x
    print $ length $ g!!100
