-- Either constructor for empty tree or root node with a left tree and right tree
data BinTree vt = BTEmpty | BTNode vt (BinTree vt) (BinTree vt)
BTNode 42 BTEmpty BTEmpty -- Single node tree containing 42 at the root

inorderTraverse :: (Ord vt) => BinTree vt -> [vt]
inorderTraverse BTEmpty = []
inorderTraverse (BTNode vv lsub rsub) = 
    inorderTraverse lsub ++ [vv] ++ inorderTraverse rsub

x = BTNode 42 (BTNode 56 BTEmpty BTEmpty) (BTNode 200 BTEmpty BTEmpty)
inorderTraverse x
-- [56, 42, 200]

insert :: (Ord vt) => BinTree vt -> vt -> BinTree vt
insert BTEmpty vv = BTNode vv BTEmpty BTEmpty
insert (BTNode r lsub rsub)
    | vv < r    = BTNode r (insert lsub vv) rsub
    | otherwise = BTNode root lsub

treesort :: (Ord vt) => [vt] -> [vt]
treesort xs = inorderTraverse $ foldl insert BTEmpty xs -- left fold of insert with initial value of BTEmpty and xs as the list
