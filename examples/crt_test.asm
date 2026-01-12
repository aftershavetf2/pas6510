; pas6510 compiled program: crt_test
;

  .org $0801

; BASIC stub: 10 SYS 2061
  .byte $0b, $08, $0a, $00, $9e, $32, $30, $36, $31, $00, $00, $00

; Program start
start:
  jsr main
  rts

; Main module: crt_test
; Procedure: main
main:
  lda #0
  ldx #4
  sta _var_main_addr
  stx _var_main_addr+1
  lda _var_main_addr
  ldx _var_main_addr+1
  sta _poke_addr
  stx _poke_addr+1
  lda #1
  ldy #0
  sta (_poke_addr),y
  ldx #4
  sta _var_main_addr
  stx _var_main_addr+1
  lda _var_main_addr
  ldx _var_main_addr+1
  sta _poke_addr
  stx _poke_addr+1
  lda #2
  sta (_poke_addr),y
  ldx #4
  sta _var_main_addr
  stx _var_main_addr+1
  lda _var_main_addr
  ldx _var_main_addr+1
  sta _poke_addr
  stx _poke_addr+1
  lda #3
  sta (_poke_addr),y
  lda #40
  ldx #4
  sta _var_main_addr
  stx _var_main_addr+1
  lda _var_main_addr
  ldx _var_main_addr+1
  sta _poke_addr
  stx _poke_addr+1
  lda #4
  sta (_poke_addr),y
  lda #0
  ldx #216
  sta _var_main_addr
  stx _var_main_addr+1
  lda _var_main_addr
  ldx _var_main_addr+1
  sta _poke_addr
  stx _poke_addr+1
  lda #1
  sta (_poke_addr),y
  rts


; Runtime library

_poke_addr = $fb  ; ZP location for indirect addressing


; Variables
_var_main_addr:
  .byte 0, 0