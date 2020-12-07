groups :: [String] -> [String]
groups (x:"":xs) = x : groups xs
groups (x:y:xs) = groups $ (x ++ (' ':y)) : xs
groups x = x

uniqueimpl :: String -> String -> Int
uniqueimpl (' ':xs) l = uniqueimpl xs l
uniqueimpl (x:xs) l = fromEnum (not (elem x l)) + uniqueimpl xs (x:l)
uniqueimpl [] _ = 0

unique :: String -> Int
unique x = uniqueimpl x []

commonimpl :: [String] -> String -> Int
commonimpl (x:xs) c = commonimpl xs [a | a <- x, elem a c]
commonimpl [] c = length c

common :: String -> Int
common x = commonimpl (words x) (head $ words x)

main = do
    contents <- readFile "input.txt"
    let g = groups $ lines contents
    print $ sum $ map unique g
    print $ sum $ map common g
