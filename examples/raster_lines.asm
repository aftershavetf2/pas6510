; pas6510 compiled program: raster_lines
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

; Main module: raster_lines
; Procedure: main
main:
  sei
_while_0:
  lda $d012
  sta $d020
  jmp _while_0
_endwhile_1:
  rts


; Variables