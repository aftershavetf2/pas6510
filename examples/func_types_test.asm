; pas6510 compiled program: func_types_test
;

  .org $0801

; BASIC stub: 10 SYS 2061
  .byte $0b, $08, $0a, $00, $9e, $32, $30, $36, $31, $00, $00, $00

; Program start
start:
  jsr main
  rts

; Main module: func_types_test
; Procedure: set_global
set_global:
  lda _var_set_global_x
  sta _var_global_val
  rts

; Procedure: set_global16
set_global16:
  lda _var_set_global16_x
  ldx _var_set_global16_x+1
  sta _var_global_val16
  stx _var_global_val16+1
  rts

; Procedure: increment_global
increment_global:
  lda _var_global_val
  pha
  lda #1
  sta _tmp
  pla
  clc
  adc _tmp
  sta _var_global_val
  rts

; Procedure: print_ok
print_ok:
  lda #79
  jsr $ffd2  ; CHROUT
  lda #75
  jsr $ffd2  ; CHROUT
  lda #32
  jsr $ffd2  ; CHROUT
  rts

; Procedure: print_fail
print_fail:
  lda #70
  jsr $ffd2  ; CHROUT
  lda #65
  jsr $ffd2  ; CHROUT
  lda #73
  jsr $ffd2  ; CHROUT
  lda #76
  jsr $ffd2  ; CHROUT
  lda #32
  jsr $ffd2  ; CHROUT
  rts

; Procedure: newline
newline:
  lda #13
  jsr $ffd2  ; CHROUT
  rts

; Procedure: test_u8_identity
test_u8_identity:
  lda #55
  sta _var_identity_u8_x
  jsr identity_u8
  sta _var_test_u8_identity_result
  lda _var_test_u8_identity_result
  cmp #55
  beq _skip_2
  jmp _else_0
_skip_2:
  jsr print_ok
  jmp _endif_1
_else_0:
  jsr print_fail
_endif_1:
  rts

; Procedure: test_u8_add
test_u8_add:
  lda #10
  sta _var_add_u8_a
  lda #20
  sta _var_add_u8_b
  jsr add_u8
  sta _var_test_u8_add_result
  lda _var_test_u8_add_result
  cmp #30
  beq _skip_5
  jmp _else_3
_skip_5:
  jsr print_ok
  jmp _endif_4
_else_3:
  jsr print_fail
_endif_4:
  rts

; Procedure: test_u8_double
test_u8_double:
  lda #25
  sta _var_double_u8_x
  jsr double_u8
  sta _var_test_u8_double_result
  lda _var_test_u8_double_result
  cmp #50
  beq _skip_8
  jmp _else_6
_skip_8:
  jsr print_ok
  jmp _endif_7
_else_6:
  jsr print_fail
_endif_7:
  rts

; Procedure: test_u8_const
test_u8_const:
  jsr const_u8
  sta _var_test_u8_const_result
  lda _var_test_u8_const_result
  cmp #42
  beq _skip_11
  jmp _else_9
_skip_11:
  jsr print_ok
  jmp _endif_10
_else_9:
  jsr print_fail
_endif_10:
  rts

; Procedure: test_u16_const
test_u16_const:
  jsr const_u16
  sta _var_test_u16_const_result
  stx _var_test_u16_const_result+1
  lda _var_test_u16_const_result
  ldx _var_test_u16_const_result+1
  jsr write_u16_ln
  rts

; Procedure: test_u16_big
test_u16_big:
  jsr big_const
  sta _var_test_u16_big_result
  stx _var_test_u16_big_result+1
  lda _var_test_u16_big_result
  ldx _var_test_u16_big_result+1
  jsr write_u16_ln
  rts

; Procedure: test_u8_to_u16
test_u8_to_u16:
  lda #200
  sta _var_u8_to_u16_x
  jsr u8_to_u16
  sta _var_test_u8_to_u16_result
  stx _var_test_u8_to_u16_result+1
  lda _var_test_u8_to_u16_result
  ldx _var_test_u8_to_u16_result+1
  jsr write_u16_ln
  rts

; Procedure: test_procedure
test_procedure:
  lda #99
  sta _var_set_global_x
  jsr set_global
  lda _var_global_val
  cmp #99
  beq _skip_14
  jmp _else_12
_skip_14:
  jsr print_ok
  jmp _endif_13
_else_12:
  jsr print_fail
_endif_13:
  rts

; Procedure: test_proc_increment
test_proc_increment:
  lda #10
  sta _var_global_val
  jsr increment_global
  jsr increment_global
  lda _var_global_val
  cmp #12
  beq _skip_17
  jmp _else_15
_skip_17:
  jsr print_ok
  jmp _endif_16
_else_15:
  jsr print_fail
_endif_16:
  rts

; Procedure: main
main:
  lda #84
  jsr $ffd2  ; CHROUT
  lda #69
  jsr $ffd2  ; CHROUT
  lda #83
  jsr $ffd2  ; CHROUT
  lda #84
  jsr $ffd2  ; CHROUT
  lda #83
  jsr $ffd2  ; CHROUT
  lda #58
  jsr $ffd2  ; CHROUT
  jsr newline
  jsr test_u8_identity
  jsr test_u8_add
  jsr test_u8_double
  jsr test_u8_const
  jsr newline
  jsr test_u16_const
  jsr test_u16_big
  jsr test_u8_to_u16
  jsr test_procedure
  jsr test_proc_increment
  jsr newline
  lda #68
  jsr $ffd2  ; CHROUT
  lda #79
  jsr $ffd2  ; CHROUT
  lda #78
  jsr $ffd2  ; CHROUT
  lda #69
  jsr $ffd2  ; CHROUT
  jsr newline
  rts

; Function: identity_u8
identity_u8:
  lda _var_identity_u8_x
  rts
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
  rts

; Function: double_u8
double_u8:
  lda _var_double_u8_x
  pha
  lda _var_double_u8_x
  sta _tmp
  pla
  clc
  adc _tmp
  sta _var_double_u8_temp
  lda _var_double_u8_temp
  rts
  rts

; Function: const_u8
const_u8:
  lda #42
  rts
  rts

; Function: identity_u16
identity_u16:
  lda _var_identity_u16_x
  ldx _var_identity_u16_x+1
  rts
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
  rts

; Function: const_u16
const_u16:
  lda #232
  ldx #3
  rts
  rts

; Function: big_const
big_const:
  lda #64
  ldx #156
  rts
  rts

; Function: u8_to_u16
u8_to_u16:
  lda _var_u8_to_u16_x
  ldx #0
  rts
  rts

; Function: sum_to_u16
sum_to_u16:
  lda _var_sum_to_u16_a
  ldx #0
  sta _var_sum_to_u16_result
  stx _var_sum_to_u16_result+1
  lda _var_sum_to_u16_result
  ldx _var_sum_to_u16_result+1
  sta _tmp16
  stx _tmp16+1
  lda _var_sum_to_u16_b
  ldx #0
  clc
  adc _tmp16
  pha
  txa
  adc _tmp16+1
  tax
  pla
  sta _var_sum_to_u16_result
  stx _var_sum_to_u16_result+1
  lda _var_sum_to_u16_result
  ldx _var_sum_to_u16_result+1
  rts
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
_var_global_val:
  .byte 0
_var_global_val16:
  .byte 0, 0
_var_set_global_x:
  .byte 0
_var_set_global16_x:
  .byte 0, 0
_var_test_u8_identity_result:
  .byte 0
_var_test_u8_add_result:
  .byte 0
_var_test_u8_double_result:
  .byte 0
_var_test_u8_const_result:
  .byte 0
_var_test_u16_const_result:
  .byte 0, 0
_var_test_u16_big_result:
  .byte 0, 0
_var_test_u8_to_u16_result:
  .byte 0, 0
_var_identity_u8_x:
  .byte 0
_var_add_u8_a:
  .byte 0
_var_add_u8_b:
  .byte 0
_var_double_u8_x:
  .byte 0
_var_double_u8_temp:
  .byte 0
_var_identity_u16_x:
  .byte 0, 0
_var_add_u16_a:
  .byte 0, 0
_var_add_u16_b:
  .byte 0, 0
_var_u8_to_u16_x:
  .byte 0
_var_sum_to_u16_a:
  .byte 0
_var_sum_to_u16_b:
  .byte 0
_var_sum_to_u16_result:
  .byte 0, 0