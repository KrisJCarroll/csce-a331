: collcount { n -- c ) 
    0 { c }
    begin
        drop
        c
        n ?one invert while  
            c 1 + to c
            n collatz to n
    repeat
;

: collatz { n -- m }
    n 2 mod 0= if
        n 2 /
    else
        n 3 * 1 + 
    endif
;

: ?one { n -- n  0/-1 )
    n 1 = if 
        -1
    else
        0
    endif
;