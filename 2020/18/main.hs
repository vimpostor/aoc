import Data.List
import Data.Char

strip :: String -> String
strip (' ':xs) = strip xs
strip xs | isSuffixOf " " xs = reverse $ strip $ reverse xs
         | otherwise = xs

brackets :: String -> Bool
brackets x = head x == '(' && last x == ')'

closebracket :: String -> String
closebracket (')':_) = ")"
closebracket ('(':xs) = let a = closebracket xs in
                        ('(':(a ++ closebracket (drop (length a) xs)))
closebracket (x:xs) = (x:closebracket xs)
closebracket [] = []

closed :: String -> String
closed x = '(':(closebracket $ drop 1 x)

bracketmatch :: String -> (String, Char, String)
bracketmatch x = let a = (head x):(closebracket $ drop 1 x)
                 in (a, (drop (length a) x)!!1, drop (length a + 3) x)

applyop :: (String, Char, String) -> Int
applyop (a,o,b) = case o of
                    '+' -> parse a + parse b
                    '*' -> parse a * parse b

parse :: String -> Int
parse x | head x == '(' = case () of
                            () | x == closed x -> parse $ reverse $ drop 1 $ reverse $ drop 1 x
                               | otherwise -> applyop $ bracketmatch x
        | not $ elem ' ' x = read x

escapenums :: String -> String
escapenums x | null $ filter isDigit x = x
escapenums x = let a = takeWhile (not . isDigit) x
                   b = takeWhile isDigit $ drop (length a) x
                   c = drop (length a + length b) x
               in a ++ "(" ++ b ++ ")" ++ escapenums c

mirror :: String -> String
mirror x = reverse $ map (\a -> if a == '(' then ')' else if a == ')' then '(' else a) x

leftassoc :: String -> Int -> String
leftassoc x p | length x <= p = x
leftassoc x p = let a = take p x ++ (reverse $ drop 1 $ reverse $ takeWhile (not . flip elem "+*") $ drop p x)
                    c = last a
                in case c of
                  ')' -> let b = mirror (closebracket $ mirror a)
                         in leftassoc (take (length a - length b) a ++ "(" ++ b ++ ")" ++ drop (length a) x) $ length a + 5
                  _ | length x == length a + 1 -> x

abm :: String -> Int -> String
abm x p | take p x ++ (takeWhile ('+'/=) $ drop p x) == x = x
abm x p = let a = take p x ++ (reverse $ drop 1 $ reverse $ takeWhile ('+'/=) $ drop p x)
              c = last a
          in case c of
            ')' -> let b = mirror (closebracket $ drop 1 $ mirror a) ++ ")"
                       d = drop (length a + 3) x
                       e = '(':(closebracket $ drop 1 d)
                   in abm (take (length a - length b) a ++ "((" ++ b ++ ") + (" ++ e ++ "))" ++ drop (length e) d) $ length a + 11
            _ | length x == length a + 1 -> x



main = do
    contents <- readFile "input.txt"
    let l = map escapenums $ lines contents
    print $ sum $ map (parse . flip leftassoc 0) l
    print $ sum $ map (\a -> parse $ leftassoc (abm a 0) 0) l
