import Data.Char
import Data.List

replacement :: String -> (String,[(Int, String)])
replacement x | isInfixOf "contain no other bags." x = (getname x, [])
replacement x = (getname x, map (getamount . getname) (split (dropWhile (not . isDigit) (droplastn 1 x))))

getname :: String -> String
getname x | isPrefixOf " bag" x = ""
getname (x:xs) = (x:getname xs)
getname [] = ""

split :: String -> [String]
split x = map san (groupBy (\a b -> b /= ',') x)

san :: String -> String
san (',':' ':xs) = xs
san xs = xs

droplastn :: Int -> String -> String
droplastn n x = reverse $ drop n $ reverse x

getamount :: String -> (Int, String)
getamount (x:' ':xs) = (read [x], xs)

dropamount :: String -> String
dropamount (x:xs) | isDigit x || x == ' ' = dropamount xs
                  | otherwise = (x:xs)

containsgold :: [(String,[(Int, String)])] -> String -> Bool
containsgold r b = let a = head [(x,y) | (x,y) <- r, x == b]
                       c = snd a
                       s = [n | (x,n) <- c]
                   in elem "shiny gold" s || any (containsgold r) s

getgold :: [(String,[(Int, String)])] -> String -> Int
getgold r b = let a = head [(x,y) | (x,y) <- r, x == b]
                  c = snd a
              in 1 + (sum $ map (\(n,m) -> n * getgold r m) c)

main = do
    contents <- readFile "input.txt"
    let b = lines contents
    let r = map replacement b
    let names = [fst x | x <- r]
    print $ sum $ map (fromEnum . containsgold r) names
    print $ getgold r "shiny gold" - 1
