; pas6510 compiled program: test_loop_with_var
;

  .org $0801

; BASIC stub: 10 SYS 2061
  .byte $0b, $08, $0a, $00, $9e, $32, $30, $36, $31, $00, $00, $00

; Program start
start:
  jsr main
  rts

; Main module: test_loop_with_var
; Procedure: main
main:
  lda #0
  ldx #0
  sta _var_main_sum
  stx _var_main_sum+1
  sta _var_main_i
_for_0:
  lda _var_main_sum
  ldx _var_main_sum+1
  sta _tmp16
  stx _tmp16+1
  lda _var_main_i
  ldx #0
  clc
  adc _tmp16
  pha
  txa
  adc _tmp16+1
  tax
  pla
  sta _var_main_sum
  stx _var_main_sum+1
  inc _var_main_i
  lda #$00
_var_main_i = *-1
  cmp #11
  beq _endfor_1
  jmp _for_0
_endfor_1:
  lda _var_main_sum
  ldx _var_main_sum+1
  jsr write_u16_ln
  rts


; Runtime library

_tmp16: .byte 0, 0

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
_var_main_sum:
  .byte 0, 0