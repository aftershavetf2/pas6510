; pas6510 compiled program: screen_memory_chaos
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
sys_irq_disable:
  rts

; Main module: screen_memory_chaos
; Procedure: main
main:
  sei
  lda #0
  sta _var_main_x
_while_0:
  lda #1
  bne _skip_2
  jmp _endwhile_1
_skip_2:
  lda #0
  sta _var_main_x
_for_3:
  lda #0
  sta _var_main_i
_for_5:
  ldy _var_main_i
  lda _var_main_x
  sta $0400,y
  sta $0500,y
  sta $0600,y
  sta $0700,y
  inc _var_main_i
  lda _var_main_i
  bne _for_5
_endfor_6:
  inc _var_main_x
  lda _var_main_x
  bne _for_3
_endfor_4:
  jmp _while_0
_endwhile_1:
  rts


; Variables
_var_main_i:
  .byte 0
_var_main_x:
  .byte 0