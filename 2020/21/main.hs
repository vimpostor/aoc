import Data.List
import Data.Maybe
import Data.Function (on)

split :: String -> [String]
split xs = filter (not . null) $ map (filter (/=' ') ) $ groupBy (\a b -> b /= ' ') xs

parse :: String -> ([String],[String])
parse xs = (split $ takeWhile (/= '(') xs, split $ filter (not . flip elem ",)") $ drop 10 $ dropWhile (/='(') xs)

uniq :: [String] -> [String]
uniq (x:xs) = let r = uniq xs
              in case (elem x r) of
                True -> r
                False -> x:r
uniq [] = []

look :: String -> [String] -> Int
look s xs = fromJust $ elemIndex s xs

parserules :: [String] -> ([([Int],[Int])], ([String], [String]))
parserules ls = let r = map parse ls
                    a = foldl (\i (xs,_) -> union i xs) [] r
                    b = foldl (\i (_,xs) -> union i xs) [] r
                in (map (\(x,y) -> (map (flip look a) x, map (flip look b) y)) r, (a, b))

possible :: [([Int],[Int])] -> Int -> Int -> [(Int,[Int])]
possible xs j h = [(i,foldl intersect [0..j] $ map fst $ filter (\(_,b) -> elem i b) xs) | i <- [0..h-1]]

occ :: [([Int],[Int])] -> [Int] -> Int
occ rs (x:xs) = length (filter (\(a,_) -> elem x a) rs) + occ rs xs
occ _ [] = 0

mapping :: [(Int,[Int])] -> [(Int,Int)]
mapping [] = []
mapping rs = let n = head $ filter (\(_,x) -> length x == 1) rs
                 a = fst n
                 i = head $ snd n
             in (i,a):(mapping $ filter (\(_,x) -> not $ null x) $ map (\(x,y) -> (x,delete i y)) rs)

sortallergen :: [(Int,Int)] -> [String] -> [String] -> String
sortallergen rs a b = drop 1 $ foldl (\i s -> i ++ ',':s) [] $ map (\(x,_) -> a!!x) $ sortBy (compare `on` snd) $ map (\(x,y) -> (x,b!!y)) rs

main = do
    contents <- readFile "input.txt"
    let l = parserules $ lines $ contents
    let r = fst l
    let a = fst $ snd l
    let b = snd $ snd l
    let p = possible r (length a) (length b)
    let safe = [0..length a - 1] \\ foldl (\i (_,x) -> union i x) [] p
    print $ occ r safe
    print $ sortallergen (mapping p) a b
