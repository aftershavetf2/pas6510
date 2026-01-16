; pas6510 compiled program: loops
;

  .org $0801

; BASIC stub: 10 SYS 2061
  .byte $0b, $08, $0a, $00, $9e, $32, $30, $36, $31, $00, $00, $00

; Program start
start:
  jsr main
  rts

; Main module: loops
; Procedure: main
main:
  lda #0
  sta _var_main_i
_for_0:
  inc _var_main_i
  lda _var_main_i
  cmp #11
  beq _endfor_1
  jmp _for_0
_endfor_1:
  rts


; Variables
_var_main_i:
  .byte 0