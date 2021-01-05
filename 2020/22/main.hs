import Data.List

parse :: [String] -> ([Int], [Int])
parse xs = (map read $ takeWhile (not . null) $ drop 1 xs, map read $ drop 2 $ dropWhile (not . null) xs)

play :: ([Int], [Int]) -> ([Int], [Int])
play ([], ys) = ([], ys)
play (xs, []) = (xs, [])
play ((x:xs), (y:ys)) = case x > y of
                          True -> play (xs ++ x:[y],ys)
                          False -> play (xs,ys ++ y:[x])

score :: ([Int], [Int]) -> Int
score (a,b) = foldl (\i (x,y) -> i + x * y) 0 $ zip (reverse [1..length $ a ++ b]) $ a ++ b

combat :: ([Int], [Int]) -> [([Int], [Int])] -> ([Int], [Int])
combat ([], ys) _ = ([], ys)
combat (xs, []) _ = (xs, [])
combat x m | elem x m = (fst x, [])
combat ((x:xs), (y:ys)) m = let r = x <= length xs && y <= length ys
                                n = ((x:xs), (y:ys)):m
                                w = (r && null (snd (combat (take x xs, take y ys) n))) || (not r && x > y)
                            in case w of
                              True -> combat (xs ++ x:[y],ys) n
                              False -> combat (xs,ys ++ y:[x]) n

main = do
    contents <- readFile "input.txt"
    let l = parse $ lines contents
    print $ score $ play l
    print $ score $ combat l []
