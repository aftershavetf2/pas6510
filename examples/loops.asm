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
; Procedure: while_1
while_1:
_while_0:
  lda _var_while_1_i
  cmp #10
  bcc _skip_2
  jmp _endwhile_1
_skip_2:
  inc _var_while_1_i
  jmp _while_0
_endwhile_1:
  rts

; Procedure: main
main:
  lda #0
  sta _var_main_i
_for_3:
  inc _var_main_i
  lda _var_main_i
  cmp #11
  beq _endfor_4
  jmp _for_3
_endfor_4:
  lda #0
  sta _var_main_i
_for_5:
  inc _var_main_i
  lda _var_main_i
  cmp #21
  beq _endfor_6
  jmp _for_5
_endfor_6:
  rts


; Variables
_var_while_1_i:
  .byte 0
_var_main_i:
  .byte 0