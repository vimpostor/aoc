main = do
    contents <- readFile "input.txt"
    let l = lines contents
    print $ numtrees l 3 1 0

    let list = [(1,1),(3,1),(5,1),(7,1),(1,2)]
    print $ product $ map (\(r,d) -> numtrees l r d 0) list

numtrees :: [String] -> Int -> Int -> Int -> Int
numtrees (a:as) r d x = let istree = (a!!x) == '#'
                    in fromEnum istree + numtrees (drop (d-1) as) r d ((x+r) `mod` length(a))
numtrees [] _ _ _ = 0
