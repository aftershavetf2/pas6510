; pas6510 compiled program: test_loop_nested
;

  .org $0801

; BASIC stub: 10 SYS 2061
  .byte $0b, $08, $0a, $00, $9e, $32, $30, $36, $31, $00, $00, $00

; Program start
start:
  jsr main
  rts

; Main module: test_loop_nested
; Procedure: main
main:
  lda #0
  sta _var_main_i
_for_0:
  lda #0
  sta _var_main_j
_for_2:
  inc _var_main_j
  lda #$00
_var_main_j = *-1
  cmp #6
  beq _endfor_3
  jmp _for_2
_endfor_3:
  inc _var_main_i
  lda #$00
_var_main_i = *-1
  cmp #11
  beq _endfor_1
  jmp _for_0
_endfor_1:
  rts


; Variables