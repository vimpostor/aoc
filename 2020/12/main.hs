data Dir = N Int | S Int | E Int | W Int | L Int | R Int | F Int
data Loc = P (Int,Int) Int

parse :: String -> Dir
parse s = let x = read $ drop 1 s
              c = head s
          in case c of
            'N' -> N x
            'S' -> S x
            'E' -> E x
            'W' -> W x
            'L' -> L x
            'R' -> R x
            'F' -> F x

tomov :: Int -> Int
tomov x = round $ sin $ fromIntegral x / 180 * pi

forward :: Loc -> Int -> Loc
forward (P (x,y) d) m = P (x + m * tomov d,y + m * tomov (d + 90)) d

move :: Loc -> Dir -> Loc
move (P (x,y) d) m = case m of
                       N a -> P (x,y+a) d
                       S a -> P (x,y-a) d
                       E a -> P (x+a,y) d
                       W a -> P (x-a,y) d
                       L a -> P (x,y) (d-a)
                       R a -> P (x,y) (d+a)
                       F a -> forward (P (x,y) d) a

travel :: Loc -> [Dir] -> Loc
travel p (x:xs) = travel (move p x) xs
travel p _ = p

travelw :: ((Int,Int),(Int,Int)) -> [Dir] -> ((Int,Int),(Int,Int))
travelw (s,w) (x:xs) = travelw (movew s w x) xs
travelw p _ = p

manhattan :: (Int,Int) -> (Int,Int) -> Int
manhattan (a,b) (c,d) = abs (c-a) + abs (d-b)

movew :: (Int,Int) -> (Int,Int) -> Dir -> ((Int,Int),(Int,Int))
movew (a,b) (c,d) m = let s = (a,b)
                          w = (c,d)
                      in case m of
                        N x -> (s,(c,d+x))
                        S x -> (s,(c,d-x))
                        E x -> (s,(c+x,d))
                        W x -> (s,(c-x,d))
                        L x -> movew s w (R (-x))
                        R x -> (s,(tomov x * d + tomov (x+90) * c, tomov (x+90) * d - tomov x * c))
                        F x -> ((a+x*c,b+x*d),w)


main = do
    contents <- readFile "input.txt"
    let m = map parse $ lines contents
    let n = (0,0)
    let a = P n 90
    let b = travel a m
    let r = case b of
              P x _ -> x
    print $ manhattan n r

    let c = (n,(10,1))
    let d = travelw c m
    print $ manhattan (fst c) (fst d)
