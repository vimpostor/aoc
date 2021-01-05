import Data.List
import Data.Maybe
import Data.Function (on)
import Control.Monad.ST
import qualified Data.Vector.Unboxed as V
import Data.Vector.Unboxed ((!))
import qualified Data.Vector.Unboxed.Mutable as M

parse :: String -> [Int]
parse xs = map (\a -> read (a:[]) - 1) xs

fd :: Int -> [Int] -> Int -> Int
fd l xs n | not $ elem n xs = n
          | otherwise = fd l xs $ ((n - 1) `mod` l)

follow3 :: M.STVector s Int -> Int -> ST s [Int]
follow3 xs x = do
                 a <- M.read xs x
                 b <- M.read xs a
                 c <- M.read xs b
                 let r = [a,b,c]
                 return r

turn :: (M.STVector s Int, Int) -> ST s (M.STVector s Int, Int)
turn (xs,x) = let l = M.length xs
              in do
                e <- follow3 xs x
                let n = fd l e ((x-1) `mod` l)
                nx <- M.read xs (last e)
                nxs <- M.read xs n
                M.write xs x nx
                M.write xs n (head e)
                M.write xs (last e) nxs
                return (xs, nx)

tohr xs a = a:(tohr xs (xs!a))

human xs = take (V.length xs) $ tohr xs 0

fromhr :: [Int] -> Int -> [Int]
fromhr xs a = (xs!!((fromJust (elemIndex a xs) + 1) `mod` (length xs))):(fromhr xs (a+1))

machine xs = V.fromList $ take (length xs) $ fromhr xs 0

pr :: [Int] -> String
pr xs = foldl (\i s -> i ++ show s) [] $ map (+ 1) xs

sol :: [Int] -> [Int]
sol xs = drop 1 (dropWhile (/= 0) xs) ++ (takeWhile (/= 0) xs)

gen :: V.Vector Int -> Int -> Int -> Int -> Int
gen xs n l f = let a = xs!n
                   b = V.length xs
               in case (n < b) of
                 True -> if a == f then b else a
                 False -> if n+1 < l then n+1 else f

expand :: V.Vector Int -> Int -> Int -> V.Vector Int
expand xs n f = V.generate n (\a -> gen xs a n f)

iter :: (M.STVector s Int, Int) -> Int -> ST s (M.STVector s Int, Int)
iter xs 0 = pure xs
iter xs n = do
              s <- turn xs
              r <- iter s (n-1)
              return r

prep :: V.Vector Int -> Int -> Int -> [Int]
prep xs f n = sol $ human $ runST $ do
                v <- V.thaw $ xs
                s <- iter (v, f) n
                let r = fst s
                f <- V.freeze r
                return f

main = do
    contents <- readFile "input.txt"
    let p = parse contents
    let l = machine $ p
    let f = head p
    print $ pr $ prep l f 100

    let m = expand l (10^6) f
    print $ product $ take 2 $ map (+1) $ prep m f (10^7)
