! Copyright (C) 2005 Slava Pestov.
! See http://factor.sf.net/license.txt for BSD license.
IN: gadgets
USING: errors generic hashtables kernel lists math matrices
namespaces sdl sequences ;

: layout ( gadget -- )
    #! Set the gadget's width and height to its preferred width
    #! and height. The gadget's children are laid out first.
    #! Note that nothing is done if the gadget does not need to
    #! be laid out.
    dup gadget-relayout? [
        f over set-gadget-relayout?
        dup layout*
        gadget-children [ layout ] each
    ] [
        drop
    ] ifte ;

TUPLE: pack align fill vector ;

: pref-dims ( gadget -- list )
    gadget-children [ pref-dim ] map ;

: orient ( gadget seq1 seq2 -- seq )
    >r >r pack-vector r> r> [ pick set-axis ] 2map nip ;

: packed-dim-2 ( gadget sizes -- list )
    [
        over rect-dim { 1 1 1 } vmax over v-
        rot pack-fill v*n v+
    ] map-with ;

: (packed-dims) ( gadget sizes -- seq )
    2dup packed-dim-2 swap orient ;

: packed-dims ( gadget sizes -- seq )
    over gadget-children >r (packed-dims) r>
    [ set-gadget-dim ] 2each ;

: packed-loc-1 ( sizes -- seq )
    { 0 0 0 } [ v+ ] accumulate ;

: packed-loc-2 ( gadget sizes -- seq )
    >r dup rect-dim { 1 1 1 } vmax over r>
    packed-dim-2 [ v- ] map-with
    >r dup pack-align swap rect-dim { 1 1 1 } vmax r>
    [ >r 2dup r> v- n*v ] map 2nip ;

: (packed-locs) ( gadget sizes -- seq )
    dup packed-loc-1 >r dupd packed-loc-2 r> orient ;

: packed-locs ( gadget sizes -- )
    over gadget-children >r (packed-locs) r>
    [ set-rect-loc ] 2each ;

: packed-layout ( gadget sizes -- )
    2dup packed-locs packed-dims ;

C: pack ( align fill vector -- pack )
    #! align: 0 left aligns, 1/2 center, 1 right.
    #! gap: between each child.
    #! fill: 0 leaves default width, 1 fills to pack width.
    [ <gadget> swap set-delegate ] keep
    [ set-pack-vector ] keep
    [ set-pack-fill ] keep
    [ set-pack-align ] keep ;

: <pile> { 0 1 0 } <pack> ;

: <line-pile> 0 0 <pile> ;

: <shelf> { 1 0 0 } <pack> ;

: <line-shelf> 0 0 <shelf> ;

M: pack pref-dim ( pack -- dim )
    [
        pref-dims
        [ { 0 0 0 } [ vmax ] reduce ] keep
        { 0 0 0 } [ v+ ] reduce
    ] keep pack-vector set-axis ;

M: pack layout* ( pack -- ) dup pref-dims packed-layout ;

: fast-children-on ( dim axis gadgets -- i )
    swapd [ rect-loc origin get v+ v- over v. ] binsearch nip ;

M: pack children-on ( rect pack -- list )
    dup pack-vector swap gadget-children [
        3dup
        >r >r dup rect-loc swap rect-dim v+ r> r> fast-children-on 1 +
        >r
        >r >r rect-loc r> r> fast-children-on 0 max
        r>
    ] keep <slice> ;

TUPLE: stack ;

C: stack ( -- gadget )
    #! A stack lays out all its children on top of each other.
    0 1 { 0 0 1 } <pack> over set-delegate ;

M: stack children-on ( point stack -- gadget )
    nip gadget-children ;
