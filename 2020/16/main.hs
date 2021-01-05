import Data.List
import Data.Char

tovalid :: String -> [(Int,Int)]
tovalid x = let xs = groupBy (\a b -> b /= 'o') x
                grabfst = read . takeWhile isDigit . dropWhile (not . isDigit)
                grabsnd = read . takeWhile isDigit . drop 1 . dropWhile ('-'/=)
            in map (\s -> (grabfst s, grabsnd s)) xs

parsevalid :: [String] -> [[(Int,Int)]]
parsevalid xs = map (\s -> tovalid $ drop 2 $ dropWhile (':'/=) s) $ takeWhile (""/=) xs

parsenames :: [String] -> [String]
parsenames xs = map (takeWhile (':'/=)) $ takeWhile (""/=) xs

nearby :: [String] -> [[Int]]
nearby xs = map (\s -> map (read . dropWhile (','==)) $ groupBy (\a b -> b /= ',') s) $ drop 1 $ dropWhile ("nearby tickets:"/=) xs

isvalid :: Int -> [(Int,Int)] -> Bool
isvalid a xs = any (\(c,d) -> c <= a && a <= d) xs

satisfies :: Int -> [[(Int,Int)]] -> Bool
satisfies a xs = any (\b -> isvalid a b) xs

getinvalid :: [[(Int,Int)]] -> [[Int]] -> [Int]
getinvalid vs ns = filter (\a -> not $ satisfies a vs) (foldl (++) [] ns)

dropinvalid :: [[(Int,Int)]] -> [[Int]] -> [[Int]]
dropinvalid vs ns = filter (\xs -> all (\a -> satisfies a vs) xs) ns

me :: [String] -> [Int]
me xs = map (\a -> read $ dropWhile (','==) a) $ groupBy (\a b -> b /= ',') $ (dropWhile ("your ticket:"/=) xs)!!1

newrules :: [[(Int,Int)]] -> Int -> [[(Int,Int)]]
newrules xs i = [head $ drop i xs]

suitable :: [[(Int,Int)]] -> [Int] -> [Int]
suitable vs xs = map (\(a,_) -> a) $ filter (\(_,ys) -> all (\x -> isvalid x ys) xs) $ zip [0..length vs - 1] vs

fit :: [[(Int,Int)]] -> [[Int]] -> [[Int]]
fit vs ns = [suitable vs (map (\xs -> xs!!i) ns) | i <- [0..length (head ns) - 1]]

mappings :: [[Int]] -> [(Int,Int)]
mappings fs | null $ foldl (++) [] fs = []
mappings fs = let (i,n) = head $ filter (\(_,xs) -> length xs == 1) $ zip [0..length fs - 1] fs
                  m = head n
              in (i,m):(mappings $ map (delete m) fs)

toname :: [(Int,Int)] -> [String] -> [(String,Int)]
toname xs ys = map (\(i,s) -> (s, fst $ head $ filter (\(a,b) -> b == i) xs)) $ zip [0..length ys - 1] ys

main = do
    contents <- readFile "input.txt"
    let l = lines $ contents
    let v = parsevalid l
    let n = nearby l
    let i = getinvalid v n
    print $ sum i

    let c = dropinvalid v n
    let m = me $ l
    let f = mappings $ fit v c
    let names = parsenames l
    let ind = map snd $ filter (\(s,_) -> isPrefixOf "departure" s) $ toname f names
    print $ product $ map (m!!) ind
