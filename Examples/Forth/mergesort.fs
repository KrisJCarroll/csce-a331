: intsize 8 ;

: copy { first1 last1 first2 -- }
    first1 { in }
    first2 { out }
    begin
        in last1 < while
        in @ out !
        in intsize + to in
        out intsize + to out
    repeat
;

: stable-merge { first middle last -- }
    first { in1 }
    middle { in2 }
    last first - { sizeb }
    sizeb allocate { buffer alloc-fail? }
    alloc-fail? if
        1 throw \ Throw exception 1 on allocation fail
    endif
    buffer { out } \ setting out = buffer pointer
    begin
        in1 middle < in2 last < and while \ keep going while in1 < middle and in2 < last
        in2 @ in1 @ < if \ if in2 points to something smaller
            in2 @ out ! \ put in2 in out
            in2 intsize + to in2
        else
            in1 @ out !
            in1 intsize + to in1
        endif
        out intsize + to out
    repeat

    in1 middle out copy \ Copy remainder of values to buffer
    in2 last out copy \ one of these does nothing because it's empty

    buffer buffer sizeb + first copy \ copy buffer back to original memory
    buffer free { free-fail? } \ free buffer
;

: merge-sort-recurse { first last -- }
    last first - intsize / { sizei }
    sizei 1 > if \ Base case (nothing to do) if sizei <= 1
        sizei 2 / intsize * first + { middle } \ Get ptr to middle of range
        first middle recurse \ sort 1st half
        middle last recurse \ sort 2nd half
        first middle last stable-merge \ merge the halves
    endif
;

: merge-sort { addr sizei -- }
    sizei 0 < if 
        2 throw \ throw exception 2 on negative array size
    endif
    sizei intsize * addr + { last }
    addr last merge-sort-recurse
;

: try-merge-sort { sizei -- }
    cr cr ." Array size: " sizei . cr 
    sizei alloc-array { arr }
    sizei 2 / -2 arr sizei 2 / set-array
    sizei 2 / 1 + -2 arr sizei 2 / intsize * + sizei sizei 2 / -
    set-array
    cr ." Values before sort: " cr
    arr sizei print-array
    cr ." Sorting (Merge Sort) ... "
    stdout flush-file { flush-err } \ Flush standard output
    arr sizei merge-sort
    ." DONE" cr
    cr ." Press ENTER to continue " user-pause cr
    cr ." Values after sort:" cr
    arr sizei print-array
    arr free { free-fail? }
;