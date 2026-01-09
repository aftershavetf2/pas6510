; pas6510 compiled program: test_modules
;

  .org $0801

; BASIC stub: 10 SYS 2061
  .byte $0b, $08, $0a, $00, $9e, $32, $30, $36, $31, $00, $00, $00

; Program start
start:
  jsr main
  rts

; Module: test_lib
; Procedure: test_init
test_init:
  lda #0
  ldx #0
  sta _var_test_count
  stx _var_test_count+1
  lda #0
  ldx #0
  sta _var_pass_count
  stx _var_pass_count+1
  lda #0
  ldx #0
  sta _var_fail_count
  stx _var_fail_count+1
  lda #0
  ldx #0
  sta _var_current_test
  stx _var_current_test+1
  rts

; Procedure: print_test
print_test:
  lda #84
  jsr $ffd2  ; CHROUT
  lda #69
  jsr $ffd2  ; CHROUT
  lda #83
  jsr $ffd2  ; CHROUT
  lda #84
  jsr $ffd2  ; CHROUT
  lda #32
  jsr $ffd2  ; CHROUT
  rts

; Procedure: print_pass
print_pass:
  lda #80
  jsr $ffd2  ; CHROUT
  lda #65
  jsr $ffd2  ; CHROUT
  lda #83
  jsr $ffd2  ; CHROUT
  lda #83
  jsr $ffd2  ; CHROUT
  lda #13
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
  lda #13
  jsr $ffd2  ; CHROUT
  rts

; Procedure: print_expected
print_expected:
  lda #32
  jsr $ffd2  ; CHROUT
  lda #32
  jsr $ffd2  ; CHROUT
  lda #69
  jsr $ffd2  ; CHROUT
  lda #88
  jsr $ffd2  ; CHROUT
  lda #80
  jsr $ffd2  ; CHROUT
  lda #69
  jsr $ffd2  ; CHROUT
  lda #67
  jsr $ffd2  ; CHROUT
  lda #84
  jsr $ffd2  ; CHROUT
  lda #69
  jsr $ffd2  ; CHROUT
  lda #68
  jsr $ffd2  ; CHROUT
  lda #58
  jsr $ffd2  ; CHROUT
  lda #32
  jsr $ffd2  ; CHROUT
  rts

; Procedure: print_actual
print_actual:
  lda #32
  jsr $ffd2  ; CHROUT
  lda #32
  jsr $ffd2  ; CHROUT
  lda #65
  jsr $ffd2  ; CHROUT
  lda #67
  jsr $ffd2  ; CHROUT
  lda #84
  jsr $ffd2  ; CHROUT
  lda #85
  jsr $ffd2  ; CHROUT
  lda #65
  jsr $ffd2  ; CHROUT
  lda #76
  jsr $ffd2  ; CHROUT
  lda #58
  jsr $ffd2  ; CHROUT
  lda #32
  jsr $ffd2  ; CHROUT
  lda #32
  jsr $ffd2  ; CHROUT
  lda #32
  jsr $ffd2  ; CHROUT
  rts

; Procedure: assert_eq
assert_eq:
  lda _var_test_count
  ldx _var_test_count+1
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
  sta _var_test_count
  stx _var_test_count+1
  lda _var_test_count
  ldx _var_test_count+1
  sta _var_current_test
  stx _var_current_test+1
  jsr print_test
  lda _var_current_test
  ldx _var_current_test+1
  jsr write_u16_ln
  lda _var_expected_val
  pha
  lda _var_actual_val
  sta _tmp
  pla
  cmp _tmp
  bne _else_0
  lda _var_pass_count
  ldx _var_pass_count+1
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
  sta _var_pass_count
  stx _var_pass_count+1
  jsr print_pass
  jmp _endif_1
_else_0:
  lda _var_fail_count
  ldx _var_fail_count+1
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
  sta _var_fail_count
  stx _var_fail_count+1
  jsr print_fail
  jsr print_expected
  lda _var_expected_val
  ldx _var_expected_val+1
  jsr write_u16_ln
  jsr print_actual
  lda _var_actual_val
  ldx _var_actual_val+1
  jsr write_u16_ln
_endif_1:
  rts

; Procedure: print_results
print_results:
  lda #13
  jsr $ffd2  ; CHROUT
  lda #45
  jsr $ffd2  ; CHROUT
  lda #45
  jsr $ffd2  ; CHROUT
  lda #45
  jsr $ffd2  ; CHROUT
  lda #45
  jsr $ffd2  ; CHROUT
  lda #45
  jsr $ffd2  ; CHROUT
  lda #45
  jsr $ffd2  ; CHROUT
  lda #45
  jsr $ffd2  ; CHROUT
  lda #45
  jsr $ffd2  ; CHROUT
  lda #13
  jsr $ffd2  ; CHROUT
  rts

; Procedure: print_passed_label
print_passed_label:
  lda #80
  jsr $ffd2  ; CHROUT
  lda #65
  jsr $ffd2  ; CHROUT
  lda #83
  jsr $ffd2  ; CHROUT
  lda #83
  jsr $ffd2  ; CHROUT
  lda #69
  jsr $ffd2  ; CHROUT
  lda #68
  jsr $ffd2  ; CHROUT
  lda #58
  jsr $ffd2  ; CHROUT
  lda #32
  jsr $ffd2  ; CHROUT
  rts

; Procedure: print_failed_label
print_failed_label:
  lda #70
  jsr $ffd2  ; CHROUT
  lda #65
  jsr $ffd2  ; CHROUT
  lda #73
  jsr $ffd2  ; CHROUT
  lda #76
  jsr $ffd2  ; CHROUT
  lda #69
  jsr $ffd2  ; CHROUT
  lda #68
  jsr $ffd2  ; CHROUT
  lda #58
  jsr $ffd2  ; CHROUT
  lda #32
  jsr $ffd2  ; CHROUT
  rts

; Procedure: test_summary
test_summary:
  jsr print_results
  jsr print_passed_label
  lda _var_pass_count
  ldx _var_pass_count+1
  jsr write_u16_ln
  jsr print_failed_label
  lda _var_fail_count
  ldx _var_fail_count+1
  jsr write_u16_ln
  rts

; Module: helper_module
; Procedure: set_value
set_value:
  lda #42
  ldx #0
  sta _var_shared_value
  stx _var_shared_value+1
  rts

; Procedure: double_value
double_value:
  lda _var_shared_value
  ldx _var_shared_value+1
  sta _tmp16
  stx _tmp16+1
  lda _var_shared_value
  ldx _var_shared_value+1
  clc
  adc _tmp16
  pha
  txa
  adc _tmp16+1
  tax
  pla
  sta _var_shared_value
  stx _var_shared_value+1
  rts

; Procedure: inc_counter
inc_counter:
  lda _var_counter
  ldx _var_counter+1
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
  sta _var_counter
  stx _var_counter+1
  rts

; Procedure: reset_counter
reset_counter:
  lda #0
  ldx #0
  sta _var_counter
  stx _var_counter+1
  rts

; Procedure: calc_sum_10
calc_sum_10:
  lda #0
  ldx #0
  sta _var_shared_value
  stx _var_shared_value+1
  lda #1
  sta _var_i
_for_2:
  lda _var_shared_value
  ldx _var_shared_value+1
  sta _tmp16
  stx _tmp16+1
  lda _var_i
  ldx #0
  clc
  adc _tmp16
  pha
  txa
  adc _tmp16+1
  tax
  pla
  sta _var_shared_value
  stx _var_shared_value+1
  inc _var_i
  lda _var_i
  cmp #11
  bne _for_2
  rts

; Main module: test_modules
; Procedure: main
main:
  jsr test_init
  jsr set_value
  lda #42
  ldx #0
  sta _var_expected_val
  stx _var_expected_val+1
  lda _var_shared_value
  ldx _var_shared_value+1
  sta _var_actual_val
  stx _var_actual_val+1
  jsr assert_eq
  jsr double_value
  lda #84
  ldx #0
  sta _var_expected_val
  stx _var_expected_val+1
  lda _var_shared_value
  ldx _var_shared_value+1
  sta _var_actual_val
  stx _var_actual_val+1
  jsr assert_eq
  lda #100
  ldx #0
  sta _var_shared_value
  stx _var_shared_value+1
  lda #100
  ldx #0
  sta _var_expected_val
  stx _var_expected_val+1
  lda _var_shared_value
  ldx _var_shared_value+1
  sta _var_actual_val
  stx _var_actual_val+1
  jsr assert_eq
  jsr reset_counter
  lda #0
  ldx #0
  sta _var_expected_val
  stx _var_expected_val+1
  lda _var_counter
  ldx _var_counter+1
  sta _var_actual_val
  stx _var_actual_val+1
  jsr assert_eq
  jsr inc_counter
  lda #1
  ldx #0
  sta _var_expected_val
  stx _var_expected_val+1
  lda _var_counter
  ldx _var_counter+1
  sta _var_actual_val
  stx _var_actual_val+1
  jsr assert_eq
  jsr inc_counter
  jsr inc_counter
  jsr inc_counter
  lda #4
  ldx #0
  sta _var_expected_val
  stx _var_expected_val+1
  lda _var_counter
  ldx _var_counter+1
  sta _var_actual_val
  stx _var_actual_val+1
  jsr assert_eq
  jsr calc_sum_10
  lda #55
  ldx #0
  sta _var_expected_val
  stx _var_expected_val+1
  lda _var_shared_value
  ldx _var_shared_value+1
  sta _var_actual_val
  stx _var_actual_val+1
  jsr assert_eq
  lda #10
  ldx #0
  sta _var_shared_value
  stx _var_shared_value+1
  lda #5
  ldx #0
  sta _var_counter
  stx _var_counter+1
  lda _var_shared_value
  ldx _var_shared_value+1
  sta _tmp16
  stx _tmp16+1
  lda _var_counter
  ldx _var_counter+1
  clc
  adc _tmp16
  pha
  txa
  adc _tmp16+1
  tax
  pla
  sta _var_shared_value
  stx _var_shared_value+1
  lda #15
  ldx #0
  sta _var_expected_val
  stx _var_expected_val+1
  lda _var_shared_value
  ldx _var_shared_value+1
  sta _var_actual_val
  stx _var_actual_val+1
  jsr assert_eq
  lda #20
  ldx #0
  sta _var_shared_value
  stx _var_shared_value+1
  lda #60
  ldx #0
  sta _var_expected_val
  stx _var_expected_val+1
  lda _var_shared_value
  pha
  lda #3
  sta _tmp
  pla
  sta _mul_a
  lda _tmp
  sta _mul_b
  jsr _multiply
  ldx #0
  sta _var_actual_val
  stx _var_actual_val+1
  jsr assert_eq
  jsr set_value
  jsr double_value
  jsr double_value
  lda #168
  ldx #0
  sta _var_expected_val
  stx _var_expected_val+1
  lda _var_shared_value
  ldx _var_shared_value+1
  sta _var_actual_val
  stx _var_actual_val+1
  jsr assert_eq
  jsr test_summary
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
_var_test_count:
  .byte 0, 0
_var_pass_count:
  .byte 0, 0
_var_fail_count:
  .byte 0, 0
_var_current_test:
  .byte 0, 0
_var_expected_val:
  .byte 0, 0
_var_actual_val:
  .byte 0, 0
_var_shared_value:
  .byte 0, 0
_var_counter:
  .byte 0, 0
_var_i:
  .byte 0