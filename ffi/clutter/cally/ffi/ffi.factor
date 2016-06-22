! Copyright (C) 2011 Anton Gorenko.
! See http://factorcode.org/license.txt for BSD license.
USING: alien alien.libraries alien.syntax combinators
gobject-introspection kernel system vocabs ;
IN: clutter.cally.ffi

COMPILE<
"atk.ffi" require
"clutter.ffi" require
COMPILE>

LIBRARY: clutter.cally

COMPILE<
"clutter.cally" {
    { [ os windows? ] [ drop ] }
    { [ os macosx? ] [ drop ] }
    { [ os unix? ] [ "libclutter-glx-1.0.so" cdecl add-library ] }
} cond
COMPILE>

GIR: Cally-1.0.gir
