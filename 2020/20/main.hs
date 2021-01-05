import Data.List

parse :: [String] -> [(Int,[String])]
parse (x:xs) = (read $ take 4 $ drop 5 x, take 10 xs):(parse $ drop 11 xs)
parse _ = []

flipy :: [String] -> [String]
flipy xs = reverse xs

rotate :: [String] -> [String]
rotate xs = [foldl (\s c -> c:s) [] $ map (!!y) xs | y <- [0..length (head xs) - 1]]

possible :: [String] -> [[String]]
possible xs = let rot = take 4 $ iterate rotate xs
              in rot ++ map flipy rot

neighbors :: (Int,Int) -> [(Int,Int)]
neighbors (x,y) = [(x+i,y+j) | i <- [-1..1], j <- [-1..1], abs i /= abs j]

neighborsin :: (Int,Int) -> [((Int,Int), (Int,[String]))] -> [(Int,Int)]
neighborsin (x,y) xs = intersect (neighbors (x,y)) (map fst xs)

neighborsout :: (Int,Int) -> [((Int,Int), (Int,[String]))] -> [(Int,Int)]
neighborsout (x,y) xs = neighbors (x,y) \\ map fst xs

cmp :: [String] -> (Int,Int) -> String
cmp a (x,y) = let n = length a - 1
              in foldl (++) [] $ map (reverse . drop (n * (fromEnum $ x == -1)) . reverse . drop (n * (fromEnum $ x == 1))) $ reverse $ drop (n * (fromEnum $ y == 1)) $ reverse $ drop (n * (fromEnum $ y == -1)) a

matches :: [String] -> [String] -> (Int,Int) -> Bool
matches a b (x,y) = cmp a (x,y) == cmp b (-x,-y)

matchesrot :: [String] -> [String] -> (Int,Int) -> Maybe [String]
matchesrot a b x = case (filter (\c -> matches c b x) $ possible a) of
                     (y:ys) -> Just y
                     (_) -> Nothing

fits :: [((Int,Int), (Int,[String]))] -> (Int,Int) -> [String] -> Maybe [String]
fits xs (x,y) p = let l = [matchesrot p (snd $ snd $ head $ filter (\((s,t), _) -> s == a && t == b) xs) (a - x,b - y) | (a,b) <- neighborsin (x,y) xs]
                  in case () of
                  ()   | null l -> Nothing
                       | foldl (\i a -> if i == a then a else Nothing) (head l) l /= Nothing -> head l
                       | otherwise -> Nothing

fitsany :: [((Int,Int), (Int,[String]))] -> (Int,Int) -> [(Int,[String])] -> Maybe (Int,[String])
fitsany xs x (p:ps) = let a = fits xs x $ snd p
                      in case a of
                        Just s -> Just (fst p, s)
                        Nothing -> fitsany xs x ps
fitsany _ _ [] = Nothing

getvalue :: Maybe a -> a
getvalue x = case x of
               Just y -> y

puzzlerec :: [(Int,[String])] -> [((Int,Int), (Int,[String]))] -> [((Int,Int), (Int,[String]))]
puzzlerec [] xs = xs
puzzlerec ps (x:xs) = let l = filter (\a -> snd a /= Nothing) $ map (\a -> (a, fitsany (x:xs) a ps)) $ neighborsout (fst x) xs
                      in case l of
                        [] -> puzzlerec ps (xs ++ [x])
                        _ -> let h = head l
                                 a = fst h
                                 b = getvalue $ snd h
                             in puzzlerec (filter (\(n,_) -> n /= fst b) ps) ((a,b):x:xs)

puzzle :: [(Int,[String])] -> [((Int,Int), (Int,[String]))]
puzzle (p:ps) = sort $ puzzlerec ps [((0,0), p)]

corners :: [((Int,Int), (Int,[String]))] -> [((Int,Int), (Int,[String]))]
corners xs = let tl = head xs
                 br = last xs
                 (a,b) = fst tl
                 (c,d) = fst br
             in tl:br:(head $ filter (\((x,y),_) -> x == c && y == b) xs):(head $ filter (\((x,y),_) -> x == a && y == d) xs):[]

cut :: [String] -> [String]
cut xs = map (take 8 . drop 1) $ take 8 $ drop 1 xs

cutdown :: [((Int,Int), (Int,[String]))] -> [((Int,Int), (Int,[String]))]
cutdown xs = map (\(x, (n,s)) -> (x,(n,cut s))) xs

minimerge :: [[String]] -> [String]
minimerge xs = reverse [foldl (++) [] (map (!!y) xs) | y <- [0..length (head xs) - 1]]

merge :: [((Int,Int), (Int,[String]))] -> [String]
merge (x:xs) = let a = filter (\((_,y),_)-> y == snd (fst x)) (x:xs)
               in (minimerge (map (\(_,(_,s)) -> s) a)) ++ merge (xs \\ a)
merge [] = []

monster :: [String]
monster = "                  # ":"#    ##    ##    ###":" #  #  #  #  #  #   ":[]

roughl :: [String] -> Int
roughl xs = length $ filter ('#'==) $ foldl (++) [] xs

ispart :: [String] -> [String] -> Bool
ispart ms rs = (length ms == length rs) && (length (head ms) == length (head rs)) && (all (\(a,b) -> (b == '#' && a == '#') || a == ' ') $ zip (foldl (++) [] ms) (foldl (++) [] rs))

overlaps :: [String] -> Int -> Int
overlaps ws x = (roughl monster) * (fromEnum $ ispart monster $ map (take (length $ head monster) . drop x) (take (length monster) ws))

findnemo :: [String] -> Int -> Int
findnemo [] _ = 0
findnemo (y:ys) x | x == length y = findnemo ys 0
findnemo ys x = overlaps ys x + findnemo ys (x+1)


main = do
    contents <- readFile "input.txt"
    let p = parse $ lines contents
    let s = puzzle p
    print $ product $ map (\(_,(x,_)) -> x) $ corners s

    let c = merge $ cutdown $ s
    let r = roughl c
    print $ minimum $ map (\s -> r - findnemo s 0) $ possible c
