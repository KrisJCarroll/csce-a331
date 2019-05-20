data Product = Pr String String

productName (Pr pn _) = pn
manufacturerName (Pr _ mn) = mn

x = Pr "Cheetos" "Frito-Lay"
productName x
-- "Cheetos"
manuFacturerName x
-- "Frito-Lay"
-- cannot print x

sameProduct :: Product -> Product -> Bool
sameProduct (Pr pn1 mn1) (Pr pn2 mn2) = 
    (pn1 == pn2) && (mn1 == mn2)

-- But we can overload the "==" operator
instance Eq Product where
    Pr pn1 mn1 == Pr pn2 mn 2   = (pn1 == pn2) && (mn1 == mn2)

y = Pr "Doritos" "Lays"

x == y
-- False
x /= y
-- True

instance Show Prodeuct where
    show (Pr pn mn) = pn ++ " [made by " ++ mn ++ "]"

show x 
-- Cheetos [made by Frito-Lay]