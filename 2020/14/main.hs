import Data.List
import Data.Char
import Data.Map (Map,insert,empty,toList,mapKeys,fromList)
import Data.Bits

data Ins = M (Int,Int,Int) | S Int Int

tomask :: String -> (Int,Int,Int)
tomask x = let r = reverse x
           in (todec r '0', todec r '1', todec r 'X')

todec :: String -> Char -> Int
todec (x:xs) a = (fromEnum (x == a)) + 2 * todec xs a
todec [] _ = 0

parse :: String -> Ins
parse x = let s = take 4 x
              n = drop 2 $ last $ groupBy (\a b -> b /= '=') x
          in case s of
            "mask" -> M (tomask n)
            _ -> S (read $ takeWhile isDigit $ drop 4 x) (read n)

maskset :: Int -> (Int,Int) -> Int
maskset x (a,b) = (.|.) ((.&.) x (complement a)) b

comp :: [Ins] -> (Int,Int) -> Map Int Int -> ([Ins], (Int,Int), Map Int Int)
comp (x:xs) f m = case x of
                    M (a,b,c) -> comp xs (a,b) m
                    S a b -> comp xs f $ Data.Map.insert a (maskset b f) m
comp [] f m = ([], f, m)

equi :: Int -> Int -> (Int,Int) -> Bool
equi a f (x,y) = let b = (.|.) f y
                 in ((.|.) x b) == ((.|.) a b)

fix :: Int -> Int -> (Int,Int) -> (Int,Int)
fix a f (x,y) | equi a f (x,y) = ((.|.) x ((.&.) (complement a) ((.&.) (complement f) y)), (.&.) y (complement ((.&.) (complement f) y)))
              | otherwise      = (x,y)

sanitize :: Map (Int, Int) Int -> Int -> Int -> Map (Int, Int) Int
sanitize m a f = mapKeys (fix a f) m

binsubset :: Int -> Int -> Bool
binsubset 0 _ = True
binsubset x y = (not (testBit x 0) || testBit y 0) && binsubset (shiftR x 1) (shiftR y 1)

san :: Int -> Int -> Map (Int, Int) Int -> Map (Int, Int) Int
san a f x = fromList $ filter (\((b,c), _) -> not (equi a f (b,c)) || not (binsubset c f)) $ toList x

floatmap :: Int -> Int -> (Int,Int) -> Map (Int, Int) Int -> Map (Int, Int) Int
floatmap a b (o,f) m = let an = maskset a (f,o)
                       in Data.Map.insert (an, f) b $ san an f $ sanitize m an f

floatcomp :: [Ins] -> (Int,Int) -> Map (Int, Int) Int -> ([Ins], (Int,Int), Map (Int, Int) Int)
floatcomp (x:xs) f m = case x of
                         M (a,b,c) -> floatcomp xs (b,c) m
                         S a b -> floatcomp xs f $ floatmap a b f m
floatcomp [] f m = ([], f, m)

memsum :: Map Int Int -> Int
memsum x = foldl (\a (_,d) -> a + d) 0 $ toList x

mapsum :: Map (Int, Int) Int -> Int
mapsum x = foldl (\a ((_,d),e) -> a + e * 2 ^ popCount d) 0 $ toList x


main = do
    contents <- readFile "input.txt"
    let l = map parse (lines contents)
    let r = comp l (0,0) empty
    let (_,_,m) = r
    print $ memsum m

    let s = floatcomp l (0,0) empty
    let (_,_,n) = s
    print $ mapsum n
