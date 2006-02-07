IN: temporary
USING: alien arrays kernel kernel-internals namespaces
objective-c test ;

[ t ] [ 0 <alien> 0 <alien> = ] unit-test
[ f ] [ 0 <alien> 1024 <alien> = ] unit-test
[ f ] [ "hello" 1024 <alien> = ] unit-test

! Testing the various bignum accessor
10 <byte-array> "dump" set

[ 123 ] [
    123 "dump" get 0 set-alien-signed-1
    "dump" get 0 alien-signed-1
] unit-test

[ 12345 ] [
    12345 "dump" get 0 set-alien-signed-2
    "dump" get 0 alien-signed-2
] unit-test

[ 12345678 ] [
    12345678 "dump" get 0 set-alien-signed-4
    "dump" get 0 alien-signed-4
] unit-test

[ 12345678901234567 ] [
    12345678901234567 "dump" get 0 set-alien-signed-8
    "dump" get 0 alien-signed-8
] unit-test

[ -1 ] [
    -1 "dump" get 0 set-alien-signed-8
    "dump" get 0 alien-signed-8
] unit-test

cell 8 = [
    [ HEX: 123412341234 ] [
      8 <byte-array>
      HEX: 123412341234 over 0 set-alien-signed-8
      0 alien-signed-8
    ] unit-test
    
    [ HEX: 123412341234 ] [
      8 <byte-array>
      HEX: 123412341234 over 0 set-alien-signed-cell
      0 alien-signed-cell
    ] unit-test
] when

[ "hello world" ]
[ "hello world" string>alien alien>string ] unit-test

[ "example" ] [ "{example=@*i}" parse-objc-type ] unit-test
[ "void*" ] [ "[12^f]" parse-objc-type ] unit-test
[ "float*" ] [ "^f" parse-objc-type ] unit-test
