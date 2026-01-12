; pas6510 compiled program: noise
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

; Main module: noise
; Procedure: main
main:
  sei
_while_0:
  lda #1
  bne _skip_2
  jmp _endwhile_1
_skip_2:
  dec $d418
  jmp _while_0
_endwhile_1:
  rts


; Variables
_var_memset_addr:
  .byte 0, 0
_var_memset_len:
  .byte 0
_var_memset_value:
  .byte 0