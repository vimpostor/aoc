import Data.List
import Data.Maybe

--  0000
-- 1    2
-- 1    2
--  3333
-- 4    5
-- 4    5
--  6666

-- (d,c,r): If there is a digit in ruleset rs, with exactly c common segments, then the correct number is r. If none matches, use f as fallback
match :: String -> [(String, Int)] -> ([(Int, Int, Int)], Int) -> Int
match x rs ((d,c,r):bs, f) = case (c == (length $ intersect (fst $ fromJust $ find ((== d) . snd) rs) x)) of
                               True -> r
                               False -> match x rs (bs, f)
match _ _ ([], f) = f

get :: [String] -> [(String, Int)] -> [(String, Int)]
get xs [] = get (concat $ [filter ((== k) . length) xs | k <- [5,6]]) [(fromJust $ find ((== b) . length) xs, a) | (a,b) <- [(1,2), (4,4), (7,3), (8,7)]]
get (x:xs) rs = let b = case (length x) of
                          5 -> ([(1,2,3),(4,3,5)], 2)
                          6 -> ([(1,1,6),(4,4,9)], 0)
                        in get xs ((x, match x rs b):rs)
get _ rs = rs

value :: [String] -> [(String, Int)] -> Int
value (x:xs) rs = (snd $ fromJust $ find (\a -> sort x == (sort $ fst $ a)) rs ) + 10 * (value xs rs)
value _ _ = 0

main = do
    contents <- readFile "input.txt"
    let l = lines contents
    -- part 1
    print $ length $ filter ((`elem` [2,3,4,7]) . length) $ concat $ map (words . (drop 2) . dropWhile (/= '|')) l
    -- part 2
    print $ sum $ map (\s -> value (reverse $ words $ drop 2 $ dropWhile (/= '|') s) $ get (words $ takeWhile (/= '|') s) []) l
