import Data.List

row :: [String] -> Int -> String
row l y = foldl (++) [] $ reverse $ drop (length l - y - 1) $ reverse $ drop y l

cols :: String -> Int -> Int -> String
cols l x r = reverse $ drop (length l - x - 1 - r) $ reverse $ drop (x-r) l

count :: String -> Int
count x = length $ filter ('#'==) x

neighbors :: [String] -> Int -> Int -> Int
neighbors l x y = let c = map (\z -> cols z x 1) [row l z | z <- [y-1..y+1]]
                  in sum (map count c) - (fromEnum $ (l!!y)!!x == '#')

look :: [String] -> Int -> Int -> (Int,Int) -> Int
look l x y (a,b) = let c = x + a
                       d = y + b
                       ch = cols (row l d) c 0
                   in case ch of
                     []      -> 0
                     ('.':_) -> look l c d (a,b)
                     ('#':_) -> 1
                     ('L':_) -> 0

neighborsnew :: [String] -> Int -> Int -> Int
neighborsnew l x y = let dirs = [(a,b) | a <- [-1..1], b <- [-1..1]] \\ [(0,0)]
                     in sum $ map (\(a,b) -> look l x y (a,b)) dirs

trans :: [String] -> Int -> Int -> Char
trans l x y = let n = neighbors l x y
                  c = (l!!y)!!x
              in case c of
                '.' -> '.'
                '#' | n < 4 -> '#'
                    | otherwise -> 'L'
                'L' | n == 0 -> '#'
                    | otherwise -> 'L'

transnew :: [String] -> Int -> Int -> Char
transnew l x y = let n = neighborsnew l x y
                     c = (l!!y)!!x
                 in case c of
                   '.' -> '.'
                   '#' | n < 5 -> '#'
                       | otherwise -> 'L'
                   'L' | n == 0 -> '#'
                       | otherwise -> 'L'

iter :: [String] -> ([String] -> Int -> Int -> Char) -> [String]
iter l t = let xs = [0..length (head l) - 1]
               ys = [0..length l - 1]
               c = [[(x,y) | x <- xs] | y <- ys]
           in [map (\(x,y) -> t l x y) z | z <- c]

numocc :: [String] -> Int
numocc l = sum $ map (\x -> fromEnum (x == '#')) (concat l)

fixpoint :: [String] -> ([String] -> Int -> Int -> Char) -> [String]
fixpoint l t = let n = iter l t
             in case () of
               () | n == l -> l
               () | otherwise -> fixpoint n t

main = do
    contents <- readFile "input.txt"
    let l = lines contents
    print $ numocc $ fixpoint l trans
    print $ numocc $ fixpoint l transnew
