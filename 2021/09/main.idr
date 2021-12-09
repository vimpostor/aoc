import Data.String

row : Int -> (List Char) -> Int -> List ((Int,Int),Int)
row y (d::ds) x = ((x,y),(fromMaybe 0 $ parseInteger $ pack [d]))::(row y ds (x+1))
row _ [] _ = []

grid : (Int,String) -> List ((Int,Int),Int)
grid (y,s) = row y (unpack s) 0

neigh : List ((Int,Int),Int) -> ((Int,Int),Int) -> List ((Int,Int),Int)
neigh gs ((x,y),_) = filter (\((a,b),_) => (abs(a-x)==1 || abs(b-y)==1) && (a==x || b==y)) gs

localmin : List ((Int,Int),Int) -> List ((Int,Int),Int) -> List Int
localmin (((x,y),h)::xs) gs = case (h < (fromMaybe 0 $ head' $ sort $ map snd $ neigh gs ((x,y),h))) of
                                True => h::(localmin xs gs)
                                False => localmin xs gs
localmin [] _ = []

basin : List ((Int,Int),Int) -> List ((Int,Int),Int) -> Int -> List Int
basin (g::gs) [] c     = c::basin gs [g] 0
basin gs ((_,9)::xs) c = basin gs xs c
basin gs ((p,h)::xs) c = let n = neigh gs (p,h)
                         in basin (gs\\n) (xs++n) (c+1)
basin [] [] c = [c]

main : IO ()
main = do
  (Right content) <- readFile "input.txt"
  let l = lines content
  let g = concat $ map grid $ zip (map toIntNat [0..length l]) l
  -- part 1
  printLn $ sum $ map (+1) $ localmin g g
  -- part 2
  printLn $ product $ take 3 $ reverse $ sort $ basin g [] 0
