\ Compute Fibonacci Numbers

\ Can be done in a prettier manner

: advance ( a b -- b a+b )
  swap      \ Stack : b a
  over      \ Stack : b a b
  +         \ Stack : b a+b
;

\ fibo
: fibo ( n -- F[n] )
  0 1       \ Stack: n 0 1
  rot       \ Stack: 0 1 n
  0 ?do     \ Counted loop: n times
    advance
  loop
            \ Stack: F[n] F[n+1]
  drop      \ Stack: F[n]
;

: printfibos ( k -- )
    cr
    1 + 0 ?do \ Counted loop: k+1 times
        ." F("
        i 1 .r \ Output loop counter with no trailing blank
        ." ) = "
        i fibo .
        cr
    loop
;

\ Main Program
cr
." Fibonacci Numbers"
cr 
17 \ k for last F[k] to print
   \ Can be up to 46 on 32-bit system, 92 on 64-bit system
printfibos

\ Named paramters version of advance
: advance { a b -- a+b } everything after the dashes is a comment
    b
    a b +
;

