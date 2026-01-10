; pas6510 compiled program: screen_memory_chaos
;

  .org $0801

; BASIC stub: 10 SYS 2061
  .byte $0b, $08, $0a, $00, $9e, $32, $30, $36, $31, $00, $00, $00

; Program start
start:
  jsr main
  rts

; Module: sys
; Procedure: irq_enable
irq_enable:
  rts

; Procedure: irq_disable
irq_disable:
  rts

; Procedure: memset
memset:
  rts

; Main module: screen_memory_chaos
; Procedure: main
main:
  sei
  lda #0
  sta _var_main_x
_while_0:
  lda #1
  bne _skip_2
  jmp _endwhile_1
_skip_2:
  lda #0
  sta _var_main_x
_for_3:
  lda #0
  sta _var_main_i
_for_5:
  ldy _var_main_i
  lda _var_main_x
  sta $0400,y
  inc _var_main_i
  lda _var_main_i
  bne _for_5
_endfor_6:
  inc _var_main_x
  lda _var_main_x
  bne _for_3
_endfor_4:
  jmp _while_0
_endwhile_1:
  rts


; Runtime library

_tmp: .byte 0, 0
_tmp16: .byte 0, 0

_poke_addr = $fb  ; ZP location for indirect addressing

_mul_a: .byte 0
_mul_b: .byte 0
_multiply:
  lda #0
  ldx #8
_mul_loop:
  lsr _mul_b
  bcc _mul_skip
  clc
  adc _mul_a
_mul_skip:
  asl _mul_a
  dex
  bne _mul_loop
  rts

_div_a: .byte 0
_div_b: .byte 0
_divide:
  ldx #0
  lda _div_a
_div_loop:
  cmp _div_b
  bcc _div_done
  sec
  sbc _div_b
  inx
  jmp _div_loop
_div_done:
  stx _tmp
  lda _tmp
  rts

; write_u16_ln - print 16-bit number and newline
_print_val: .byte 0, 0
_print_buf: .byte 0, 0, 0, 0, 0, 0
write_u16_ln:
  sta _print_val
  stx _print_val+1
  ; Convert to decimal string
  ldy #0
_p16_loop:
  lda _print_val
  ora _print_val+1
  beq _p16_print
  ; Divide by 10
  jsr _div16_10
  ; Remainder (0-9) is in A
  clc
  adc #$30
  sta _print_buf,y
  iny
  jmp _p16_loop
_p16_print:
  cpy #0
  bne _p16_hasdigits
  lda #$30  ; print '0' if value was 0
  jsr $ffd2
  jmp _p16_newline
_p16_hasdigits:
_p16_printloop:
  dey
  lda _print_buf,y
  jsr $ffd2  ; CHROUT
  cpy #0
  bne _p16_printloop
_p16_newline:
  lda #13
  jsr $ffd2
  rts

_div16_10:
  lda #0
  ldx #16
_d10_loop:
  asl _print_val
  rol _print_val+1
  rol a
  cmp #10
  bcc _d10_skip
  sbc #10
  inc _print_val
_d10_skip:
  dex
  bne _d10_loop
  ; Remainder in A, quotient in _print_val
  rts

; Variables
_var_memset_addr:
  .byte 0, 0
_var_memset_len:
  .byte 0
_var_memset_value:
  .byte 0
_var_main_i:
  .byte 0
_var_main_x:
  .byte 0