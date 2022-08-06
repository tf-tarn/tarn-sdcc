__asm
read_mem_display:
        mov stack r
        mov stack x

        mov x il ,0xff
        ;; lad loopvar
        ;; mov mem il ,0xff

read_mem_display_loop:
        ;; increment loopvar
        ;; lad loopvar
        mov alus il ,4 ; +
        mov alua x
        mov alub il ,1
        mov x aluc

        ;; get ADH value and read memory
        lad _read_mem_adh
        mov r mem
        ;; ;; doing this saves one instruction over using memory..
        ;; mov stack r
        ;; mov r stack
        mov adh r
        mov adl aluc

        mov alus il ,10 ; ==
        mov alua mem
        mov alub il ,0xf
        mov test aluc


        ;; print byte
        mov pic il ,' '
        mov pic il ,0x0E ;; change character mode
        mov pic mem
        mov pic il ,0x0F ;; switch back

        ;; lad loopvar
        ;; print newline if loopvar % 16 == 0 and loopvar != 0

        mov alua x

        mov alus il ,0 ; &
        mov alub il ,0xf
        mov alua aluc

        mov alus il ,10 ; ==
        mov alub il ,0xf
        mov test aluc
        gotonz print_newline
        goto continue

print_newline:
        mov pic il ,'\n'

continue:
        ;; stop if loopvar is 0xff
        mov alus il ,10 ; ==
        mov alua x
        mov alub il ,0xff
        mov test aluc
        gotonz exit_read_mem_display_loop
        goto read_mem_display_loop

exit_read_mem_display_loop:
        mov x stack
        mov r stack
__endasm;
