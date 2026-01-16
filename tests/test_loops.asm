; pas6510 compiled program: test_loops
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
test_lib_test_init:
  lda #0
  ldx #0
  sta _var_test_lib_test_count
  stx _var_test_lib_test_count+1
  sta _var_test_lib_pass_count
  stx _var_test_lib_pass_count+1
  sta _var_test_lib_fail_count
  stx _var_test_lib_fail_count+1
  sta _var_test_lib_current_test
  stx _var_test_lib_current_test+1
  rts

; Procedure: print_test
test_lib_print_test:
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
test_lib_print_pass:
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
test_lib_print_fail:
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
test_lib_print_expected:
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
test_lib_print_actual:
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
test_lib_assert_eq:
  lda _var_test_lib_test_count
  ldx _var_test_lib_test_count+1
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
  sta _var_test_lib_test_count
  stx _var_test_lib_test_count+1
  lda _var_test_lib_test_count
  ldx _var_test_lib_test_count+1
  sta _var_test_lib_current_test
  stx _var_test_lib_current_test+1
  jsr test_lib_print_test
  lda _var_test_lib_current_test
  ldx _var_test_lib_current_test+1
  jsr write_u16_ln
  lda _var_test_lib_expected_val
  cmp _var_test_lib_actual_val
  beq _skip_2
  jmp _else_0
_skip_2:
  lda _var_test_lib_pass_count
  ldx _var_test_lib_pass_count+1
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
  sta _var_test_lib_pass_count
  stx _var_test_lib_pass_count+1
  jsr test_lib_print_pass
  jmp _endif_1
_else_0:
  lda _var_test_lib_fail_count
  ldx _var_test_lib_fail_count+1
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
  sta _var_test_lib_fail_count
  stx _var_test_lib_fail_count+1
  jsr test_lib_print_fail
  jsr test_lib_print_expected
  lda _var_test_lib_expected_val
  ldx _var_test_lib_expected_val+1
  jsr write_u16_ln
  jsr test_lib_print_actual
  lda _var_test_lib_actual_val
  ldx _var_test_lib_actual_val+1
  jsr write_u16_ln
_endif_1:
  rts

; Procedure: print_results
test_lib_print_results:
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
test_lib_print_passed_label:
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
test_lib_print_failed_label:
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
test_lib_test_summary:
  jsr test_lib_print_results
  jsr test_lib_print_passed_label
  lda _var_test_lib_pass_count
  ldx _var_test_lib_pass_count+1
  jsr write_u16_ln
  jsr test_lib_print_failed_label
  lda _var_test_lib_fail_count
  ldx _var_test_lib_fail_count+1
  jsr write_u16_ln
  rts

; Main module: test_loops
; Procedure: main
main:
  jsr test_lib_test_init
  lda #0
  ldx #0
  sta _var_main_sum
  stx _var_main_sum+1
  lda #1
  sta _var_main_i
_for_3:
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
  lda _var_main_i
  cmp #11
  beq _endfor_4
  jmp _for_3
_endfor_4:
  lda #55
  ldx #0
  sta _var_test_lib_expected_val
  stx _var_test_lib_expected_val+1
  lda _var_main_sum
  ldx _var_main_sum+1
  sta _var_test_lib_actual_val
  stx _var_test_lib_actual_val+1
  jsr test_lib_assert_eq
  lda #0
  ldx #0
  sta _var_main_count
  stx _var_main_count+1
  sta _var_main_i
_for_5:
  lda _var_main_count
  ldx _var_main_count+1
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
  sta _var_main_count
  stx _var_main_count+1
  inc _var_main_i
  lda _var_main_i
  cmp #5
  beq _endfor_6
  jmp _for_5
_endfor_6:
  lda #5
  ldx #0
  sta _var_test_lib_expected_val
  stx _var_test_lib_expected_val+1
  lda _var_main_count
  ldx _var_main_count+1
  sta _var_test_lib_actual_val
  stx _var_test_lib_actual_val+1
  jsr test_lib_assert_eq
  lda #0
  ldx #0
  sta _var_main_sum
  stx _var_main_sum+1
  lda #1
  sta _var_main_i
_while_7:
  lda _var_main_i
  cmp #5
  beq _le_cont_10
  bcc _le_cont_10
  jmp _endwhile_8
_le_cont_10:
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
  lda _var_main_i
  pha
  lda #1
  sta _tmp
  pla
  clc
  adc _tmp
  sta _var_main_i
  jmp _while_7
_endwhile_8:
  lda #15
  ldx #0
  sta _var_test_lib_expected_val
  stx _var_test_lib_expected_val+1
  lda _var_main_sum
  ldx _var_main_sum+1
  sta _var_test_lib_actual_val
  stx _var_test_lib_actual_val+1
  jsr test_lib_assert_eq
  lda #0
  ldx #0
  sta _var_main_sum
  stx _var_main_sum+1
  lda #5
  cmp #3
  beq _gt_false_13
  bcs _gt_cont_14
_gt_false_13:
  jmp _else_11
_gt_cont_14:
  lda #100
  ldx #0
  sta _var_main_sum
  stx _var_main_sum+1
_else_11:
  lda #100
  ldx #0
  sta _var_test_lib_expected_val
  stx _var_test_lib_expected_val+1
  lda _var_main_sum
  ldx _var_main_sum+1
  sta _var_test_lib_actual_val
  stx _var_test_lib_actual_val+1
  jsr test_lib_assert_eq
  lda #10
  cmp #10
  beq _skip_17
  jmp _else_15
_skip_17:
  lda #200
  ldx #0
  sta _var_main_sum
  stx _var_main_sum+1
  jmp _endif_16
_else_15:
  lda #44
  ldx #1
  sta _var_main_sum
  stx _var_main_sum+1
_endif_16:
  lda #200
  ldx #0
  sta _var_test_lib_expected_val
  stx _var_test_lib_expected_val+1
  lda _var_main_sum
  ldx _var_main_sum+1
  sta _var_test_lib_actual_val
  stx _var_test_lib_actual_val+1
  jsr test_lib_assert_eq
  lda #10
  cmp #20
  beq _skip_20
  jmp _else_18
_skip_20:
  lda #144
  ldx #1
  sta _var_main_sum
  stx _var_main_sum+1
  jmp _endif_19
_else_18:
  lda #244
  ldx #1
  sta _var_main_sum
  stx _var_main_sum+1
_endif_19:
  lda #244
  ldx #1
  sta _var_test_lib_expected_val
  stx _var_test_lib_expected_val+1
  lda _var_main_sum
  ldx _var_main_sum+1
  sta _var_test_lib_actual_val
  stx _var_test_lib_actual_val+1
  jsr test_lib_assert_eq
  lda #0
  ldx #0
  sta _var_main_sum
  stx _var_main_sum+1
  lda #3
  cmp #5
  bcc _skip_23
  jmp _else_21
_skip_23:
  lda #1
  ldx #0
  sta _var_main_sum
  stx _var_main_sum+1
_else_21:
  lda #1
  ldx #0
  sta _var_test_lib_expected_val
  stx _var_test_lib_expected_val+1
  lda _var_main_sum
  ldx _var_main_sum+1
  sta _var_test_lib_actual_val
  stx _var_test_lib_actual_val+1
  jsr test_lib_assert_eq
  lda #0
  ldx #0
  sta _var_main_sum
  stx _var_main_sum+1
  lda #8
  cmp #4
  beq _gt_false_26
  bcs _gt_cont_27
_gt_false_26:
  jmp _else_24
_gt_cont_27:
  lda #1
  ldx #0
  sta _var_main_sum
  stx _var_main_sum+1
_else_24:
  lda #1
  ldx #0
  sta _var_test_lib_expected_val
  stx _var_test_lib_expected_val+1
  lda _var_main_sum
  ldx _var_main_sum+1
  sta _var_test_lib_actual_val
  stx _var_test_lib_actual_val+1
  jsr test_lib_assert_eq
  lda #0
  ldx #0
  sta _var_main_sum
  stx _var_main_sum+1
  lda #5
  cmp #3
  bne _skip_30
  jmp _else_28
_skip_30:
  lda #1
  ldx #0
  sta _var_main_sum
  stx _var_main_sum+1
_else_28:
  lda #1
  ldx #0
  sta _var_test_lib_expected_val
  stx _var_test_lib_expected_val+1
  lda _var_main_sum
  ldx _var_main_sum+1
  sta _var_test_lib_actual_val
  stx _var_test_lib_actual_val+1
  jsr test_lib_assert_eq
  lda #0
  ldx #0
  sta _var_main_sum
  stx _var_main_sum+1
  lda #1
  sta _var_main_i
_for_31:
  lda #0
  ldx #0
  sta _var_main_count
  stx _var_main_count+1
_while_33:
  lda _var_main_count
  cmp #2
  bcc _skip_35
  jmp _endwhile_34
_skip_35:
  lda _var_main_sum
  ldx _var_main_sum+1
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
  sta _var_main_sum
  stx _var_main_sum+1
  lda _var_main_count
  ldx _var_main_count+1
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
  sta _var_main_count
  stx _var_main_count+1
  jmp _while_33
_endwhile_34:
  inc _var_main_i
  lda _var_main_i
  cmp #4
  beq _endfor_32
  jmp _for_31
_endfor_32:
  lda #6
  ldx #0
  sta _var_test_lib_expected_val
  stx _var_test_lib_expected_val+1
  lda _var_main_sum
  ldx _var_main_sum+1
  sta _var_test_lib_actual_val
  stx _var_test_lib_actual_val+1
  jsr test_lib_assert_eq
  jsr test_lib_test_summary
  rts


; Runtime library

_tmp: .byte 0, 0
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
_var_test_lib_test_count:
  .byte 0, 0
_var_test_lib_pass_count:
  .byte 0, 0
_var_test_lib_fail_count:
  .byte 0, 0
_var_test_lib_current_test:
  .byte 0, 0
_var_test_lib_expected_val:
  .byte 0, 0
_var_test_lib_actual_val:
  .byte 0, 0
_var_main_i:
  .byte 0
_var_main_sum:
  .byte 0, 0
_var_main_count:
  .byte 0, 0