import Data.List

data IS = Nop Int | Acc Int | Jmp Int

parse :: String -> IS
parse x = let n = read $ drop (1 + fromEnum (elem '+' x)) $ dropWhile (' '/=) x in
          case () of
            () | isPrefixOf "nop" x -> Nop n
               | isPrefixOf "acc" x -> Acc n
               | isPrefixOf "jmp" x -> Jmp n

run :: [IS] -> Int -> Int -> [Int] -> (Bool, Int)
run p c a l | c == length p = (True, a)
            | elem c l = (False, a)
            | otherwise = let m = (c:l) in
                          case p!!c of
                            Nop _ -> run p (c+1) a m
                            Acc x -> run p (c+1) (a+x) m
                            Jmp x -> run p (c+x) a m

swapnth :: [IS] -> Int -> [IS]
swapnth p n = let i = p!!n
                  new = case i of
                          Nop x -> Jmp x
                          Acc x -> Acc x
                          Jmp x -> Nop x in
                  (\(a,(b:bs)) -> a ++ (new:bs)) (splitAt n p)

fix :: [IS] -> Int -> Int
fix p n = let res = run (swapnth p n) 0 0 [] in
          case res of
            (True, a) -> a
            _ -> fix p (n+1)


main = do
    contents <- readFile "input.txt"
    let l = lines contents
    let p = map parse l
    print $ run p 0 0 []
    print $ fix p 0
