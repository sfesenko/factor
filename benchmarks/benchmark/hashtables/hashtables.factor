! Copyright (C) 2009 Slava Pestov.
! See http://factorcode.org/license.txt for BSD license.
USING: accessors assocs combinators grouping kernel locals math
math.parser math.ranges memoize sequences ;
in: benchmark.hashtables

MEMO: strings ( -- str )
    0 100 [a,b) 1 [ + ] accumulate* [ number>string ] map ;

:: add-delete-mix ( hash keys -- )
    keys |[ k |
        0 k hash set-at
        k hash delete-at
    ] each

    keys [
        0 swap hash set-at
    ] each

    keys [
        hash delete-at
    ] each ;

:: store-lookup-mix ( hash keys -- )
    keys [
        0 swap hash set-at
    ] each

    keys [
        hash at
    ] map drop

    keys [
        hash [ 1 + ] assocs:change-at
    ] each ;

: string-mix ( hash -- )
    strings
    [ add-delete-mix ]
    [ store-lookup-mix ]
    2bi ;

TUPLE: collision value ;

M: collision hashcode* value>> hashcode* 15 bitand ;

: collision-mix ( hash -- )
    strings 30 head [ collision boa ] map
    [ add-delete-mix ]
    [ store-lookup-mix ]
    2bi ;

: small-mix ( hash -- )
    strings 10 group [
        [ add-delete-mix ]
        [ store-lookup-mix ]
        2bi
    ] with each ;

: hashtables-benchmark ( -- )
    H{ } clone
    10000 [
        dup {
            [ small-mix ]
            [ clear-assoc ]
            [ string-mix ]
            [ clear-assoc ]
            [ collision-mix ]
            [ clear-assoc ]
        } cleave
    ] times
    drop ;

main: hashtables-benchmark
