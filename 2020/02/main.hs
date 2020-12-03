main = do
    contents <- readFile "input.txt"
    print(length (filter (validpw) (lines contents)))
    print(length (filter (validpwnew) (lines contents)))

count :: Char -> String -> Int
count x b = length (filter (==x) b)

validpw :: String -> Bool
validpw line = let (min,b) = break ('-'==) line
                   (max,d) = break (' '==) (drop 1 b)
                   char = head (drop 1 d)
                   pw = reverse (fst (break (' '==) (reverse line)))
                   occ = count char pw
               in occ >= read min && occ <= read max

validpwnew :: String -> Bool
validpwnew line = let (a,b) = break ('-'==) line
                      (c,d) = break (' '==) (drop 1 b)
                      char = head (drop 1 d)
                      pw = reverse (fst (break (' '==) (reverse line)))
                      n = length pw
                      min = read a - 1
                      max = read c - 1
               in ((min < n) && (pw!!min == char)) /= ((max < n) && (pw!!max == char))
