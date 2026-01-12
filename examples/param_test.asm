; pas6510 compiled program: param_test
;

  .org $0801

; BASIC stub: 10 SYS 2061
  .byte $0b, $08, $0a, $00, $9e, $32, $30, $36, $31, $00, $00, $00

; Program start
start:
  jsr main
  rts

; Main module: param_test
; Procedure: store_u8
store_u8:
  lda _var_store_u8_x
  sta _var_last_value
  rts

; Procedure: store_u16
store_u16:
  lda _var_store_u16_x
  ldx _var_store_u16_x+1
  sta _var_last_value16
  stx _var_last_value16+1
  rts

; Procedure: main
main:
  lda #41
  sta _var_inc_u8_x
  jsr inc_u8
  sta _var_main_r8
  ldx #0
  jsr write_u16_ln
  lda #10
  sta _var_add_u8_a
  lda #32
  sta _var_add_u8_b
  jsr add_u8
  sta _var_main_r8
  ldx #0
  jsr write_u16_ln
  lda #231
  ldx #3
  sta _var_inc_u16_x
  stx _var_inc_u16_x+1
  jsr inc_u16
  sta _var_main_r16
  stx _var_main_r16+1
  lda _var_main_r16
  ldx _var_main_r16+1
  jsr write_u16_ln
  lda #48
  ldx #117
  sta _var_add_u16_a
  stx _var_add_u16_a+1
  lda #16
  ldx #39
  sta _var_add_u16_b
  stx _var_add_u16_b+1
  jsr add_u16
  sta _var_main_r16
  stx _var_main_r16+1
  lda _var_main_r16
  ldx _var_main_r16+1
  jsr write_u16_ln
  lda #200
  sta _var_mul_u8_to_u16_a
  sta _var_mul_u8_to_u16_b
  jsr mul_u8_to_u16
  sta _var_main_r16
  stx _var_main_r16+1
  lda _var_main_r16
  ldx _var_main_r16+1
  jsr write_u16_ln
  lda #77
  sta _var_store_u8_x
  jsr store_u8
  lda _var_last_value
  ldx #0
  jsr write_u16_ln
  lda #57
  ldx #48
  sta _var_store_u16_x
  stx _var_store_u16_x+1
  jsr store_u16
  lda _var_last_value16
  ldx _var_last_value16+1
  jsr write_u16_ln
  rts

; Function: inc_u8
inc_u8:
  lda _var_inc_u8_x
  pha
  lda #1
  sta _tmp
  pla
  clc
  adc _tmp
  rts

; Function: add_u8
add_u8:
  lda _var_add_u8_a
  pha
  lda _var_add_u8_b
  sta _tmp
  pla
  clc
  adc _tmp
  rts

; Function: inc_u16
inc_u16:
  lda _var_inc_u16_x
  ldx _var_inc_u16_x+1
  sta _tmp16
  stx _tmp16+1
  lda #1
  ldx #0
  clc
  adc _tmp16
  pha
  txa
  adc _tmp16+1
  tax
  pla
  rts

; Function: add_u16
add_u16:
  lda _var_add_u16_a
  ldx _var_add_u16_a+1
  sta _tmp16
  stx _tmp16+1
  lda _var_add_u16_b
  ldx _var_add_u16_b+1
  clc
  adc _tmp16
  pha
  txa
  adc _tmp16+1
  tax
  pla
  rts

; Function: mul_u8_to_u16
mul_u8_to_u16:
  lda _var_mul_u8_to_u16_a
  ldx #0
  sta _var_mul_u8_to_u16_result
  stx _var_mul_u8_to_u16_result+1
  lda _var_mul_u8_to_u16_result
  pha
  lda _var_mul_u8_to_u16_b
  sta _tmp
  pla
  sta _mul_a
  lda _tmp
  sta _mul_b
  jsr _multiply
  ldx #0
  sta _var_mul_u8_to_u16_result
  stx _var_mul_u8_to_u16_result+1
  lda _var_mul_u8_to_u16_result
  ldx _var_mul_u8_to_u16_result+1
  rts


; Runtime library

_tmp: .byte 0, 0
_tmp16: .byte 0, 0

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
_var_last_value:
  .byte 0
_var_last_value16:
  .byte 0, 0
_var_store_u8_x:
  .byte 0
_var_store_u16_x:
  .byte 0, 0
_var_main_r8:
  .byte 0
_var_main_r16:
  .byte 0, 0
_var_inc_u8_x:
  .byte 0
_var_add_u8_a:
  .byte 0
_var_add_u8_b:
  .byte 0
_var_inc_u16_x:
  .byte 0, 0
_var_add_u16_a:
  .byte 0, 0
_var_add_u16_b:
  .byte 0, 0
_var_mul_u8_to_u16_a:
  .byte 0
_var_mul_u8_to_u16_b:
  .byte 0
_var_mul_u8_to_u16_result:
  .byte 0, 0