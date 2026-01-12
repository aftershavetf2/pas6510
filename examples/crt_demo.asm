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
; Procedure: irq_enable
irq_enable:
  rts

; Procedure: irq_disable
irq_disable:
  rts

; Procedure: memset
memset:
  rts

; Module: crt
; Procedure: crt_init
crt_init:
  lda #0
  sta _var_cursor_x
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
  cmp #0
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
  cmp #0
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
  lda #32
  pha
  lda #0
  tay
  pla
  cpy #0
  beq _memset_full_9
_memset_loop_10:
  dey
  sta $0400,y
  bne _memset_loop_10
  beq _memset_done_8
_memset_full_9:
_memset_full_loop_11:
  sta $0400,y
  iny
  bne _memset_full_loop_11
_memset_done_8:
  lda _var_text_color
  pha
  lda #0
  tay
  pla
  cpy #0
  beq _memset_full_13
_memset_loop_14:
  dey
  sta $d800,y
  bne _memset_loop_14
  beq _memset_done_12
_memset_full_13:
_memset_full_loop_15:
  sta $d800,y
  iny
  bne _memset_full_loop_15
_memset_done_12:
  lda #32
  pha
  lda #0
  tay
  pla
  cpy #0
  beq _memset_full_17
_memset_loop_18:
  dey
  sta $0500,y
  bne _memset_loop_18
  beq _memset_done_16
_memset_full_17:
_memset_full_loop_19:
  sta $0500,y
  iny
  bne _memset_full_loop_19
_memset_done_16:
  lda _var_text_color
  pha
  lda #0
  tay
  pla
  cpy #0
  beq _memset_full_21
_memset_loop_22:
  dey
  sta $d900,y
  bne _memset_loop_22
  beq _memset_done_20
_memset_full_21:
_memset_full_loop_23:
  sta $d900,y
  iny
  bne _memset_full_loop_23
_memset_done_20:
  lda #32
  pha
  lda #0
  tay
  pla
  cpy #0
  beq _memset_full_25
_memset_loop_26:
  dey
  sta $0600,y
  bne _memset_loop_26
  beq _memset_done_24
_memset_full_25:
_memset_full_loop_27:
  sta $0600,y
  iny
  bne _memset_full_loop_27
_memset_done_24:
  lda _var_text_color
  pha
  lda #0
  tay
  pla
  cpy #0
  beq _memset_full_29
_memset_loop_30:
  dey
  sta $da00,y
  bne _memset_loop_30
  beq _memset_done_28
_memset_full_29:
_memset_full_loop_31:
  sta $da00,y
  iny
  bne _memset_full_loop_31
_memset_done_28:
  lda #32
  pha
  lda #231
  tay
  pla
  cpy #0
  beq _memset_full_33
_memset_loop_34:
  dey
  sta $0700,y
  bne _memset_loop_34
  beq _memset_done_32
_memset_full_33:
_memset_full_loop_35:
  sta $0700,y
  iny
  bne _memset_full_loop_35
_memset_done_32:
  lda _var_text_color
  pha
  lda #231
  tay
  pla
  cpy #0
  beq _memset_full_37
_memset_loop_38:
  dey
  sta $db00,y
  bne _memset_loop_38
  beq _memset_done_36
_memset_full_37:
_memset_full_loop_39:
  sta $db00,y
  iny
  bne _memset_full_loop_39
_memset_done_36:
  lda #0
  sta _var_cursor_x
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
  cmp #25
  bcs _skip_42
  jmp _else_40
_skip_42:
  lda #0
  sta _var_cursor_y
_else_40:
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
  sta (_poke_addr),y
  inc _var_cursor_x
  lda _var_cursor_x
  cmp #40
  bcs _skip_45
  jmp _else_43
_skip_45:
  jsr newline
_else_43:
  rts

; Procedure: putc
putc:
  lda _var_putc_ch
  sta _var_putc_sc
  cmp #65
  bcs _skip_48
  jmp _else_46
_skip_48:
  lda _var_putc_sc
  cmp #90
  beq _le_cont_52
  bcc _le_cont_52
  jmp _else_49
_le_cont_52:
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
_else_49:
_else_46:
  lda _var_putc_sc
  cmp #97
  bcs _skip_55
  jmp _else_53
_skip_55:
  lda _var_putc_sc
  cmp #122
  beq _le_cont_59
  bcc _le_cont_59
  jmp _else_56
_le_cont_59:
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
_else_56:
_else_53:
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
  ldx #0
  sta _var_hline_yoff
  stx _var_hline_yoff+1
  lda _var_cursor_y
  sta _var_hline_ytmp
_while_60:
  lda _var_hline_ytmp
  cmp #0
  beq _gt_false_62
  bcs _gt_cont_63
_gt_false_62:
  jmp _endwhile_61
_gt_cont_63:
  lda _var_hline_yoff
  ldx _var_hline_yoff+1
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
  sta _var_hline_yoff
  stx _var_hline_yoff+1
  dec _var_hline_ytmp
  jmp _while_60
_endwhile_61:
  lda #0
  ldx #4
  sta _tmp16
  stx _tmp16+1
  lda _var_hline_yoff
  ldx _var_hline_yoff+1
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
  sta _var_hline_saddr
  stx _var_hline_saddr+1
  lda #0
  ldx #216
  sta _tmp16
  stx _tmp16+1
  lda _var_hline_yoff
  ldx _var_hline_yoff+1
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
  sta _var_hline_caddr
  stx _var_hline_caddr+1
  lda _var_hline_ch
  pha
  lda _var_hline_len
  tay
  pla
  pha
  sty _tmp
  lda _var_hline_saddr
  ldx _var_hline_saddr+1
  sta _poke_addr
  stx _poke_addr+1
  ldy _tmp
  pla
  cpy #0
  beq _memset_full_65
_memset_loop_66:
  dey
  sta (_poke_addr),y
  bne _memset_loop_66
  beq _memset_done_64
_memset_full_65:
_memset_full_loop_67:
  sta (_poke_addr),y
  iny
  bne _memset_full_loop_67
_memset_done_64:
  lda _var_text_color
  pha
  lda _var_hline_len
  tay
  pla
  pha
  sty _tmp
  lda _var_hline_caddr
  ldx _var_hline_caddr+1
  sta _poke_addr
  stx _poke_addr+1
  ldy _tmp
  pla
  cpy #0
  beq _memset_full_69
_memset_loop_70:
  dey
  sta (_poke_addr),y
  bne _memset_loop_70
  beq _memset_done_68
_memset_full_69:
_memset_full_loop_71:
  sta (_poke_addr),y
  iny
  bne _memset_full_loop_71
_memset_done_68:
  lda _var_cursor_x
  pha
  lda _var_hline_len
  sta _tmp
  pla
  clc
  adc _tmp
  sta _var_cursor_x
  rts

; Procedure: fillrect
fillrect:
  lda #0
  ldx #0
  sta _var_fillrect_yoff
  stx _var_fillrect_yoff+1
  lda _var_fillrect_y
  sta _var_fillrect_ytmp
_while_72:
  lda _var_fillrect_ytmp
  cmp #0
  beq _gt_false_74
  bcs _gt_cont_75
_gt_false_74:
  jmp _endwhile_73
_gt_cont_75:
  lda _var_fillrect_yoff
  ldx _var_fillrect_yoff+1
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
  sta _var_fillrect_yoff
  stx _var_fillrect_yoff+1
  dec _var_fillrect_ytmp
  jmp _while_72
_endwhile_73:
  lda #0
  ldx #4
  sta _tmp16
  stx _tmp16+1
  lda _var_fillrect_yoff
  ldx _var_fillrect_yoff+1
  clc
  adc _tmp16
  pha
  txa
  adc _tmp16+1
  tax
  pla
  sta _tmp16
  stx _tmp16+1
  lda _var_fillrect_x
  ldx #0
  clc
  adc _tmp16
  pha
  txa
  adc _tmp16+1
  tax
  pla
  sta _var_fillrect_saddr
  stx _var_fillrect_saddr+1
  lda #0
  ldx #216
  sta _tmp16
  stx _tmp16+1
  lda _var_fillrect_yoff
  ldx _var_fillrect_yoff+1
  clc
  adc _tmp16
  pha
  txa
  adc _tmp16+1
  tax
  pla
  sta _tmp16
  stx _tmp16+1
  lda _var_fillrect_x
  ldx #0
  clc
  adc _tmp16
  pha
  txa
  adc _tmp16+1
  tax
  pla
  sta _var_fillrect_caddr
  stx _var_fillrect_caddr+1
  lda #0
  sta _var_fillrect_row
_while_76:
  lda _var_fillrect_row
  cmp _var_fillrect_h
  bcc _skip_78
  jmp _endwhile_77
_skip_78:
  lda _var_fillrect_ch
  pha
  lda _var_fillrect_w
  tay
  pla
  pha
  sty _tmp
  lda _var_fillrect_saddr
  ldx _var_fillrect_saddr+1
  sta _poke_addr
  stx _poke_addr+1
  ldy _tmp
  pla
  cpy #0
  beq _memset_full_80
_memset_loop_81:
  dey
  sta (_poke_addr),y
  bne _memset_loop_81
  beq _memset_done_79
_memset_full_80:
_memset_full_loop_82:
  sta (_poke_addr),y
  iny
  bne _memset_full_loop_82
_memset_done_79:
  lda _var_text_color
  pha
  lda _var_fillrect_w
  tay
  pla
  pha
  sty _tmp
  lda _var_fillrect_caddr
  ldx _var_fillrect_caddr+1
  sta _poke_addr
  stx _poke_addr+1
  ldy _tmp
  pla
  cpy #0
  beq _memset_full_84
_memset_loop_85:
  dey
  sta (_poke_addr),y
  bne _memset_loop_85
  beq _memset_done_83
_memset_full_84:
_memset_full_loop_86:
  sta (_poke_addr),y
  iny
  bne _memset_full_loop_86
_memset_done_83:
  lda _var_fillrect_saddr
  ldx _var_fillrect_saddr+1
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
  sta _var_fillrect_saddr
  stx _var_fillrect_saddr+1
  lda _var_fillrect_caddr
  ldx _var_fillrect_caddr+1
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
  sta _var_fillrect_caddr
  stx _var_fillrect_caddr+1
  inc _var_fillrect_row
  jmp _while_76
_endwhile_77:
  rts

; Procedure: box
box:
  lda #0
  ldx #0
  sta _var_box_yoff
  stx _var_box_yoff+1
  lda _var_box_y
  sta _var_box_ytmp
_while_87:
  lda _var_box_ytmp
  cmp #0
  beq _gt_false_89
  bcs _gt_cont_90
_gt_false_89:
  jmp _endwhile_88
_gt_cont_90:
  lda _var_box_yoff
  ldx _var_box_yoff+1
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
  sta _var_box_yoff
  stx _var_box_yoff+1
  dec _var_box_ytmp
  jmp _while_87
_endwhile_88:
  lda #0
  ldx #4
  sta _tmp16
  stx _tmp16+1
  lda _var_box_yoff
  ldx _var_box_yoff+1
  clc
  adc _tmp16
  pha
  txa
  adc _tmp16+1
  tax
  pla
  sta _tmp16
  stx _tmp16+1
  lda _var_box_x
  ldx #0
  clc
  adc _tmp16
  pha
  txa
  adc _tmp16+1
  tax
  pla
  sta _var_box_saddr
  stx _var_box_saddr+1
  lda #0
  ldx #216
  sta _tmp16
  stx _tmp16+1
  lda _var_box_yoff
  ldx _var_box_yoff+1
  clc
  adc _tmp16
  pha
  txa
  adc _tmp16+1
  tax
  pla
  sta _tmp16
  stx _tmp16+1
  lda _var_box_x
  ldx #0
  clc
  adc _tmp16
  pha
  txa
  adc _tmp16+1
  tax
  pla
  sta _var_box_caddr
  stx _var_box_caddr+1
  lda _var_box_w
  pha
  lda #2
  sta _tmp
  pla
  sec
  sbc _tmp
  sta _var_box_inner_w
  lda _var_box_saddr
  ldx _var_box_saddr+1
  sta _poke_addr
  stx _poke_addr+1
  lda #112
  ldy #0
  sta (_poke_addr),y
  lda _var_box_caddr
  ldx _var_box_caddr+1
  sta _poke_addr
  stx _poke_addr+1
  lda _var_text_color
  sta (_poke_addr),y
  lda #64
  pha
  lda _var_box_inner_w
  tay
  pla
  pha
  sty _tmp
  lda _var_box_saddr
  ldx _var_box_saddr+1
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
  beq _memset_full_92
_memset_loop_93:
  dey
  sta (_poke_addr),y
  bne _memset_loop_93
  beq _memset_done_91
_memset_full_92:
_memset_full_loop_94:
  sta (_poke_addr),y
  iny
  bne _memset_full_loop_94
_memset_done_91:
  lda _var_text_color
  pha
  lda _var_box_inner_w
  tay
  pla
  pha
  sty _tmp
  lda _var_box_caddr
  ldx _var_box_caddr+1
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
  beq _memset_full_96
_memset_loop_97:
  dey
  sta (_poke_addr),y
  bne _memset_loop_97
  beq _memset_done_95
_memset_full_96:
_memset_full_loop_98:
  sta (_poke_addr),y
  iny
  bne _memset_full_loop_98
_memset_done_95:
  lda _var_box_saddr
  ldx _var_box_saddr+1
  sta _tmp16
  stx _tmp16+1
  lda _var_box_w
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
  lda _var_box_caddr
  ldx _var_box_caddr+1
  sta _tmp16
  stx _tmp16+1
  lda _var_box_w
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
  lda _var_text_color
  sta (_poke_addr),y
  lda #1
  sta _var_box_i
_while_99:
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
  bcc _skip_101
  jmp _endwhile_100
_skip_101:
  lda _var_box_saddr
  ldx _var_box_saddr+1
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
  sta _var_box_saddr
  stx _var_box_saddr+1
  lda _var_box_caddr
  ldx _var_box_caddr+1
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
  sta _var_box_caddr
  stx _var_box_caddr+1
  lda _var_box_saddr
  ldx _var_box_saddr+1
  sta _poke_addr
  stx _poke_addr+1
  lda #93
  ldy #0
  sta (_poke_addr),y
  lda _var_box_caddr
  ldx _var_box_caddr+1
  sta _poke_addr
  stx _poke_addr+1
  lda _var_text_color
  sta (_poke_addr),y
  lda _var_box_saddr
  ldx _var_box_saddr+1
  sta _tmp16
  stx _tmp16+1
  lda _var_box_w
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
  lda _var_box_caddr
  ldx _var_box_caddr+1
  sta _tmp16
  stx _tmp16+1
  lda _var_box_w
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
  lda _var_text_color
  sta (_poke_addr),y
  inc _var_box_i
  jmp _while_99
_endwhile_100:
  lda _var_box_saddr
  ldx _var_box_saddr+1
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
  sta _var_box_saddr
  stx _var_box_saddr+1
  lda _var_box_caddr
  ldx _var_box_caddr+1
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
  sta _var_box_caddr
  stx _var_box_caddr+1
  lda _var_box_saddr
  ldx _var_box_saddr+1
  sta _poke_addr
  stx _poke_addr+1
  lda #109
  ldy #0
  sta (_poke_addr),y
  lda _var_box_caddr
  ldx _var_box_caddr+1
  sta _poke_addr
  stx _poke_addr+1
  lda _var_text_color
  sta (_poke_addr),y
  lda #64
  pha
  lda _var_box_inner_w
  tay
  pla
  pha
  sty _tmp
  lda _var_box_saddr
  ldx _var_box_saddr+1
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
  beq _memset_full_103
_memset_loop_104:
  dey
  sta (_poke_addr),y
  bne _memset_loop_104
  beq _memset_done_102
_memset_full_103:
_memset_full_loop_105:
  sta (_poke_addr),y
  iny
  bne _memset_full_loop_105
_memset_done_102:
  lda _var_text_color
  pha
  lda _var_box_inner_w
  tay
  pla
  pha
  sty _tmp
  lda _var_box_caddr
  ldx _var_box_caddr+1
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
  beq _memset_full_107
_memset_loop_108:
  dey
  sta (_poke_addr),y
  bne _memset_loop_108
  beq _memset_done_106
_memset_full_107:
_memset_full_loop_109:
  sta (_poke_addr),y
  iny
  bne _memset_full_loop_109
_memset_done_106:
  lda _var_box_saddr
  ldx _var_box_saddr+1
  sta _tmp16
  stx _tmp16+1
  lda _var_box_w
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
  lda _var_box_caddr
  ldx _var_box_caddr+1
  sta _tmp16
  stx _tmp16+1
  lda _var_box_w
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
  lda _var_text_color
  sta (_poke_addr),y
  rts

; Procedure: putnum
putnum:
  lda _var_putnum_num
  cmp #0
  beq _skip_112
  jmp _else_110
_skip_112:
  lda #48
  sta _var_putch_ch
  jsr putch
  rts
_else_110:
  lda #0
  sta _var_putnum_count
  lda _var_putnum_num
  ldx _var_putnum_num+1
  sta _var_putnum_temp
  stx _var_putnum_temp+1
_while_113:
  lda _var_putnum_temp
  cmp #0
  beq _gt_false_115
  bcs _gt_cont_116
_gt_false_115:
  jmp _endwhile_114
_gt_cont_116:
  lda _var_putnum_temp
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
  jmp _while_113
_endwhile_114:
_while_117:
  lda _var_putnum_count
  cmp #0
  beq _gt_false_119
  bcs _gt_cont_120
_gt_false_119:
  jmp _endwhile_118
_gt_cont_120:
  dec _var_putnum_count
  lda _var_putnum_count
  tay
  lda _var_putnum_digits,y
  sta _var_putch_ch
  jsr putch
  jmp _while_117
_endwhile_118:
  rts

; Procedure: wait_line
wait_line:
_while_121:
  lda $d011
  cmp #127
  beq _gt_false_123
  bcs _gt_cont_124
_gt_false_123:
  jmp _endwhile_122
_gt_cont_124:
  jmp _while_121
_endwhile_122:
_while_125:
  lda $d012
  cmp _var_wait_line_line
  bne _skip_127
  jmp _endwhile_126
_skip_127:
  jmp _while_125
_endwhile_126:
  rts

; Main module: crt_demo
; Procedure: print_hello
print_hello:
  lda #72
  sta _var_putc_ch
  jsr putc
  lda #69
  sta _var_putc_ch
  jsr putc
  lda #76
  sta _var_putc_ch
  jsr putc
  lda #76
  sta _var_putc_ch
  jsr putc
  lda #79
  sta _var_putc_ch
  jsr putc
  lda #32
  sta _var_putc_ch
  jsr putc
  lda #87
  sta _var_putc_ch
  jsr putc
  lda #79
  sta _var_putc_ch
  jsr putc
  lda #82
  sta _var_putc_ch
  jsr putc
  lda #76
  sta _var_putc_ch
  jsr putc
  lda #68
  sta _var_putc_ch
  jsr putc
  rts

; Procedure: print_pas6510
print_pas6510:
  lda #80
  sta _var_putc_ch
  jsr putc
  lda #65
  sta _var_putc_ch
  jsr putc
  lda #83
  sta _var_putc_ch
  jsr putc
  lda #54
  sta _var_putc_ch
  jsr putc
  lda #53
  sta _var_putc_ch
  jsr putc
  lda #49
  sta _var_putc_ch
  jsr putc
  lda #48
  sta _var_putc_ch
  jsr putc
  lda #32
  sta _var_putc_ch
  jsr putc
  lda #67
  sta _var_putc_ch
  jsr putc
  lda #82
  sta _var_putc_ch
  jsr putc
  lda #84
  sta _var_putc_ch
  jsr putc
  lda #32
  sta _var_putc_ch
  jsr putc
  lda #68
  sta _var_putc_ch
  jsr putc
  lda #69
  sta _var_putc_ch
  jsr putc
  lda #77
  sta _var_putc_ch
  jsr putc
  lda #79
  sta _var_putc_ch
  jsr putc
  rts

; Procedure: print_number_label
print_number_label:
  lda #78
  sta _var_putc_ch
  jsr putc
  lda #85
  sta _var_putc_ch
  jsr putc
  lda #77
  sta _var_putc_ch
  jsr putc
  lda #66
  sta _var_putc_ch
  jsr putc
  lda #69
  sta _var_putc_ch
  jsr putc
  lda #82
  sta _var_putc_ch
  jsr putc
  lda #58
  sta _var_putc_ch
  jsr putc
  lda #32
  sta _var_putc_ch
  jsr putc
  rts

; Procedure: print_red
print_red:
  lda #82
  sta _var_putc_ch
  jsr putc
  lda #69
  sta _var_putc_ch
  jsr putc
  lda #68
  sta _var_putc_ch
  jsr putc
  lda #32
  sta _var_putc_ch
  jsr putc
  rts

; Procedure: print_green
print_green:
  lda #71
  sta _var_putc_ch
  jsr putc
  lda #82
  sta _var_putc_ch
  jsr putc
  lda #69
  sta _var_putc_ch
  jsr putc
  lda #69
  sta _var_putc_ch
  jsr putc
  lda #78
  sta _var_putc_ch
  jsr putc
  lda #32
  sta _var_putc_ch
  jsr putc
  rts

; Procedure: print_blue
print_blue:
  lda #66
  sta _var_putc_ch
  jsr putc
  lda #76
  sta _var_putc_ch
  jsr putc
  lda #85
  sta _var_putc_ch
  jsr putc
  lda #69
  sta _var_putc_ch
  jsr putc
  rts

; Procedure: main
main:
  jsr crt_init
  jsr clear
  lda #3
  sta _var_setcolor_c
  jsr setcolor
  lda #5
  sta _var_box_x
  lda #2
  sta _var_box_y
  lda #30
  sta _var_box_w
  lda #10
  sta _var_box_h
  jsr box
  lda #1
  sta _var_setcolor_c
  jsr setcolor
  lda #14
  sta _var_gotoxy_x
  lda #4
  sta _var_gotoxy_y
  jsr gotoxy
  jsr print_hello
  lda #7
  sta _var_setcolor_c
  jsr setcolor
  lda #8
  sta _var_gotoxy_x
  lda #6
  sta _var_gotoxy_y
  jsr gotoxy
  jsr print_number_label
  lda #57
  ldx #48
  sta _var_putnum_num
  stx _var_putnum_num+1
  jsr putnum
  lda #8
  sta _var_gotoxy_x
  sta _var_gotoxy_y
  jsr gotoxy
  lda #2
  sta _var_setcolor_c
  jsr setcolor
  jsr print_red
  lda #5
  sta _var_setcolor_c
  jsr setcolor
  jsr print_green
  lda #6
  sta _var_setcolor_c
  jsr setcolor
  jsr print_blue
  lda #14
  sta _var_setcolor_c
  jsr setcolor
  lda #0
  sta _var_gotoxy_x
  lda #20
  sta _var_gotoxy_y
  jsr gotoxy
  lda #64
  sta _var_hline_ch
  lda #40
  sta _var_hline_len
  jsr hline
  lda #12
  sta _var_gotoxy_x
  lda #22
  sta _var_gotoxy_y
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


; Variables
_var_memset_addr:
  .byte 0, 0
_var_memset_len:
  .byte 0
_var_memset_value:
  .byte 0
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
_var_clear_i:
  .byte 0
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
_var_hline_saddr:
  .byte 0, 0
_var_hline_caddr:
  .byte 0, 0
_var_hline_yoff:
  .byte 0, 0
_var_hline_ytmp:
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
_var_fillrect_saddr:
  .byte 0, 0
_var_fillrect_caddr:
  .byte 0, 0
_var_fillrect_yoff:
  .byte 0, 0
_var_fillrect_ytmp:
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
_var_box_saddr:
  .byte 0, 0
_var_box_caddr:
  .byte 0, 0
_var_box_yoff:
  .byte 0, 0
_var_box_ytmp:
  .byte 0
_var_box_inner_w:
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