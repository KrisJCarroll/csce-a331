isEmpty [] = True
isEmpty (x:xs) = False

listLength [] = 0
listLength (x:xs) = 1 + listLength xs
-- calling listLength [1..] will cause it to hang.

-- myMap to recreate map function
myMap f [] = []
myMap f (x:xs) = (f x):(myMap f xs)

-- myFilter - takes a predicate and a list and returns
-- list that matches the predicate

{- filter (\ x -> x > 3) [6, 5, 4, 3, 3, 1]
   [6, 5, 4] -}

myFilter p [] = []
myFilter p (x:xs) = 
    if (p x) 
        then (x:rest)
        else rest where
            rest = myFilter p xs

-- myFilter (>3) [6,5,4,3,2,1,10]
-- [6,5,4,10]

-- lookUp looks up item in list and returns it
lookUp 0 (x:_) = x
lookUp n (_:xs) = lookup (n-1) xs
lookUp [] = error "lookUp: Index out of range"
-- lookup _ [] = undefined  -- will cause an undefined Exception

-- lookUp 3 [2,5,4,8,7,9,8]
-- 8
-- lookUp with index beyond what the list contains causes Exception
-- last pattern allows us to define error message

--listFrom n returns the infinite list [n, n+1, n+2, ...]
listFrom n = n:listFrom (n+1)

myIf True tVal _ = tVal
myIf False _ fVal = fVal
-- myIf (5 > 3) "5 is bigger than 3" "No it isn't"
-- "5 is bigger than 3"

myFilter' _ [] = []
myFilter' p (x:xs) = 
    myIf (p x) (x:rest) rest where
        rest = myFilter' p xs

myFilter'' _ [] = []
myFilter'' p (x:xs) -- no equals sign here
    | (p x)         = x:rest
    | otherwise     = rest where
        rest = myFilter'' p xs

eSqrt :: Double -> Maybe Double
eSqrt x
    | x < 0.0   = Nothing
    | otherwise = Just (sqrt x)

-- probably better if our function took the same kind of value it returns...
-- raises exceptions and it propogates exceptions to its caller
-- similar to exception neutrality in C++
eSqrt' :: (Maybe Double) -> (Maybe Double)
eSqrt' Nothing = Nothing
eSqrt' (Just x)
    | x >= 0.0  = Just (sqrt x)
    | otherwise = Nothing

-- infix operator @/ that handles divide by 0
infixl 7 @/ -- sets precedence, left associative
(@/) :: Maybe Double -> Maybe Double -> Maybe Double
Nothing @/ _ = Nothing
_ @/ Nothing = Nothing
(Just _) @/ (Just 0.0) = Nothing
(Just x) @/ (Just y) = Just (x / y)

bigger a b = if b > a then b else a
foldl1 bigger [3,6,2,0,10,29,34,-8,90,2,54,3]
-- returns the biggest value in the list (90)
max = foldl1 bigger
max [3,5,7,9,11]
-- returns 11

-- returns a list of the two largest items from a list
h n [] = [n]
h n [a]
    | n > a         = [a, n]
    | otherwise     = [n, a]
h n [a, b]
    | n > b         = [b, n]
    | n > a         = [n, b]
    | otherwise     = [a, b]
foldr h [] [4,5,2,7,78,34,89,34,100,34,123,4,5,-2,4,66]
-- returns [100, 123]