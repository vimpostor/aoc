import Data.List
import Data.Char

passports :: [String] -> [String]
passports (x:"":xs) = x : passports xs
passports (x:y:xs) = passports $ (x ++ (' ':y)) : xs
passports x = x

validpp :: String -> Bool
validpp p = let l = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
            in all (\a -> isInfixOf a p) l

validnew :: String -> Bool
validnew "" = True
validnew p  = let (a,b) = break (':'==) p
                  (c,d) = break (' '==) b
              in (validparam a $ drop 1 c) && (validnew $ drop 1 d)

validparam :: String -> String -> Bool
validparam "byr" p = read p >= 1920 && read p <= 2002
validparam "iyr" p = read p >= 2010 && read p <= 2020
validparam "eyr" p = read p >= 2020 && read p <= 2030
validparam "hgt" a
                   | drop (length a - 2) a == "cm" = let b = read $ init $ init a
                                                   in b >= 150 && b <= 193
                   | drop (length a - 2) a == "in" = let b = read $ init $ init a
                                                   in b >= 59 && b <= 76
validparam "hcl" ('#':h) = length h == 6 && all isHexDigit h
validparam "ecl" p = let l = ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]
                     in elem p l
validparam "pid" p = length p == 9 && all isDigit p
validparam "cid" _ = True
validparam _ _ = False

main = do
    contents <- readFile "input.txt"
    let p = passports $ lines contents
    let l = filter validpp p
    print $ length l
    print $ length $ filter validnew l
