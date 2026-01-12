; pas6510 compiled program: border_flash
;

  .org $0801

; BASIC stub: 10 SYS 2061
  .byte $0b, $08, $0a, $00, $9e, $32, $30, $36, $31, $00, $00, $00

; Program start
start:
  jsr main
  rts

; Module: sys
; Procedure: irq_disable
irq_disable:
  rts

; Module: crt
; Procedure: wait_line
wait_line:
_while_0:
  lda $d011
  cmp #127
  beq _gt_false_2
  bcs _gt_cont_3
_gt_false_2:
  jmp _endwhile_1
_gt_cont_3:
  jmp _while_0
_endwhile_1:
_while_4:
  lda $d012
  cmp _var_wait_line_line
  bne _skip_6
  jmp _endwhile_5
_skip_6:
  jmp _while_4
_endwhile_5:
  rts

; Main module: border_flash
; Procedure: main
main:
  sei
_while_7:
  lda #1
  bne _skip_9
  jmp _endwhile_8
_skip_9:
  lda #100
  sta _var_main_y
_for_10:
  lda _var_main_y
  sta _var_wait_line_line
  jsr wait_line
  lda #1
  sta $d020
  lda #0
  sta _var_main_i
_for_12:
  inc _var_main_i
  lda _var_main_i
  bne _for_12
_endfor_13:
  lda #0
  sta $d020
  inc _var_main_y
  lda _var_main_y
  cmp #201
  beq _endfor_11
  jmp _for_10
_endfor_11:
  jmp _while_7
_endwhile_8:
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
_var_wait_line_line:
  .byte 0
_var_main_y:
  .byte 0
_var_main_i:
  .byte 0