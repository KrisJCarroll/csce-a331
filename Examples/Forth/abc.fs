: advance { a b -- b a+b }
    b
    a b +
;

: fibopair { n -- F(n) F(n+1) }
    n 0 = if \ if n == 0
      0 1
    else
      n 1 - recurse advance
    endif
;

: fibo { n -- F(n) }
    n fibopair
    drop
;

\ gcd(a, 0) = a
\ gcd(a, b) = gcd (b, a%b)
: gcd { a b -- GCD(a,b) }
    b 0 = if
      a
    else
      a b mod { c } \ C++: c = a%b
      b c recurse
    endif
;

\ C++: for ( int i = a; i < b; ++i)
\ Forth: b a ?do ... loop
: sayHowdy { n -- }
    cr
    n 0 ?do 
        i 1 + .
        ." Howdy!" cr
    loop
; 

: intsize 8 ;

: makeintarray { size -- addr fail? }
    size intsize allocate
;

: a@ { index addr -- value }
    addr index intsize * + @
;

: a! { value index addr -- }
    value addr index intsize * + !
;

: printintarray { addr size -- }
    size 0 ?do
        i addr a@ . 
    loop
    cr
;

: setintarray { start skip addr size -- }
    size 0 ?do
        start i skip * + i addr a!
    loop
;

: arraystuff ( -- )
    20 { size }
    size makeintarray { arr badarr? }
    badarr? if 
        cr
        s" Could not allocate" cr
    else
        5 2 arr size setintarray
        cr
        s" Values : "
        arr size printintarray
        arr free { badfree? }
    endif
;

: backtype { addr len -- }
    begin
        len 0 > while
        len 1 - to len
        addr len + c@ emit \ character fetch and emit
    repeat
;

: printrev ( -- )
    100 { buf-size }
    buf-size allocate { buf-addr alloc-fail? }
    alloc-fail? if
        cr cr
        ." ERROR: could not allocate buffer"
        cr cr
    else
        cr cr
        ." Type something: "
        buf-addr buf-size accept { inputlen }
        cr cr
        ." Here is what you typed: "
        buf-addr inputlen type
        cr cr
        ." And here it is backward: "
        buf-addr inputlen backtype
        cr cr
        buf-addr free { free-fail? }
    endif
;

: sqrtsout ( -- )
    cr
    1e
    11 1 ?do
        fdup f. 
        fdup fsqrt f.
        cr 
        1e f+
    loop
    fdrop
;

\ xt should be a word that does ( a -- b )
: map-array { arr sizei xt -- }
    ." map-array, got XT for: " xt >name name>string type cr
    arr { loc }
    sizei 0 ?do
        loc @   xt execute   loc ! \ get the thing at loc, execute xt on it, store it in loc
        loc intsize + to loc \ update loc to next index
    loop
;

: sq { x -- }
    x x *
;

: try-map-array { sizei -- }
    cr
    sizei intsize * allocate { arr alloc-fail? }
    alloc-fail? if 
        1 throw 
    endif
    1 1 arr sizei setintarray
    ." Values before map: " arr sizei printintarray
    arr sizei ['] sq  map-array \ have to put the single quote ' in braces when not in immediate mode
    ." Values after map: " arr sizei printintarray
;

: print-pos { n -- }
    n 0 > if 
        ." n = " n . cr
    else
        s" print-pos: non-positive parameter" exception throw \ throw exception with the included error message
    endif
;

: div { x y -- }
    cr
    x y ['] / catch
    dup if 
        \ Exception was thrown
        { dummy1 dummy2 exception-code }
        ." Exception thrown: " exception-code . cr
    else
        \ No exception was thrown
        { result zero }
        x . ." divided by " y . ." is " result . cr
    endif  
;

: bar { x y -- }
    try
        ." First line of try" cr
        x y / { z }
        ." Third line of try" cr
        0
    restore
        dup if 
            ." Exception thrown" cr
        else
            ." No exception thrown" cr
        endif
    endtry
    throw \ throw the exception if there is one
;

: curry+ 
    create , 
    does>
    @ + 
;
\ 5 curry+ 5+ \ makes a word called 5+ that adds 5 to things
\ 100 curry+ xyz \ makes a word called xyz that adds 100 to things