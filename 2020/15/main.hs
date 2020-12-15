import Data.List
import Data.Map (Map,insert,lookup,fromList,map)

parse :: String -> [Int]
parse x = Data.List.map (read . dropWhile (','==)) (groupBy (\a b -> b /= ',') x)

game :: Map Int Int -> Int -> Int -> Int
game ys y 0 = y
game ys y b = let n = Data.Map.lookup y ys
                  i = case n of
                        Just a -> a - b
                        Nothing -> 0
                  c = b - 1
              in game (Data.Map.insert y b ys) i c

play :: [Int] -> Int -> Int
play xs b = game (fromList $ zip (reverse $ drop 1 $ reverse xs) $ reverse [b - length xs..(b - 1)]) (last xs) (b - (length xs))

main = do
    contents <- readFile "input.txt"
    let c = parse $ contents
    let g = play c
    print $ g 2020
    print $ g 30000000
