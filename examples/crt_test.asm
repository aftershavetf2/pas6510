; pas6510 compiled program: crt_test
;

  .org $0801

; BASIC stub: 10 SYS 2061
  .byte $0b, $08, $0a, $00, $9e, $32, $30, $36, $31, $00, $00, $00

; Program start
start:
  jsr main
  rts

; Module: sys
; Module: crt
; Procedure: crt_init
crt_crt_init:
  lda #0
  sta _var_crt_cursor_x
  sta _var_crt_cursor_y
  lda #14
  sta _var_crt_text_color
  rts

; Procedure: clear
crt_clear:
  lda #0
  sta _var_crt_clear_i
_for_0:
  ldy _var_crt_clear_i
  lda #32
  sta $0400,y
  sta $0500,y
  sta $0600,y
  sta $0700,y
  lda _var_crt_text_color
  sta $d800,y
  sta $d900,y
  sta $da00,y
  sta $db00,y
  inc _var_crt_clear_i
  lda _var_crt_clear_i
  beq _endfor_1
  jmp _for_0
_endfor_1:
  lda #0
  sta _var_crt_cursor_x
  sta _var_crt_cursor_y
  rts

; Main module: crt_test
; Procedure: main
main:
  jsr crt_crt_init
  jsr crt_clear
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
_var_crt_cursor_x:
  .byte 0
_var_crt_cursor_y:
  .byte 0
_var_crt_text_color:
  .byte 0
_var_crt_clear_i:
  .byte 0
_var_main_addr:
  .byte 0, 0