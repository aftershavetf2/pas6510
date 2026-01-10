; pas6510 compiled program: crt_bench
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
  sta _var_calc_addr_row_offset
  stx _var_calc_addr_row_offset+1
  lda _var_cursor_y
  sta _var_calc_addr_y_temp
_while_0:
  lda _var_calc_addr_y_temp
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
  lda _var_calc_addr_row_offset
  ldx _var_calc_addr_row_offset+1
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
  sta _var_calc_addr_row_offset
  stx _var_calc_addr_row_offset+1
  dec _var_calc_addr_y_temp
  jmp _while_0
_endwhile_1:
  lda #0
  ldx #4
  sta _tmp16
  stx _tmp16+1
  lda _var_calc_addr_row_offset
  ldx _var_calc_addr_row_offset+1
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
  sta _var_calc_color_addr_row_offset
  stx _var_calc_color_addr_row_offset+1
  lda _var_cursor_y
  sta _var_calc_color_addr_y_temp
_while_4:
  lda _var_calc_color_addr_y_temp
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
  lda _var_calc_color_addr_row_offset
  ldx _var_calc_color_addr_row_offset+1
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
  sta _var_calc_color_addr_row_offset
  stx _var_calc_color_addr_row_offset+1
  dec _var_calc_color_addr_y_temp
  jmp _while_4
_endwhile_5:
  lda #0
  ldx #216
  sta _tmp16
  stx _tmp16+1
  lda _var_calc_color_addr_row_offset
  ldx _var_calc_color_addr_row_offset+1
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
  lda #0
  ldx #4
  sta _var_clear_addr
  stx _var_clear_addr+1
  lda #0
  ldx #216
  sta _var_clear_caddr
  stx _var_clear_caddr+1
  lda #0
  sta _var_clear_row
_while_8:
  lda _var_clear_row
  pha
  lda #25
  sta _tmp
  pla
  cmp _tmp
  bcc _skip_10
  jmp _endwhile_9
_skip_10:
  lda #0
  sta _var_clear_col
_while_11:
  lda _var_clear_col
  pha
  lda #40
  sta _tmp
  pla
  cmp _tmp
  bcc _skip_13
  jmp _endwhile_12
_skip_13:
  lda _var_clear_addr
  ldx _var_clear_addr+1
  sta _poke_addr
  stx _poke_addr+1
  lda #32
  ldy #0
  sta (_poke_addr),y
  lda _var_clear_caddr
  ldx _var_clear_caddr+1
  sta _poke_addr
  stx _poke_addr+1
  lda _var_text_color
  ldy #0
  sta (_poke_addr),y
  inc _var_clear_addr
  bne _inc16_14
  inc _var_clear_addr+1
_inc16_14:
  inc _var_clear_caddr
  bne _inc16_15
  inc _var_clear_caddr+1
_inc16_15:
  inc _var_clear_col
  jmp _while_11
_endwhile_12:
  inc _var_clear_row
  jmp _while_8
_endwhile_9:
  lda #0
  sta _var_cursor_x
  lda #0
  sta _var_cursor_y
  rts

; Procedure: gotoxy
gotoxy:
  lda _var_gotoxy_x
  sta _var_cursor_x
  lda _var_gotoxy_y
  sta _var_cursor_y
  rts

; Procedure: newline
newline:
  lda #0
  sta _var_cursor_x
  inc _var_cursor_y
  lda _var_cursor_y
  pha
  lda #25
  sta _tmp
  pla
  cmp _tmp
  bcs _skip_18
  jmp _else_16
_skip_18:
  lda #0
  sta _var_cursor_y
_else_16:
  rts

; Procedure: putch
putch:
  jsr calc_addr
  jsr calc_color_addr
  lda _var_screen_addr
  ldx _var_screen_addr+1
  sta _poke_addr
  stx _poke_addr+1
  lda _var_putch_ch
  ldy #0
  sta (_poke_addr),y
  lda _var_color_addr
  ldx _var_color_addr+1
  sta _poke_addr
  stx _poke_addr+1
  lda _var_text_color
  ldy #0
  sta (_poke_addr),y
  inc _var_cursor_x
  lda _var_cursor_x
  pha
  lda #40
  sta _tmp
  pla
  cmp _tmp
  bcs _skip_21
  jmp _else_19
_skip_21:
  jsr newline
_else_19:
  rts

; Procedure: putc
putc:
  lda _var_putc_ch
  sta _var_putc_sc
  lda _var_putc_sc
  pha
  lda #65
  sta _tmp
  pla
  cmp _tmp
  bcs _skip_24
  jmp _else_22
_skip_24:
  lda _var_putc_sc
  pha
  lda #90
  sta _tmp
  pla
  cmp _tmp
  beq _le_cont_28
  bcc _le_cont_28
  jmp _else_25
_le_cont_28:
  lda _var_putc_sc
  pha
  lda #64
  sta _tmp
  pla
  sec
  sbc _tmp
  sta _var_putch_ch
  jsr putch
  rts
_else_25:
_else_22:
  lda _var_putc_sc
  pha
  lda #97
  sta _tmp
  pla
  cmp _tmp
  bcs _skip_31
  jmp _else_29
_skip_31:
  lda _var_putc_sc
  pha
  lda #122
  sta _tmp
  pla
  cmp _tmp
  beq _le_cont_35
  bcc _le_cont_35
  jmp _else_32
_le_cont_35:
  lda _var_putc_sc
  pha
  lda #96
  sta _tmp
  pla
  sec
  sbc _tmp
  sta _var_putch_ch
  jsr putch
  rts
_else_32:
_else_29:
  lda _var_putc_sc
  sta _var_putch_ch
  jsr putch
  rts

; Procedure: setcolor
setcolor:
  lda _var_setcolor_c
  sta _var_text_color
  rts

; Procedure: hline
hline:
  lda #0
  sta _var_hline_i
_while_36:
  lda _var_hline_i
  pha
  lda _var_hline_len
  sta _tmp
  pla
  cmp _tmp
  bcc _skip_38
  jmp _endwhile_37
_skip_38:
  lda _var_hline_ch
  sta _var_putch_ch
  jsr putch
  inc _var_hline_i
  jmp _while_36
_endwhile_37:
  rts

; Procedure: fillrect
fillrect:
  lda _var_fillrect_x
  sta _var_fillrect_start_x
  lda _var_fillrect_y
  sta _var_fillrect_start_y
  lda #0
  sta _var_fillrect_row
_while_39:
  lda _var_fillrect_row
  pha
  lda _var_fillrect_h
  sta _tmp
  pla
  cmp _tmp
  bcc _skip_41
  jmp _endwhile_40
_skip_41:
  lda _var_fillrect_start_x
  sta _var_cursor_x
  lda _var_fillrect_start_y
  pha
  lda _var_fillrect_row
  sta _tmp
  pla
  clc
  adc _tmp
  sta _var_cursor_y
  lda #0
  sta _var_fillrect_col
_while_42:
  lda _var_fillrect_col
  pha
  lda _var_fillrect_w
  sta _tmp
  pla
  cmp _tmp
  bcc _skip_44
  jmp _endwhile_43
_skip_44:
  jsr calc_addr
  jsr calc_color_addr
  lda _var_screen_addr
  ldx _var_screen_addr+1
  sta _poke_addr
  stx _poke_addr+1
  lda _var_fillrect_ch
  ldy #0
  sta (_poke_addr),y
  lda _var_color_addr
  ldx _var_color_addr+1
  sta _poke_addr
  stx _poke_addr+1
  lda _var_text_color
  ldy #0
  sta (_poke_addr),y
  inc _var_cursor_x
  inc _var_fillrect_col
  jmp _while_42
_endwhile_43:
  inc _var_fillrect_row
  jmp _while_39
_endwhile_40:
  rts

; Procedure: box
box:
  lda _var_box_x
  sta _var_cursor_x
  lda _var_box_y
  sta _var_cursor_y
  lda #112
  sta _var_putch_ch
  jsr putch
  lda #2
  sta _var_box_i
_while_45:
  lda _var_box_i
  pha
  lda _var_box_w
  sta _tmp
  pla
  cmp _tmp
  bcc _skip_47
  jmp _endwhile_46
_skip_47:
  lda #64
  sta _var_putch_ch
  jsr putch
  inc _var_box_i
  jmp _while_45
_endwhile_46:
  lda #110
  sta _var_putch_ch
  jsr putch
  lda #1
  sta _var_box_i
_while_48:
  lda _var_box_i
  pha
  lda _var_box_h
  pha
  lda #1
  sta _tmp
  pla
  sec
  sbc _tmp
  sta _tmp
  pla
  cmp _tmp
  bcc _skip_50
  jmp _endwhile_49
_skip_50:
  lda _var_box_x
  sta _var_cursor_x
  lda _var_box_y
  pha
  lda _var_box_i
  sta _tmp
  pla
  clc
  adc _tmp
  sta _var_cursor_y
  lda #93
  sta _var_putch_ch
  jsr putch
  lda _var_box_x
  pha
  lda _var_box_w
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
  lda #93
  sta _var_putch_ch
  jsr putch
  inc _var_box_i
  jmp _while_48
_endwhile_49:
  lda _var_box_x
  sta _var_cursor_x
  lda _var_box_y
  pha
  lda _var_box_h
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
  sta _var_putch_ch
  jsr putch
  lda #2
  sta _var_box_i
_while_51:
  lda _var_box_i
  pha
  lda _var_box_w
  sta _tmp
  pla
  cmp _tmp
  bcc _skip_53
  jmp _endwhile_52
_skip_53:
  lda #64
  sta _var_putch_ch
  jsr putch
  inc _var_box_i
  jmp _while_51
_endwhile_52:
  lda #125
  sta _var_putch_ch
  jsr putch
  rts

; Procedure: putnum
putnum:
  lda _var_putnum_num
  pha
  lda #0
  sta _tmp
  pla
  cmp _tmp
  beq _skip_56
  jmp _else_54
_skip_56:
  lda #48
  sta _var_putch_ch
  jsr putch
  rts
_else_54:
  lda #0
  sta _var_putnum_count
  lda _var_putnum_num
  ldx _var_putnum_num+1
  sta _var_putnum_temp
  stx _var_putnum_temp+1
_while_57:
  lda _var_putnum_temp
  pha
  lda #0
  sta _tmp
  pla
  cmp _tmp
  beq _gt_false_59
  bcs _gt_cont_60
_gt_false_59:
  jmp _endwhile_58
_gt_cont_60:
  lda _var_putnum_temp
  pha
  lda _var_putnum_temp
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
  sta _var_putnum_digit
  lda _var_putnum_count
  tay
  lda _var_putnum_digit
  pha
  lda #48
  sta _tmp
  pla
  clc
  adc _tmp
  sta _var_putnum_digits,y
  lda _var_putnum_temp
  pha
  lda #10
  sta _tmp
  pla
  sta _div_a
  lda _tmp
  sta _div_b
  jsr _divide
  ldx #0
  sta _var_putnum_temp
  stx _var_putnum_temp+1
  inc _var_putnum_count
  jmp _while_57
_endwhile_58:
_while_61:
  lda _var_putnum_count
  pha
  lda #0
  sta _tmp
  pla
  cmp _tmp
  beq _gt_false_63
  bcs _gt_cont_64
_gt_false_63:
  jmp _endwhile_62
_gt_cont_64:
  dec _var_putnum_count
  lda _var_putnum_count
  tay
  lda _var_putnum_digits,y
  sta _var_putch_ch
  jsr putch
  jmp _while_61
_endwhile_62:
  rts

; Procedure: wait_line
wait_line:
_while_65:
  lda $d011
  pha
  lda #127
  sta _tmp
  pla
  cmp _tmp
  beq _gt_false_67
  bcs _gt_cont_68
_gt_false_67:
  jmp _endwhile_66
_gt_cont_68:
  jmp _while_65
_endwhile_66:
_while_69:
  lda $d012
  pha
  lda _var_wait_line_line
  sta _tmp
  pla
  cmp _tmp
  bne _skip_71
  jmp _endwhile_70
_skip_71:
  jmp _while_69
_endwhile_70:
  rts

; Module: sys
; Procedure: irq_enable
irq_enable:
  rts

; Procedure: irq_disable
irq_disable:
  rts

; Main module: crt_bench
; Procedure: main
main:
  sei
  lda #0
  sta $d011
  lda #0
  sta _var_main_line
_while_72:
  lda #1
  bne _skip_74
  jmp _endwhile_73
_skip_74:
  lda #0
  sta $d020
  lda _var_main_line
  sta _var_wait_line_line
  jsr wait_line
  lda #1
  sta $d020
  inc _var_main_line
  lda _var_main_line
  sta _var_wait_line_line
  jsr wait_line
  jmp _while_72
_endwhile_73:
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
_var_cursor_x:
  .byte 0
_var_cursor_y:
  .byte 0
_var_text_color:
  .byte 0
_var_screen_addr:
  .byte 0, 0
_var_color_addr:
  .byte 0, 0
_var_calc_addr_row_offset:
  .byte 0, 0
_var_calc_addr_y_temp:
  .byte 0
_var_calc_color_addr_row_offset:
  .byte 0, 0
_var_calc_color_addr_y_temp:
  .byte 0
_var_clear_row:
  .byte 0
_var_clear_col:
  .byte 0
_var_clear_addr:
  .byte 0, 0
_var_clear_caddr:
  .byte 0, 0
_var_gotoxy_x:
  .byte 0
_var_gotoxy_y:
  .byte 0
_var_putch_ch:
  .byte 0
_var_putc_ch:
  .byte 0
_var_putc_sc:
  .byte 0
_var_setcolor_c:
  .byte 0
_var_hline_ch:
  .byte 0
_var_hline_len:
  .byte 0
_var_hline_i:
  .byte 0
_var_fillrect_x:
  .byte 0
_var_fillrect_y:
  .byte 0
_var_fillrect_w:
  .byte 0
_var_fillrect_h:
  .byte 0
_var_fillrect_ch:
  .byte 0
_var_fillrect_row:
  .byte 0
_var_fillrect_col:
  .byte 0
_var_fillrect_start_x:
  .byte 0
_var_fillrect_start_y:
  .byte 0
_var_box_x:
  .byte 0
_var_box_y:
  .byte 0
_var_box_w:
  .byte 0
_var_box_h:
  .byte 0
_var_box_i:
  .byte 0
_var_putnum_num:
  .byte 0, 0
_var_putnum_digits:
  .byte 0, 0, 0, 0, 0, 0
_var_putnum_count:
  .byte 0
_var_putnum_temp:
  .byte 0, 0
_var_putnum_digit:
  .byte 0
_var_wait_line_line:
  .byte 0
_var_main_line:
  .byte 0