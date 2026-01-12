; pas6510 compiled program: irq_test
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

; Main module: irq_test
; Procedure: main
main:
  sei
  lda #0
  sta $d020
  cli
  rts


; Variables