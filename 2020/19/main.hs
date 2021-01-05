import Data.List
import Data.Function (on)

data Rule = S [Int] | O [Int] [Int] | C Char

parsenums :: String -> [Int]
parsenums s = map (read . filter (' '/=)) $ filter (" "/=) $ groupBy (\a b -> b /= ' ') s

parserule :: String -> Rule
parserule s = let a = drop 1 $ dropWhile (' '/=) s
              in case () of
                () | elem '"' a -> C ((dropWhile ('"'/=) a)!!1)
                   | elem '|' a -> O (parsenums $ takeWhile ('|'/=) a) (parsenums $ drop 2 $ dropWhile ('|'/=) a)
                   | otherwise -> S (parsenums a)

parse :: [String] -> [Rule]
parse xs = map snd $ sortBy (compare `on` fst) $ map (\s -> (read $ takeWhile (':'/=) s :: Int,parserule s)) $ takeWhile (""/=) xs

parsemsgs :: [String] -> [String]
parsemsgs xs = drop 1 $ dropWhile (""/=) xs

match :: [Rule] -> [Rule] -> String -> Bool
match _ (r:_) [] = False
match _ [] s = null s
match z (r:rs) s = case r of
                     S a -> match z ((map (z!!) a) ++ rs) s
                     O a b -> any (\x -> match z (x:rs) s) [S a, S b]
                     C c -> head s == c && (match z rs $ drop 1 s)

main = do
    contents <- readFile "input.txt"
    let l = lines contents
    let r = parse l
    let m = parsemsgs l
    print $ length $ filter (match r (take 1 r)) m

    let s = (take 8 r) ++ [O [42] [42,8]] ++ (take 2 $ drop 9 r) ++ [O [42,31] [42,11,31]] ++ (drop 12 r)
    print $ length $ filter (match s (take 1 s)) m
