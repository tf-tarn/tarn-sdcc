        .include "macros/macros.s"

        .text
test_save_rx_restore_rx:
        mov r il ,0x30
        mov x il ,0x31
        save_rx
        mov pic r
        mov pic x
        mov r il ,0x32
        mov x il ,0x33
        mov pic r
        mov pic x
        restore_rx
        mov pic r
        mov pic x


test_add_16s_8:
        ;; these get saved
        mov r il ,0x99
        mov x il ,0x88

        ;; no carry -> 0x4031
        mov stack il ,0x40 ; h
        mov stack il ,0x30 ; l
        add_16s_8 1
        mov pic x
        mov pic r

        restore_rx
        mov pic x
        mov pic r

        ;; with carry -> 0x4130
        mov stack il ,0x40 ; h
        mov stack il ,0x31 ; l
        add_16s_8 0xff
        mov pic x
        mov pic r

        restore_rx
        mov pic x
        mov pic r

test_add_16s_8_nosave:
        ;; these get clobbered
        mov r il ,0x98
        mov x il ,0x87

        ;; no carry -> 0x4031
        mov stack il ,0x40 ; h
        mov stack il ,0x30 ; l
        add_16s_8_nosave 1
        mov pic x
        mov pic r

        ;; these get clobbered
        mov r il ,0x97
        mov x il ,0x86

        ;; with carry -> 0x4130
        mov stack il ,0x40 ; h
        mov stack il ,0x31 ; l
        add_16s_8_nosave 0xff
        mov pic x
        mov pic r

test_add_16s_8s:
        ;; these get saved
        mov r il ,0x95
        mov x il ,0x84

        ;; no carry -> 0x4031
        mov stack il ,1 ; l
        mov stack il ,0x40 ; h
        mov stack il ,0x30 ; l
        add_16s_8s
        mov pic x
        mov pic r

        restore_rx
        mov pic x
        mov pic r

        ;; with carry -> 0x4130
        mov stack il ,0xff ; l
        mov stack il ,0x40 ; h
        mov stack il ,0x31 ; l
        add_16s_8s
        mov pic x
        mov pic r

        restore_rx
        mov pic x
        mov pic r

test_add_8s_16s:
        ;; these get saved
        mov r il ,0x94
        mov x il ,0x83

        ;; no carry -> 0x4031
        mov stack il ,0x40 ; h
        mov stack il ,0x30 ; l
        mov stack il ,1 ; l
        add_8s_16s
        mov pic x
        mov pic r

        restore_rx
        mov pic x
        mov pic r

        ;; with carry -> 0x4130
        mov stack il ,0x40 ; h
        mov stack il ,0x31 ; l
        mov stack il ,0xff ; l
        add_8s_16s
        mov pic x
        mov pic r

        restore_rx
        mov pic x
        mov pic r

test_add_16m_16m:
        ;; no carry -> 0x1004
        add_16m_16m test_value1 test_value2
        mov pic x
        mov pic r

        ;; with carry -> 0x2001
        add_16m_16m test_value2 test_value3
        mov pic x
        mov pic r

test_add_16s_16l:
        ;; no carry -> 0x5040
        mov stack il ,0x40 ; h
        mov stack il ,0x30 ; l
        add_16s_16l 0x1010
        mov pic x
        mov pic r

        ;; with carry -> 0x512f
        mov stack il ,0x40 ; h
        mov stack il ,0x30 ; l
        add_16s_16l 0x10ff
        mov pic x
        mov pic r

test_add_8s_16:
        ;; no carry -> 0x4031
        mov stack il ,1 ; l
        add_8s_16 0x4030
        mov pic x
        mov pic r

        ;; with carry -> 0x4130
        mov stack il ,0xff ; l
        add_8s_16 0x4031
        mov pic x
        mov pic r

test_negate_16m:
        negate_16m test_value1
        lad temp
        mov mem x
        lad temp + 1
        mov mem r
        add_16m_16m temp test_value1
        ;; should be zero
        mov pic x
        mov pic r

        negate_16m test_value2
        lad temp
        mov mem x
        lad temp + 1
        mov mem r
        add_16m_16m temp test_value2
        ;; should be zero
        mov pic x
        mov pic r

        negate_16m test_value3
        lad temp
        mov mem x
        lad temp + 1
        mov mem r
        add_16m_16m temp test_value3
        ;; should be zero
        mov pic x
        mov pic r

test_add_16s_16m:
        ;; no carry -> 0x2022
        mov stack il ,0x10 ; h
        mov stack il ,0x20 ; l
        add_16s_16m test_value2
        mov pic x
        mov pic r

        ;; with carry -> 0x2103
        mov stack il ,0x10 ; h
        mov stack il ,0x04 ; l
        add_16s_16m test_value3
        mov pic x
        mov pic r

test_sub_16m_16m:
        ;; 0x1002 - 0x0002 = 0x1000
        sub_16m_16m test_value2 test_value1
        mov pic x
        mov pic r
        
        ;; 0x10ff - 0x1002 = 0x00fd
        sub_16m_16m test_value3 test_value2
        mov pic x
        mov pic r
        
        ;; 0x1002 - 0x10ff = -0x00fd = 0xff03
        sub_16m_16m test_value2 test_value3
        mov pic x
        mov pic r

test_compare_16m_16m_lt:
        .macro test_compare_16m_16m_lt arg1 arg2
        compare_16m_16m__tf 9 \arg1, \arg2, is_lt\@, is_gt\@

        is_lt\@:
        mov pic il ,0x80
        goto next\@

        is_gt\@:
        mov pic il ,0x08

        next\@:
        .endm

        ;; first < second -> 0x80
        test_compare_16m_16m_lt test_value1 test_value2
        ;; !(first < second) -> 0x08
        test_compare_16m_16m_lt test_value2 test_value1
        ;; first < second -> 0x08
        test_compare_16m_16m_lt test_value2 test_value3
        ;; !(first < second) -> 0x08
        test_compare_16m_16m_lt test_value3 test_value2
        
end:
        halt


        .data
test_value1:
        .byte 0x00
        .byte 0x02
test_value2:
        .byte 0x10
        .byte 0x02
test_value3:
        .byte 0x10
        .byte 0xff
temp:   .zero 2
