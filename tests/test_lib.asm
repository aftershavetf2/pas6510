; pas6510 compiled program: test_lib
;

  .org $0801

; BASIC stub: 10 SYS 2061
  .byte $0b, $08, $0a, $00, $9e, $32, $30, $36, $31, $00, $00, $00

; Program start
start:
  jsr main
  rts

; Main module: test_lib
; Procedure: test_init
test_init:
  lda #0
  ldx #0
  sta _var_test_count
  stx _var_test_count+1
  sta _var_pass_count
  stx _var_pass_count+1
  sta _var_fail_count
  stx _var_fail_count+1
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
  cmp _var_actual_val
  beq _skip_2
  jmp _else_0
_skip_2:
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

; Procedure: main
main:
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