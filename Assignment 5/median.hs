-- median.hs
-- Author: Kristopher Carroll
-- Updated: April 7, 2019
-- CSCE A331 - Programming Language Concepts
-- Assignment 5 Exercise C
-- Allows user to input a list of numbers and calculates the median of that list.

import Data.List

-- get_median
-- Takes a list of Doubles and returns the median value
-- List must already be sorted
-- Empty lists will return Nothing for error handling
get_median :: [Double] -> Maybe Double 
get_median xs
    | null xs = Nothing
    | otherwise = Just $ sort xs !! med_index where
        med_index = length xs `div` 2    

-- is_double
-- Adapted from https://stackoverflow.com/a/30029229
-- Checks a String to see if it is a valid numeric type (Double)
is_double :: String -> Bool
is_double xs = 
    case (reads xs) :: [(Double, String)] of
        [(_, "")] -> True
        _         -> False

-- line_parse
-- Checks input String to determine if empty, is the return character ('\n'), or a Double
line_parse :: String -> Maybe Double
line_parse xs
    | null xs           = Nothing
    | xs !! 0 == '\n'   = Nothing
    | otherwise         = Just $ read xs :: Maybe Double

-- get_numbers
-- Handles loop for allowing user to input list of numbers, 1 per line
-- Will do error checking for non-numeric types
get_numbers :: [Double] -> IO [Double]
get_numbers curr_list = do
    putStr "Enter numbers one per line (empty line to end): "
    line <- getLine
    if line_parse line == Nothing -- Checking for return character ('\n')
        then -- End of list, return the list in current form
            return curr_list
        else -- List continues
            if is_double line -- Check for valid numeric type
                then do -- Found valid numeric type
                    let x = read line :: Double
                    get_numbers (x:curr_list) -- Recursion with new value added onto list
                else do -- Invalid numeric type
                    putStrLn "\t\tError: Non-numeric value input."
                    get_numbers curr_list


-- main
-- Handles loop for entering into the median calculation program
-- Allows user to compute further lists at the end if they wish
main = do
    putStrLn "This simple Haskell program will compute the median value of"
    putStrLn "a list of input numbers."
    putStrLn ""

    num_list <- get_numbers [] -- Getting the list of numbers with error checking
    let sort_list = sort num_list -- Sorting the list for median evaluation
    putStrLn ""

    putStrLn $ "Your list, sorted: " ++ show sort_list -- Outputting sorted list
    case get_median sort_list of -- adapted from https://stackoverflow.com/a/8905287
        Just n -> putStrLn $ "Median: " ++ show n -- Got an actual number
        Nothing -> putStrLn "Your list was empty, no median!" -- List was empty, no median
    putStrLn ""

    -- Asking user if they'd like to compute more
    putStr "Would you like to compute another median? [y/n]: "
    line <- getLine
    if line !! 0 == 'y' || line !! 0 == 'Y'
        then do
            putStrLn ""
            main -- start main over
        else do
            putStrLn "Goodbye." 
            return () -- end
    