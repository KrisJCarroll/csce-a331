import System.IO

main = do
    putStr "Type some text: "
    line <- getLine
    putStrLn ""
    putStrLn $ "Length: " ++ (show (length line))
    putStrLn ""
    putStr "Here is your line, backwards: "
    putStrLn $ reverse line
    -- $ means the entire rest of the line is in ()

myGetLine = do
    c <- getChar
    if c == '\n' 
        then return ""
        else do
            rest <- myGetLine
            return (c:rest)

squareEm = do
    putStr "Type a number (0 to quit): "
    line <- getLine
    let n = read line
    if n == 0
        then return () -- must have an IO action here to keep types correct
        else do
            putStrLn ""
            putStr "The square of your number is: "
            putStrLn $ show $ n*n
            putStrLn ""
            squareEm


