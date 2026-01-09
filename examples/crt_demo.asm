; pas6510 compiled program: crt_demo
;

  .org $0801

; BASIC stub: 10 SYS 2061
  .byte $0b, $08, $0a, $00, $9e, $32, $30, $36, $31, $00, $00, $00

; Program start
start:
  jsr main
  rts

; Module: crt
; Procedure: crt_init
crt_init:
  lda #0
  ldx #4
  sta _var_SCREEN_BASE
  stx _var_SCREEN_BASE+1
  lda #0
  ldx #216
  sta _var_COLOR_BASE
  stx _var_COLOR_BASE+1
  lda #40
  sta _var_SCREEN_WIDTH
  lda #25
  sta _var_SCREEN_HEIGHT
  lda #0
  sta _var_cursor_x
  lda #0
  sta _var_cursor_y
  lda #14
  sta _var_text_color
  rts

; Procedure: calc_addr
calc_addr:
  lda #0
  ldx #0
  sta _var_row_offset
  stx _var_row_offset+1
  lda _var_cursor_y
  sta _var_y_temp
_while_0:
  lda _var_y_temp
  pha
  lda #0
  sta _tmp
  pla
  cmp _tmp
  beq _gt_false_2
  bcs _gt_cont_3
_gt_false_2:
  jmp _endwhile_1
_gt_cont_3:
  lda _var_row_offset
  ldx _var_row_offset+1
  sta _tmp16
  stx _tmp16+1
  lda #40
  ldx #0
  clc
  adc _tmp16
  pha
  txa
  adc _tmp16+1
  tax
  pla
  sta _var_row_offset
  stx _var_row_offset+1
  lda _var_y_temp
  pha
  lda #1
  sta _tmp
  pla
  sec
  sbc _tmp
  sta _var_y_temp
  jmp _while_0
_endwhile_1:
  lda _var_SCREEN_BASE
  ldx _var_SCREEN_BASE+1
  sta _tmp16
  stx _tmp16+1
  lda _var_row_offset
  ldx _var_row_offset+1
  clc
  adc _tmp16
  pha
  txa
  adc _tmp16+1
  tax
  pla
  sta _tmp16
  stx _tmp16+1
  lda _var_cursor_x
  ldx #0
  clc
  adc _tmp16
  pha
  txa
  adc _tmp16+1
  tax
  pla
  sta _var_screen_addr
  stx _var_screen_addr+1
  rts

; Procedure: calc_color_addr
calc_color_addr:
  lda #0
  ldx #0
  sta _var_row_offset
  stx _var_row_offset+1
  lda _var_cursor_y
  sta _var_y_temp
_while_4:
  lda _var_y_temp
  pha
  lda #0
  sta _tmp
  pla
  cmp _tmp
  beq _gt_false_6
  bcs _gt_cont_7
_gt_false_6:
  jmp _endwhile_5
_gt_cont_7:
  lda _var_row_offset
  ldx _var_row_offset+1
  sta _tmp16
  stx _tmp16+1
  lda #40
  ldx #0
  clc
  adc _tmp16
  pha
  txa
  adc _tmp16+1
  tax
  pla
  sta _var_row_offset
  stx _var_row_offset+1
  lda _var_y_temp
  pha
  lda #1
  sta _tmp
  pla
  sec
  sbc _tmp
  sta _var_y_temp
  jmp _while_4
_endwhile_5:
  lda _var_COLOR_BASE
  ldx _var_COLOR_BASE+1
  sta _tmp16
  stx _tmp16+1
  lda _var_row_offset
  ldx _var_row_offset+1
  clc
  adc _tmp16
  pha
  txa
  adc _tmp16+1
  tax
  pla
  sta _tmp16
  stx _tmp16+1
  lda _var_cursor_x
  ldx #0
  clc
  adc _tmp16
  pha
  txa
  adc _tmp16+1
  tax
  pla
  sta _var_color_addr
  stx _var_color_addr+1
  rts

; Procedure: clear
clear:
  lda _var_SCREEN_BASE
  ldx _var_SCREEN_BASE+1
  sta _var_addr
  stx _var_addr+1
  lda _var_COLOR_BASE
  ldx _var_COLOR_BASE+1
  sta _var_caddr
  stx _var_caddr+1
  lda #0
  sta _var_row
_while_8:
  lda _var_row
  pha
  lda #25
  sta _tmp
  pla
  cmp _tmp
  bcc _skip_10
  jmp _endwhile_9
_skip_10:
  lda #0
  sta _var_col
_while_11:
  lda _var_col
  pha
  lda #40
  sta _tmp
  pla
  cmp _tmp
  bcc _skip_13
  jmp _endwhile_12
_skip_13:
  lda _var_addr
  ldx _var_addr+1
  sta _poke_addr
  stx _poke_addr+1
  lda #32
  ldy #0
  sta (_poke_addr),y
  lda _var_caddr
  ldx _var_caddr+1
  sta _poke_addr
  stx _poke_addr+1
  lda _var_text_color
  ldy #0
  sta (_poke_addr),y
  lda _var_addr
  ldx _var_addr+1
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
  sta _var_addr
  stx _var_addr+1
  lda _var_caddr
  ldx _var_caddr+1
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
  sta _var_caddr
  stx _var_caddr+1
  lda _var_col
  pha
  lda #1
  sta _tmp
  pla
  clc
  adc _tmp
  sta _var_col
  jmp _while_11
_endwhile_12:
  lda _var_row
  pha
  lda #1
  sta _tmp
  pla
  clc
  adc _tmp
  sta _var_row
  jmp _while_8
_endwhile_9:
  lda #0
  sta _var_cursor_x
  lda #0
  sta _var_cursor_y
  rts

; Procedure: gotoxy
gotoxy:
  lda _var_param_x
  sta _var_cursor_x
  lda _var_param_y
  sta _var_cursor_y
  rts

; Procedure: newline
newline:
  lda #0
  sta _var_cursor_x
  lda _var_cursor_y
  pha
  lda #1
  sta _tmp
  pla
  clc
  adc _tmp
  sta _var_cursor_y
  lda _var_cursor_y
  pha
  lda _var_SCREEN_HEIGHT
  sta _tmp
  pla
  cmp _tmp
  bcs _skip_16
  jmp _else_14
_skip_16:
  lda #0
  sta _var_cursor_y
_else_14:
  rts

; Procedure: putch
putch:
  jsr calc_addr
  jsr calc_color_addr
  lda _var_screen_addr
  ldx _var_screen_addr+1
  sta _poke_addr
  stx _poke_addr+1
  lda _var_param_ch
  ldy #0
  sta (_poke_addr),y
  lda _var_color_addr
  ldx _var_color_addr+1
  sta _poke_addr
  stx _poke_addr+1
  lda _var_text_color
  ldy #0
  sta (_poke_addr),y
  lda _var_cursor_x
  pha
  lda #1
  sta _tmp
  pla
  clc
  adc _tmp
  sta _var_cursor_x
  lda _var_cursor_x
  pha
  lda _var_SCREEN_WIDTH
  sta _tmp
  pla
  cmp _tmp
  bcs _skip_19
  jmp _else_17
_skip_19:
  jsr newline
_else_17:
  rts

; Procedure: putc
putc:
  lda _var_param_ch
  pha
  lda #65
  sta _tmp
  pla
  cmp _tmp
  bcs _skip_22
  jmp _else_20
_skip_22:
  lda _var_param_ch
  pha
  lda #90
  sta _tmp
  pla
  cmp _tmp
  beq _le_cont_26
  bcc _le_cont_26
  jmp _else_23
_le_cont_26:
  lda _var_param_ch
  pha
  lda #64
  sta _tmp
  pla
  sec
  sbc _tmp
  sta _var_param_ch
  jsr putch
  rts
_else_23:
_else_20:
  lda _var_param_ch
  pha
  lda #97
  sta _tmp
  pla
  cmp _tmp
  bcs _skip_29
  jmp _else_27
_skip_29:
  lda _var_param_ch
  pha
  lda #122
  sta _tmp
  pla
  cmp _tmp
  beq _le_cont_33
  bcc _le_cont_33
  jmp _else_30
_le_cont_33:
  lda _var_param_ch
  pha
  lda #96
  sta _tmp
  pla
  sec
  sbc _tmp
  sta _var_param_ch
  jsr putch
  rts
_else_30:
_else_27:
  jsr putch
  rts

; Procedure: setcolor
setcolor:
  lda _var_param_color
  sta _var_text_color
  rts

; Procedure: hline
hline:
  lda #0
  sta _var_i
_while_34:
  lda _var_i
  pha
  lda _var_param_len
  sta _tmp
  pla
  cmp _tmp
  bcc _skip_36
  jmp _endwhile_35
_skip_36:
  jsr putch
  lda _var_i
  pha
  lda #1
  sta _tmp
  pla
  clc
  adc _tmp
  sta _var_i
  jmp _while_34
_endwhile_35:
  rts

; Procedure: fillrect
fillrect:
  lda _var_param_x
  sta _var_start_x
  lda _var_param_y
  sta _var_start_y
  lda #0
  sta _var_row
_while_37:
  lda _var_row
  pha
  lda _var_param_h
  sta _tmp
  pla
  cmp _tmp
  bcc _skip_39
  jmp _endwhile_38
_skip_39:
  lda _var_start_x
  sta _var_cursor_x
  lda _var_start_y
  pha
  lda _var_row
  sta _tmp
  pla
  clc
  adc _tmp
  sta _var_cursor_y
  lda #0
  sta _var_col
_while_40:
  lda _var_col
  pha
  lda _var_param_w
  sta _tmp
  pla
  cmp _tmp
  bcc _skip_42
  jmp _endwhile_41
_skip_42:
  jsr calc_addr
  jsr calc_color_addr
  lda _var_screen_addr
  ldx _var_screen_addr+1
  sta _poke_addr
  stx _poke_addr+1
  lda _var_param_ch
  ldy #0
  sta (_poke_addr),y
  lda _var_color_addr
  ldx _var_color_addr+1
  sta _poke_addr
  stx _poke_addr+1
  lda _var_text_color
  ldy #0
  sta (_poke_addr),y
  lda _var_cursor_x
  pha
  lda #1
  sta _tmp
  pla
  clc
  adc _tmp
  sta _var_cursor_x
  lda _var_col
  pha
  lda #1
  sta _tmp
  pla
  clc
  adc _tmp
  sta _var_col
  jmp _while_40
_endwhile_41:
  lda _var_row
  pha
  lda #1
  sta _tmp
  pla
  clc
  adc _tmp
  sta _var_row
  jmp _while_37
_endwhile_38:
  rts

; Procedure: box
box:
  lda _var_param_x
  sta _var_bx
  lda _var_param_y
  sta _var_by
  lda _var_param_w
  sta _var_bw
  lda _var_param_h
  sta _var_bh
  lda _var_bx
  sta _var_cursor_x
  lda _var_by
  sta _var_cursor_y
  lda #112
  sta _var_param_ch
  jsr putch
  lda #2
  sta _var_i
_while_43:
  lda _var_i
  pha
  lda _var_bw
  sta _tmp
  pla
  cmp _tmp
  bcc _skip_45
  jmp _endwhile_44
_skip_45:
  lda #64
  sta _var_param_ch
  jsr putch
  lda _var_i
  pha
  lda #1
  sta _tmp
  pla
  clc
  adc _tmp
  sta _var_i
  jmp _while_43
_endwhile_44:
  lda #110
  sta _var_param_ch
  jsr putch
  lda #1
  sta _var_i
_while_46:
  lda _var_i
  pha
  lda _var_bh
  pha
  lda #1
  sta _tmp
  pla
  sec
  sbc _tmp
  sta _tmp
  pla
  cmp _tmp
  bcc _skip_48
  jmp _endwhile_47
_skip_48:
  lda _var_bx
  sta _var_cursor_x
  lda _var_by
  pha
  lda _var_i
  sta _tmp
  pla
  clc
  adc _tmp
  sta _var_cursor_y
  lda #93
  sta _var_param_ch
  jsr putch
  lda _var_bx
  pha
  lda _var_bw
  sta _tmp
  pla
  clc
  adc _tmp
  pha
  lda #1
  sta _tmp
  pla
  sec
  sbc _tmp
  sta _var_cursor_x
  jsr putch
  lda _var_i
  pha
  lda #1
  sta _tmp
  pla
  clc
  adc _tmp
  sta _var_i
  jmp _while_46
_endwhile_47:
  lda _var_bx
  sta _var_cursor_x
  lda _var_by
  pha
  lda _var_bh
  sta _tmp
  pla
  clc
  adc _tmp
  pha
  lda #1
  sta _tmp
  pla
  sec
  sbc _tmp
  sta _var_cursor_y
  lda #109
  sta _var_param_ch
  jsr putch
  lda #2
  sta _var_i
_while_49:
  lda _var_i
  pha
  lda _var_bw
  sta _tmp
  pla
  cmp _tmp
  bcc _skip_51
  jmp _endwhile_50
_skip_51:
  lda #64
  sta _var_param_ch
  jsr putch
  lda _var_i
  pha
  lda #1
  sta _tmp
  pla
  clc
  adc _tmp
  sta _var_i
  jmp _while_49
_endwhile_50:
  lda #125
  sta _var_param_ch
  jsr putch
  rts

; Procedure: putnum
putnum:
  lda _var_param_num
  pha
  lda #0
  sta _tmp
  pla
  cmp _tmp
  beq _skip_54
  jmp _else_52
_skip_54:
  lda #48
  sta _var_param_ch
  jsr putch
  rts
_else_52:
  lda #0
  sta _var_count
  lda _var_param_num
  ldx _var_param_num+1
  sta _var_temp
  stx _var_temp+1
_while_55:
  lda _var_temp
  pha
  lda #0
  sta _tmp
  pla
  cmp _tmp
  beq _gt_false_57
  bcs _gt_cont_58
_gt_false_57:
  jmp _endwhile_56
_gt_cont_58:
  lda _var_temp
  pha
  lda _var_temp
  pha
  lda #10
  sta _tmp
  pla
  sta _div_a
  lda _tmp
  sta _div_b
  jsr _divide
  pha
  lda #10
  sta _tmp
  pla
  sta _mul_a
  lda _tmp
  sta _mul_b
  jsr _multiply
  sta _tmp
  pla
  sec
  sbc _tmp
  sta _var_digit
  lda _var_count
  tay
  lda _var_digit
  pha
  lda #48
  sta _tmp
  pla
  clc
  adc _tmp
  sta _var_digits,y
  lda _var_temp
  pha
  lda #10
  sta _tmp
  pla
  sta _div_a
  lda _tmp
  sta _div_b
  jsr _divide
  ldx #0
  sta _var_temp
  stx _var_temp+1
  lda _var_count
  pha
  lda #1
  sta _tmp
  pla
  clc
  adc _tmp
  sta _var_count
  jmp _while_55
_endwhile_56:
_while_59:
  lda _var_count
  pha
  lda #0
  sta _tmp
  pla
  cmp _tmp
  beq _gt_false_61
  bcs _gt_cont_62
_gt_false_61:
  jmp _endwhile_60
_gt_cont_62:
  lda _var_count
  pha
  lda #1
  sta _tmp
  pla
  sec
  sbc _tmp
  sta _var_count
  lda _var_count
  tay
  lda _var_digits,y
  sta _var_param_ch
  jsr putch
  jmp _while_59
_endwhile_60:
  rts

; Main module: crt_demo
; Procedure: print_hello
print_hello:
  lda #72
  sta _var_param_ch
  jsr putc
  lda #69
  sta _var_param_ch
  jsr putc
  lda #76
  sta _var_param_ch
  jsr putc
  lda #76
  sta _var_param_ch
  jsr putc
  lda #79
  sta _var_param_ch
  jsr putc
  lda #32
  sta _var_param_ch
  jsr putc
  lda #87
  sta _var_param_ch
  jsr putc
  lda #79
  sta _var_param_ch
  jsr putc
  lda #82
  sta _var_param_ch
  jsr putc
  lda #76
  sta _var_param_ch
  jsr putc
  lda #68
  sta _var_param_ch
  jsr putc
  rts

; Procedure: print_pas6510
print_pas6510:
  lda #80
  sta _var_param_ch
  jsr putc
  lda #65
  sta _var_param_ch
  jsr putc
  lda #83
  sta _var_param_ch
  jsr putc
  lda #54
  sta _var_param_ch
  jsr putc
  lda #53
  sta _var_param_ch
  jsr putc
  lda #49
  sta _var_param_ch
  jsr putc
  lda #48
  sta _var_param_ch
  jsr putc
  lda #32
  sta _var_param_ch
  jsr putc
  lda #67
  sta _var_param_ch
  jsr putc
  lda #82
  sta _var_param_ch
  jsr putc
  lda #84
  sta _var_param_ch
  jsr putc
  lda #32
  sta _var_param_ch
  jsr putc
  lda #68
  sta _var_param_ch
  jsr putc
  lda #69
  sta _var_param_ch
  jsr putc
  lda #77
  sta _var_param_ch
  jsr putc
  lda #79
  sta _var_param_ch
  jsr putc
  rts

; Procedure: print_number_label
print_number_label:
  lda #78
  sta _var_param_ch
  jsr putc
  lda #85
  sta _var_param_ch
  jsr putc
  lda #77
  sta _var_param_ch
  jsr putc
  lda #66
  sta _var_param_ch
  jsr putc
  lda #69
  sta _var_param_ch
  jsr putc
  lda #82
  sta _var_param_ch
  jsr putc
  lda #58
  sta _var_param_ch
  jsr putc
  lda #32
  sta _var_param_ch
  jsr putc
  rts

; Procedure: print_red
print_red:
  lda #82
  sta _var_param_ch
  jsr putc
  lda #69
  sta _var_param_ch
  jsr putc
  lda #68
  sta _var_param_ch
  jsr putc
  lda #32
  sta _var_param_ch
  jsr putc
  rts

; Procedure: print_green
print_green:
  lda #71
  sta _var_param_ch
  jsr putc
  lda #82
  sta _var_param_ch
  jsr putc
  lda #69
  sta _var_param_ch
  jsr putc
  lda #69
  sta _var_param_ch
  jsr putc
  lda #78
  sta _var_param_ch
  jsr putc
  lda #32
  sta _var_param_ch
  jsr putc
  rts

; Procedure: print_blue
print_blue:
  lda #66
  sta _var_param_ch
  jsr putc
  lda #76
  sta _var_param_ch
  jsr putc
  lda #85
  sta _var_param_ch
  jsr putc
  lda #69
  sta _var_param_ch
  jsr putc
  rts

; Procedure: main
main:
  jsr crt_init
  jsr clear
  lda #3
  sta _var_param_color
  jsr setcolor
  lda #5
  sta _var_param_x
  lda #2
  sta _var_param_y
  lda #30
  sta _var_param_w
  lda #10
  sta _var_param_h
  jsr box
  lda #1
  sta _var_param_color
  jsr setcolor
  lda #14
  sta _var_param_x
  lda #4
  sta _var_param_y
  jsr gotoxy
  jsr print_hello
  lda #7
  sta _var_param_color
  jsr setcolor
  lda #8
  sta _var_param_x
  lda #6
  sta _var_param_y
  jsr gotoxy
  jsr print_number_label
  lda #57
  ldx #48
  sta _var_param_num
  stx _var_param_num+1
  jsr putnum
  lda #8
  sta _var_param_x
  lda #8
  sta _var_param_y
  jsr gotoxy
  lda #2
  sta _var_param_color
  jsr setcolor
  jsr print_red
  lda #5
  sta _var_param_color
  jsr setcolor
  jsr print_green
  lda #6
  sta _var_param_color
  jsr setcolor
  jsr print_blue
  lda #14
  sta _var_param_color
  jsr setcolor
  lda #0
  sta _var_param_x
  lda #20
  sta _var_param_y
  jsr gotoxy
  lda #64
  sta _var_param_ch
  lda #40
  sta _var_param_len
  jsr hline
  lda #12
  sta _var_param_x
  lda #22
  sta _var_param_y
  jsr gotoxy
  jsr print_pas6510
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
_var_SCREEN_BASE:
  .byte 0, 0
_var_COLOR_BASE:
  .byte 0, 0
_var_SCREEN_WIDTH:
  .byte 0
_var_SCREEN_HEIGHT:
  .byte 0
_var_cursor_x:
  .byte 0
_var_cursor_y:
  .byte 0
_var_text_color:
  .byte 0
_var_param_x:
  .byte 0
_var_param_y:
  .byte 0
_var_param_w:
  .byte 0
_var_param_h:
  .byte 0
_var_param_ch:
  .byte 0
_var_param_len:
  .byte 0
_var_param_color:
  .byte 0
_var_param_num:
  .byte 0, 0
_var_screen_addr:
  .byte 0, 0
_var_color_addr:
  .byte 0, 0
_var_row_offset:
  .byte 0, 0
_var_y_temp:
  .byte 0
_var_row:
  .byte 0
_var_col:
  .byte 0
_var_addr:
  .byte 0, 0
_var_caddr:
  .byte 0, 0
_var_sc:
  .byte 0
_var_i:
  .byte 0
_var_start_x:
  .byte 0
_var_start_y:
  .byte 0
_var_bx:
  .byte 0
_var_by:
  .byte 0
_var_bw:
  .byte 0
_var_bh:
  .byte 0
_var_digits:
  .byte 0, 0, 0, 0, 0, 0
_var_count:
  .byte 0
_var_temp:
  .byte 0, 0
_var_digit:
  .byte 0