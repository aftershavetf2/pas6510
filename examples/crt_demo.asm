; pas6510 compiled program: crt_demo
;

  .org $0801

; BASIC stub: 10 SYS 2061
  .byte $0b, $08, $0a, $00, $9e, $32, $30, $36, $31, $00, $00, $00

; Program start
start:
  jsr main
  rts

; Module: sys
; Procedure: memset
sys_memset:
  rts

; Module: crt
; Procedure: crt_init
crt_crt_init:
  lda #0
  sta _var_crt_cursor_x
  sta _var_crt_cursor_y
  lda #14
  sta _var_crt_text_color
  rts

; Procedure: calc_addr
crt_calc_addr:
  lda #0
  ldx #0
  sta _var_crt_calc_addr_row_offset
  stx _var_crt_calc_addr_row_offset+1
  lda _var_crt_cursor_y
  sta _var_crt_calc_addr_y_temp
_while_0:
  lda _var_crt_calc_addr_y_temp
  cmp #0
  beq _gt_false_2
  bcs _gt_cont_3
_gt_false_2:
  jmp _endwhile_1
_gt_cont_3:
  lda _var_crt_calc_addr_row_offset
  ldx _var_crt_calc_addr_row_offset+1
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
  sta _var_crt_calc_addr_row_offset
  stx _var_crt_calc_addr_row_offset+1
  dec _var_crt_calc_addr_y_temp
  jmp _while_0
_endwhile_1:
  lda #0
  ldx #4
  sta _tmp16
  stx _tmp16+1
  lda _var_crt_calc_addr_row_offset
  ldx _var_crt_calc_addr_row_offset+1
  clc
  adc _tmp16
  pha
  txa
  adc _tmp16+1
  tax
  pla
  sta _tmp16
  stx _tmp16+1
  lda _var_crt_cursor_x
  ldx #0
  clc
  adc _tmp16
  pha
  txa
  adc _tmp16+1
  tax
  pla
  sta _var_crt_screen_addr
  stx _var_crt_screen_addr+1
  lda #0
  ldx #216
  sta _tmp16
  stx _tmp16+1
  lda _var_crt_calc_addr_row_offset
  ldx _var_crt_calc_addr_row_offset+1
  clc
  adc _tmp16
  pha
  txa
  adc _tmp16+1
  tax
  pla
  sta _tmp16
  stx _tmp16+1
  lda _var_crt_cursor_x
  ldx #0
  clc
  adc _tmp16
  pha
  txa
  adc _tmp16+1
  tax
  pla
  sta _var_crt_color_addr
  stx _var_crt_color_addr+1
  rts

; Procedure: clear
crt_clear:
  lda #0
  sta _var_crt_clear_i
_for_4:
  ldy _var_crt_clear_i
  lda #32
  sta $0400,y
  sta $0500,y
  sta $0600,y
  sta $0700,y
  lda _var_crt_text_color
  sta $d800,y
  sta $d900,y
  sta $da00,y
  sta $db00,y
  inc _var_crt_clear_i
  beq _endfor_5
  jmp _for_4
_endfor_5:
  lda #0
  sta _var_crt_cursor_x
  sta _var_crt_cursor_y
  rts

; Procedure: gotoxy
crt_gotoxy:
  lda _var_crt_gotoxy_x
  sta _var_crt_cursor_x
  lda _var_crt_gotoxy_y
  sta _var_crt_cursor_y
  rts

; Procedure: newline
crt_newline:
  lda #0
  sta _var_crt_cursor_x
  inc _var_crt_cursor_y
  lda _var_crt_cursor_y
  pha
  lda #25
  sta _tmp
  pla
  cmp _tmp
  bcs _skip_8
  jmp _else_6
_skip_8:
  lda #0
  sta _var_crt_cursor_y
_else_6:
  rts

; Procedure: putch
crt_putch:
  jsr crt_calc_addr
  lda _var_crt_screen_addr
  ldx _var_crt_screen_addr+1
  sta _poke_addr
  stx _poke_addr+1
  lda _var_crt_putch_ch
  ldy #0
  sta (_poke_addr),y
  lda _var_crt_color_addr
  ldx _var_crt_color_addr+1
  sta _poke_addr
  stx _poke_addr+1
  lda _var_crt_text_color
  sta (_poke_addr),y
  inc _var_crt_cursor_x
  lda _var_crt_cursor_x
  pha
  lda #40
  sta _tmp
  pla
  cmp _tmp
  bcs _skip_11
  jmp _else_9
_skip_11:
  jsr crt_newline
_else_9:
  rts

; Procedure: putc
crt_putc:
  lda _var_crt_putc_ch
  sta _var_crt_putc_sc
  cmp #65
  bcs _skip_14
  jmp _else_12
_skip_14:
  lda _var_crt_putc_sc
  cmp #90
  beq _le_cont_18
  bcc _le_cont_18
  jmp _else_15
_le_cont_18:
  lda _var_crt_putc_sc
  pha
  lda #64
  sta _tmp
  pla
  sec
  sbc _tmp
  sta _var_crt_putch_ch
  jsr crt_putch
  rts
_else_15:
_else_12:
  lda _var_crt_putc_sc
  cmp #97
  bcs _skip_21
  jmp _else_19
_skip_21:
  lda _var_crt_putc_sc
  cmp #122
  beq _le_cont_25
  bcc _le_cont_25
  jmp _else_22
_le_cont_25:
  lda _var_crt_putc_sc
  pha
  lda #96
  sta _tmp
  pla
  sec
  sbc _tmp
  sta _var_crt_putch_ch
  jsr crt_putch
  rts
_else_22:
_else_19:
  lda _var_crt_putc_sc
  sta _var_crt_putch_ch
  jsr crt_putch
  rts

; Procedure: setcolor
crt_setcolor:
  lda _var_crt_setcolor_c
  sta _var_crt_text_color
  rts

; Procedure: hline
crt_hline:
  lda #0
  ldx #0
  sta _var_crt_hline_yoff
  stx _var_crt_hline_yoff+1
  lda _var_crt_cursor_y
  sta _var_crt_hline_ytmp
_while_26:
  lda _var_crt_hline_ytmp
  cmp #0
  beq _gt_false_28
  bcs _gt_cont_29
_gt_false_28:
  jmp _endwhile_27
_gt_cont_29:
  lda _var_crt_hline_yoff
  ldx _var_crt_hline_yoff+1
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
  sta _var_crt_hline_yoff
  stx _var_crt_hline_yoff+1
  dec _var_crt_hline_ytmp
  jmp _while_26
_endwhile_27:
  lda #0
  ldx #4
  sta _tmp16
  stx _tmp16+1
  lda _var_crt_hline_yoff
  ldx _var_crt_hline_yoff+1
  clc
  adc _tmp16
  pha
  txa
  adc _tmp16+1
  tax
  pla
  sta _tmp16
  stx _tmp16+1
  lda _var_crt_cursor_x
  ldx #0
  clc
  adc _tmp16
  pha
  txa
  adc _tmp16+1
  tax
  pla
  sta _var_crt_hline_saddr
  stx _var_crt_hline_saddr+1
  lda #0
  ldx #216
  sta _tmp16
  stx _tmp16+1
  lda _var_crt_hline_yoff
  ldx _var_crt_hline_yoff+1
  clc
  adc _tmp16
  pha
  txa
  adc _tmp16+1
  tax
  pla
  sta _tmp16
  stx _tmp16+1
  lda _var_crt_cursor_x
  ldx #0
  clc
  adc _tmp16
  pha
  txa
  adc _tmp16+1
  tax
  pla
  sta _var_crt_hline_caddr
  stx _var_crt_hline_caddr+1
  lda _var_crt_hline_len
  tay
  lda _var_crt_hline_ch
  pha
  sty _tmp
  lda _var_crt_hline_saddr
  ldx _var_crt_hline_saddr+1
  sta _poke_addr
  stx _poke_addr+1
  ldy _tmp
  pla
  cpy #0
  beq _memset_full_31
_memset_loop_32:
  dey
  sta (_poke_addr),y
  bne _memset_loop_32
  beq _memset_done_30
_memset_full_31:
_memset_full_loop_33:
  sta (_poke_addr),y
  iny
  bne _memset_full_loop_33
_memset_done_30:
  lda _var_crt_hline_len
  tay
  lda _var_crt_text_color
  pha
  sty _tmp
  lda _var_crt_hline_caddr
  ldx _var_crt_hline_caddr+1
  sta _poke_addr
  stx _poke_addr+1
  ldy _tmp
  pla
  cpy #0
  beq _memset_full_35
_memset_loop_36:
  dey
  sta (_poke_addr),y
  bne _memset_loop_36
  beq _memset_done_34
_memset_full_35:
_memset_full_loop_37:
  sta (_poke_addr),y
  iny
  bne _memset_full_loop_37
_memset_done_34:
  lda _var_crt_cursor_x
  pha
  lda _var_crt_hline_len
  sta _tmp
  pla
  clc
  adc _tmp
  sta _var_crt_cursor_x
  rts

; Procedure: box
crt_box:
  lda #0
  ldx #0
  sta _var_crt_box_yoff
  stx _var_crt_box_yoff+1
  lda _var_crt_box_y
  sta _var_crt_box_ytmp
_while_38:
  lda _var_crt_box_ytmp
  cmp #0
  beq _gt_false_40
  bcs _gt_cont_41
_gt_false_40:
  jmp _endwhile_39
_gt_cont_41:
  lda _var_crt_box_yoff
  ldx _var_crt_box_yoff+1
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
  sta _var_crt_box_yoff
  stx _var_crt_box_yoff+1
  dec _var_crt_box_ytmp
  jmp _while_38
_endwhile_39:
  lda #0
  ldx #4
  sta _tmp16
  stx _tmp16+1
  lda _var_crt_box_yoff
  ldx _var_crt_box_yoff+1
  clc
  adc _tmp16
  pha
  txa
  adc _tmp16+1
  tax
  pla
  sta _tmp16
  stx _tmp16+1
  lda _var_crt_box_x
  ldx #0
  clc
  adc _tmp16
  pha
  txa
  adc _tmp16+1
  tax
  pla
  sta _var_crt_box_saddr
  stx _var_crt_box_saddr+1
  lda #0
  ldx #216
  sta _tmp16
  stx _tmp16+1
  lda _var_crt_box_yoff
  ldx _var_crt_box_yoff+1
  clc
  adc _tmp16
  pha
  txa
  adc _tmp16+1
  tax
  pla
  sta _tmp16
  stx _tmp16+1
  lda _var_crt_box_x
  ldx #0
  clc
  adc _tmp16
  pha
  txa
  adc _tmp16+1
  tax
  pla
  sta _var_crt_box_caddr
  stx _var_crt_box_caddr+1
  lda _var_crt_box_w
  pha
  lda #2
  sta _tmp
  pla
  sec
  sbc _tmp
  sta _var_crt_box_inner_w
  lda _var_crt_box_saddr
  ldx _var_crt_box_saddr+1
  sta _poke_addr
  stx _poke_addr+1
  lda #112
  ldy #0
  sta (_poke_addr),y
  lda _var_crt_box_caddr
  ldx _var_crt_box_caddr+1
  sta _poke_addr
  stx _poke_addr+1
  lda _var_crt_text_color
  sta (_poke_addr),y
  lda _var_crt_box_inner_w
  tay
  lda #64
  pha
  sty _tmp
  lda _var_crt_box_saddr
  ldx _var_crt_box_saddr+1
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
  sta _poke_addr
  stx _poke_addr+1
  ldy _tmp
  pla
  cpy #0
  beq _memset_full_43
_memset_loop_44:
  dey
  sta (_poke_addr),y
  bne _memset_loop_44
  beq _memset_done_42
_memset_full_43:
_memset_full_loop_45:
  sta (_poke_addr),y
  iny
  bne _memset_full_loop_45
_memset_done_42:
  lda _var_crt_box_inner_w
  tay
  lda _var_crt_text_color
  pha
  sty _tmp
  lda _var_crt_box_caddr
  ldx _var_crt_box_caddr+1
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
  sta _poke_addr
  stx _poke_addr+1
  ldy _tmp
  pla
  cpy #0
  beq _memset_full_47
_memset_loop_48:
  dey
  sta (_poke_addr),y
  bne _memset_loop_48
  beq _memset_done_46
_memset_full_47:
_memset_full_loop_49:
  sta (_poke_addr),y
  iny
  bne _memset_full_loop_49
_memset_done_46:
  lda _var_crt_box_saddr
  ldx _var_crt_box_saddr+1
  sta _tmp16
  stx _tmp16+1
  lda _var_crt_box_w
  ldx #0
  clc
  adc _tmp16
  pha
  txa
  adc _tmp16+1
  tax
  pla
  sta _tmp16
  stx _tmp16+1
  lda #1
  ldx #0
  sta _tmp
  stx _tmp+1
  lda _tmp16
  sec
  sbc _tmp
  pha
  lda _tmp16+1
  sbc _tmp+1
  tax
  pla
  sta _poke_addr
  stx _poke_addr+1
  lda #110
  ldy #0
  sta (_poke_addr),y
  lda _var_crt_box_caddr
  ldx _var_crt_box_caddr+1
  sta _tmp16
  stx _tmp16+1
  lda _var_crt_box_w
  ldx #0
  clc
  adc _tmp16
  pha
  txa
  adc _tmp16+1
  tax
  pla
  sta _tmp16
  stx _tmp16+1
  lda #1
  ldx #0
  sta _tmp
  stx _tmp+1
  lda _tmp16
  sec
  sbc _tmp
  pha
  lda _tmp16+1
  sbc _tmp+1
  tax
  pla
  sta _poke_addr
  stx _poke_addr+1
  lda _var_crt_text_color
  sta (_poke_addr),y
  lda #1
  sta _var_crt_box_i
_while_50:
  lda _var_crt_box_i
  pha
  lda _var_crt_box_h
  pha
  lda #1
  sta _tmp
  pla
  sec
  sbc _tmp
  sta _tmp
  pla
  cmp _tmp
  bcc _skip_52
  jmp _endwhile_51
_skip_52:
  lda _var_crt_box_saddr
  ldx _var_crt_box_saddr+1
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
  sta _var_crt_box_saddr
  stx _var_crt_box_saddr+1
  lda _var_crt_box_caddr
  ldx _var_crt_box_caddr+1
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
  sta _var_crt_box_caddr
  stx _var_crt_box_caddr+1
  lda _var_crt_box_saddr
  ldx _var_crt_box_saddr+1
  sta _poke_addr
  stx _poke_addr+1
  lda #93
  ldy #0
  sta (_poke_addr),y
  lda _var_crt_box_caddr
  ldx _var_crt_box_caddr+1
  sta _poke_addr
  stx _poke_addr+1
  lda _var_crt_text_color
  sta (_poke_addr),y
  lda _var_crt_box_saddr
  ldx _var_crt_box_saddr+1
  sta _tmp16
  stx _tmp16+1
  lda _var_crt_box_w
  ldx #0
  clc
  adc _tmp16
  pha
  txa
  adc _tmp16+1
  tax
  pla
  sta _tmp16
  stx _tmp16+1
  lda #1
  ldx #0
  sta _tmp
  stx _tmp+1
  lda _tmp16
  sec
  sbc _tmp
  pha
  lda _tmp16+1
  sbc _tmp+1
  tax
  pla
  sta _poke_addr
  stx _poke_addr+1
  lda #93
  sta (_poke_addr),y
  lda _var_crt_box_caddr
  ldx _var_crt_box_caddr+1
  sta _tmp16
  stx _tmp16+1
  lda _var_crt_box_w
  ldx #0
  clc
  adc _tmp16
  pha
  txa
  adc _tmp16+1
  tax
  pla
  sta _tmp16
  stx _tmp16+1
  lda #1
  ldx #0
  sta _tmp
  stx _tmp+1
  lda _tmp16
  sec
  sbc _tmp
  pha
  lda _tmp16+1
  sbc _tmp+1
  tax
  pla
  sta _poke_addr
  stx _poke_addr+1
  lda _var_crt_text_color
  sta (_poke_addr),y
  inc _var_crt_box_i
  jmp _while_50
_endwhile_51:
  lda _var_crt_box_saddr
  ldx _var_crt_box_saddr+1
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
  sta _var_crt_box_saddr
  stx _var_crt_box_saddr+1
  lda _var_crt_box_caddr
  ldx _var_crt_box_caddr+1
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
  sta _var_crt_box_caddr
  stx _var_crt_box_caddr+1
  lda _var_crt_box_saddr
  ldx _var_crt_box_saddr+1
  sta _poke_addr
  stx _poke_addr+1
  lda #109
  ldy #0
  sta (_poke_addr),y
  lda _var_crt_box_caddr
  ldx _var_crt_box_caddr+1
  sta _poke_addr
  stx _poke_addr+1
  lda _var_crt_text_color
  sta (_poke_addr),y
  lda _var_crt_box_inner_w
  tay
  lda #64
  pha
  sty _tmp
  lda _var_crt_box_saddr
  ldx _var_crt_box_saddr+1
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
  sta _poke_addr
  stx _poke_addr+1
  ldy _tmp
  pla
  cpy #0
  beq _memset_full_54
_memset_loop_55:
  dey
  sta (_poke_addr),y
  bne _memset_loop_55
  beq _memset_done_53
_memset_full_54:
_memset_full_loop_56:
  sta (_poke_addr),y
  iny
  bne _memset_full_loop_56
_memset_done_53:
  lda _var_crt_box_inner_w
  tay
  lda _var_crt_text_color
  pha
  sty _tmp
  lda _var_crt_box_caddr
  ldx _var_crt_box_caddr+1
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
  sta _poke_addr
  stx _poke_addr+1
  ldy _tmp
  pla
  cpy #0
  beq _memset_full_58
_memset_loop_59:
  dey
  sta (_poke_addr),y
  bne _memset_loop_59
  beq _memset_done_57
_memset_full_58:
_memset_full_loop_60:
  sta (_poke_addr),y
  iny
  bne _memset_full_loop_60
_memset_done_57:
  lda _var_crt_box_saddr
  ldx _var_crt_box_saddr+1
  sta _tmp16
  stx _tmp16+1
  lda _var_crt_box_w
  ldx #0
  clc
  adc _tmp16
  pha
  txa
  adc _tmp16+1
  tax
  pla
  sta _tmp16
  stx _tmp16+1
  lda #1
  ldx #0
  sta _tmp
  stx _tmp+1
  lda _tmp16
  sec
  sbc _tmp
  pha
  lda _tmp16+1
  sbc _tmp+1
  tax
  pla
  sta _poke_addr
  stx _poke_addr+1
  lda #125
  ldy #0
  sta (_poke_addr),y
  lda _var_crt_box_caddr
  ldx _var_crt_box_caddr+1
  sta _tmp16
  stx _tmp16+1
  lda _var_crt_box_w
  ldx #0
  clc
  adc _tmp16
  pha
  txa
  adc _tmp16+1
  tax
  pla
  sta _tmp16
  stx _tmp16+1
  lda #1
  ldx #0
  sta _tmp
  stx _tmp+1
  lda _tmp16
  sec
  sbc _tmp
  pha
  lda _tmp16+1
  sbc _tmp+1
  tax
  pla
  sta _poke_addr
  stx _poke_addr+1
  lda _var_crt_text_color
  sta (_poke_addr),y
  rts

; Procedure: putnum
crt_putnum:
  lda _var_crt_putnum_num
  cmp #0
  beq _skip_63
  jmp _else_61
_skip_63:
  lda #48
  sta _var_crt_putch_ch
  jsr crt_putch
  rts
_else_61:
  lda #0
  sta _var_crt_putnum_count
  lda _var_crt_putnum_num
  ldx _var_crt_putnum_num+1
  sta _var_crt_putnum_temp
  stx _var_crt_putnum_temp+1
_while_64:
  lda _var_crt_putnum_temp
  cmp #0
  beq _gt_false_66
  bcs _gt_cont_67
_gt_false_66:
  jmp _endwhile_65
_gt_cont_67:
  lda _var_crt_putnum_temp
  pha
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
  sta _var_crt_putnum_digit
  lda _var_crt_putnum_count
  tay
  lda _var_crt_putnum_digit
  pha
  lda #48
  sta _tmp
  pla
  clc
  adc _tmp
  sta _var_crt_putnum_digits,y
  lda _var_crt_putnum_temp
  pha
  lda #10
  sta _tmp
  pla
  sta _div_a
  lda _tmp
  sta _div_b
  jsr _divide
  ldx #0
  sta _var_crt_putnum_temp
  stx _var_crt_putnum_temp+1
  inc _var_crt_putnum_count
  jmp _while_64
_endwhile_65:
_while_68:
  lda _var_crt_putnum_count
  cmp #0
  beq _gt_false_70
  bcs _gt_cont_71
_gt_false_70:
  jmp _endwhile_69
_gt_cont_71:
  dec _var_crt_putnum_count
  lda _var_crt_putnum_count
  tay
  lda _var_crt_putnum_digits,y
  sta _var_crt_putch_ch
  jsr crt_putch
  jmp _while_68
_endwhile_69:
  rts

; Main module: crt_demo
; Procedure: print_hello
print_hello:
  lda #72
  sta _var_crt_putc_ch
  jsr crt_putc
  lda #69
  sta _var_crt_putc_ch
  jsr crt_putc
  lda #76
  sta _var_crt_putc_ch
  jsr crt_putc
  lda #76
  sta _var_crt_putc_ch
  jsr crt_putc
  lda #79
  sta _var_crt_putc_ch
  jsr crt_putc
  lda #32
  sta _var_crt_putc_ch
  jsr crt_putc
  lda #87
  sta _var_crt_putc_ch
  jsr crt_putc
  lda #79
  sta _var_crt_putc_ch
  jsr crt_putc
  lda #82
  sta _var_crt_putc_ch
  jsr crt_putc
  lda #76
  sta _var_crt_putc_ch
  jsr crt_putc
  lda #68
  sta _var_crt_putc_ch
  jsr crt_putc
  rts

; Procedure: print_pas6510
print_pas6510:
  lda #80
  sta _var_crt_putc_ch
  jsr crt_putc
  lda #65
  sta _var_crt_putc_ch
  jsr crt_putc
  lda #83
  sta _var_crt_putc_ch
  jsr crt_putc
  lda #54
  sta _var_crt_putc_ch
  jsr crt_putc
  lda #53
  sta _var_crt_putc_ch
  jsr crt_putc
  lda #49
  sta _var_crt_putc_ch
  jsr crt_putc
  lda #48
  sta _var_crt_putc_ch
  jsr crt_putc
  lda #32
  sta _var_crt_putc_ch
  jsr crt_putc
  lda #67
  sta _var_crt_putc_ch
  jsr crt_putc
  lda #82
  sta _var_crt_putc_ch
  jsr crt_putc
  lda #84
  sta _var_crt_putc_ch
  jsr crt_putc
  lda #32
  sta _var_crt_putc_ch
  jsr crt_putc
  lda #68
  sta _var_crt_putc_ch
  jsr crt_putc
  lda #69
  sta _var_crt_putc_ch
  jsr crt_putc
  lda #77
  sta _var_crt_putc_ch
  jsr crt_putc
  lda #79
  sta _var_crt_putc_ch
  jsr crt_putc
  rts

; Procedure: print_number_label
print_number_label:
  lda #78
  sta _var_crt_putc_ch
  jsr crt_putc
  lda #85
  sta _var_crt_putc_ch
  jsr crt_putc
  lda #77
  sta _var_crt_putc_ch
  jsr crt_putc
  lda #66
  sta _var_crt_putc_ch
  jsr crt_putc
  lda #69
  sta _var_crt_putc_ch
  jsr crt_putc
  lda #82
  sta _var_crt_putc_ch
  jsr crt_putc
  lda #58
  sta _var_crt_putc_ch
  jsr crt_putc
  lda #32
  sta _var_crt_putc_ch
  jsr crt_putc
  rts

; Procedure: print_red
print_red:
  lda #82
  sta _var_crt_putc_ch
  jsr crt_putc
  lda #69
  sta _var_crt_putc_ch
  jsr crt_putc
  lda #68
  sta _var_crt_putc_ch
  jsr crt_putc
  lda #32
  sta _var_crt_putc_ch
  jsr crt_putc
  rts

; Procedure: print_green
print_green:
  lda #71
  sta _var_crt_putc_ch
  jsr crt_putc
  lda #82
  sta _var_crt_putc_ch
  jsr crt_putc
  lda #69
  sta _var_crt_putc_ch
  jsr crt_putc
  lda #69
  sta _var_crt_putc_ch
  jsr crt_putc
  lda #78
  sta _var_crt_putc_ch
  jsr crt_putc
  lda #32
  sta _var_crt_putc_ch
  jsr crt_putc
  rts

; Procedure: print_blue
print_blue:
  lda #66
  sta _var_crt_putc_ch
  jsr crt_putc
  lda #76
  sta _var_crt_putc_ch
  jsr crt_putc
  lda #85
  sta _var_crt_putc_ch
  jsr crt_putc
  lda #69
  sta _var_crt_putc_ch
  jsr crt_putc
  rts

; Procedure: main
main:
  jsr crt_crt_init
  lda #0
  sta _var_main_i
_for_72:
  jsr crt_clear
  lda #3
  sta _var_crt_setcolor_c
  jsr crt_setcolor
  lda #5
  sta _var_crt_box_x
  lda #2
  sta _var_crt_box_y
  lda #30
  sta _var_crt_box_w
  lda #10
  sta _var_crt_box_h
  jsr crt_box
  lda #1
  sta _var_crt_setcolor_c
  jsr crt_setcolor
  lda #14
  sta _var_crt_gotoxy_x
  lda #4
  sta _var_crt_gotoxy_y
  jsr crt_gotoxy
  jsr print_hello
  lda #7
  sta _var_crt_setcolor_c
  jsr crt_setcolor
  lda #8
  sta _var_crt_gotoxy_x
  lda #6
  sta _var_crt_gotoxy_y
  jsr crt_gotoxy
  jsr print_number_label
  lda #57
  ldx #48
  sta _var_crt_putnum_num
  stx _var_crt_putnum_num+1
  jsr crt_putnum
  lda #8
  sta _var_crt_gotoxy_x
  sta _var_crt_gotoxy_y
  jsr crt_gotoxy
  lda #2
  sta _var_crt_setcolor_c
  jsr crt_setcolor
  jsr print_red
  lda #5
  sta _var_crt_setcolor_c
  jsr crt_setcolor
  jsr print_green
  lda #6
  sta _var_crt_setcolor_c
  jsr crt_setcolor
  jsr print_blue
  lda #14
  sta _var_crt_setcolor_c
  jsr crt_setcolor
  lda #0
  sta _var_crt_gotoxy_x
  lda #20
  sta _var_crt_gotoxy_y
  jsr crt_gotoxy
  lda #64
  sta _var_crt_hline_ch
  lda #40
  sta _var_crt_hline_len
  jsr crt_hline
  lda #12
  sta _var_crt_gotoxy_x
  lda #22
  sta _var_crt_gotoxy_y
  jsr crt_gotoxy
  jsr print_pas6510
  inc _var_main_i
  beq _endfor_73
  jmp _for_72
_endfor_73:
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


; Variables
_var_sys_memset_addr:
  .byte 0, 0
_var_sys_memset_len:
  .byte 0
_var_sys_memset_value:
  .byte 0
_var_crt_cursor_x:
  .byte 0
_var_crt_cursor_y:
  .byte 0
_var_crt_text_color:
  .byte 0
_var_crt_screen_addr:
  .byte 0, 0
_var_crt_color_addr:
  .byte 0, 0
_var_crt_calc_addr_row_offset:
  .byte 0, 0
_var_crt_calc_addr_y_temp:
  .byte 0
_var_crt_clear_i:
  .byte 0
_var_crt_gotoxy_x:
  .byte 0
_var_crt_gotoxy_y:
  .byte 0
_var_crt_putch_ch:
  .byte 0
_var_crt_putc_ch:
  .byte 0
_var_crt_putc_sc:
  .byte 0
_var_crt_setcolor_c:
  .byte 0
_var_crt_hline_ch:
  .byte 0
_var_crt_hline_len:
  .byte 0
_var_crt_hline_saddr:
  .byte 0, 0
_var_crt_hline_caddr:
  .byte 0, 0
_var_crt_hline_yoff:
  .byte 0, 0
_var_crt_hline_ytmp:
  .byte 0
_var_crt_box_x:
  .byte 0
_var_crt_box_y:
  .byte 0
_var_crt_box_w:
  .byte 0
_var_crt_box_h:
  .byte 0
_var_crt_box_i:
  .byte 0
_var_crt_box_saddr:
  .byte 0, 0
_var_crt_box_caddr:
  .byte 0, 0
_var_crt_box_yoff:
  .byte 0, 0
_var_crt_box_ytmp:
  .byte 0
_var_crt_box_inner_w:
  .byte 0
_var_crt_putnum_num:
  .byte 0, 0
_var_crt_putnum_digits:
  .byte 0, 0, 0, 0, 0, 0
_var_crt_putnum_count:
  .byte 0
_var_crt_putnum_temp:
  .byte 0, 0
_var_crt_putnum_digit:
  .byte 0
_var_main_i:
  .byte 0