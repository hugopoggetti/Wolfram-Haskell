{-
-- EPITECH PROJECT, 2022
-- My.hs
-- File description:
-- tt
-}

module Main (main) where
import System.Environment
import System.Time.Extra (sleep)
import System.Exit
import Text.Read (readMaybe)

getPattern :: Int -> (Bool, Bool, Bool) -> Bool
getPattern rule (left, center, right) = 
    let index = fromEnum left * 4 + fromEnum center * 2 + fromEnum right
    in (rule `div` (2 ^ index)) `mod` 2 == 1

strCurline :: [Bool] -> String
strCurline = concatMap (\x -> if x then "██" else "  ")

getNextLine :: Int -> [Bool] -> [Bool]
getNextLine rule xs =
    [ getPattern rule (left, center, right) 
    | (left, center, right) <- zip3 (False : xs) xs (tail xs ++ [False]) ]

display :: Int -> Int -> Int -> Int -> Int -> Int -> Int -> [Bool] -> IO()
display rule index_display index_start lines start cols move list 
    | index_start >= start && index_display < lines ||
        lines == -1 = putStrLn (strCurline (padAndShift cols move list)) >> sleep 0.5 >> 
            display rule (index_display + 1) (index_start + 1) 
                lines start cols move
                    (getNextLine rule ([False] ++ list ++ [False]))
    | index_start < start = display rule index_display
            (index_start + 1) lines start cols move 
                    (getNextLine rule ([False] ++ list ++ [False]))
    | otherwise = return()

run :: Int -> Int -> Int -> Int -> Int -> [Bool] -> IO ()
run rule rows cols start move list = display rule 0 0 rows start cols move list

sublist :: Int -> Int -> [a] -> [a]
sublist start size = take size . drop start

padAndShift :: Int -> Int -> [Bool] -> [Bool]
padAndShift cols move row =
    let
        len = length row
        left = (cols `div` 2) - (len `div` 2) + move
        right = cols - (left + len)
    in if len <= cols
        then replicate left False ++ row ++ replicate right False
        else sublist ((len `div` 2) - (cols `div` 2) - move) cols row

getRuleInput :: [String] -> Int
getRuleInput [] = 30
getRuleInput ("--rule":x:xs) = read x 
getRuleInput (x:xs) = getRuleInput xs

getlineInput :: [String] -> Int
getlineInput [] = -1
getlineInput ("--lines":x:xs) = read x 
getlineInput (x:xs) = getlineInput xs

getwindowInput :: [String] -> Int
getwindowInput [] = 80
getwindowInput ("--window":x:xs) = read x 
getwindowInput (x:xs) = getwindowInput xs

startInput :: [String] -> Int
startInput [] = 0
startInput ("--start":x:xs) = read x 
startInput (x:xs) = startInput xs

movInput :: [String] -> Int
movInput [] = 0
movInput ("--move":x:xs) = read x 
movInput (x:xs) = movInput xs

isValid :: [String] -> Bool
isValid = all validArg
  where
    input = ["--rule", "--lines", "--window", "--start", "--move"]
    validArg str = (str `elem` input) ||
        (readMaybe str :: Maybe Int) /= Nothing

checkValidRule :: Int -> Bool
checkValidRule rule 
    | rule < 0 || rule > 256 = False
    | otherwise = True

initLife :: [Bool]
initLife = [False, False, False, True, False, False, False]

main :: IO ()
main = do
    args <- getArgs
    if null args   || not (isValid args) ||
        not (checkValidRule (getRuleInput args))
    then putStrLn "invalid arguments" >> exitWith (ExitFailure 84)
    else 
        run (getRuleInput args) (getlineInput args)
                (getwindowInput args ) (startInput args)
                        (movInput args ) initLife
