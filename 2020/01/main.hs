main = do
        contents <- readFile "input.txt"
        print( head [ i*j | let n = map read . lines $ contents, i <- n, j <- n, i + j == 2020])
        print( head [ i*j*k | let n = map read . lines $ contents, i <- n, j <- n, k <- n, i + j + k == 2020])
