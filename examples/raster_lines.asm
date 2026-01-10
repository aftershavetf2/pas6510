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
; Procedure: irq_enable
irq_enable:
  rts

; Procedure: irq_disable
irq_disable:
  rts

; Main module: raster_lines
; Procedure: main
main:
  sei
_while_0:
  lda #1
  bne _skip_2
  jmp _endwhile_1
_skip_2:
  lda #18
  ldx #208
  sta _poke_addr
  stx _poke_addr+1
  ldy #0
  lda (_poke_addr),y
  sta _var_line
  lda #32
  ldx #208
  sta _poke_addr
  stx _poke_addr+1
  lda _var_line
  ldy #0
  sta (_poke_addr),y
  jmp _while_0
_endwhile_1:
  rts


; Runtime library

_tmp: .byte 0, 0
_tmp16: .byte 0, 0

_poke_addr = $fb  ; ZP location for indirect addressing

_mul_a: .byte 0
_mul_b: .byte 0
_multiply:
  lda #0
  ldx #8
_mul_loop:
  lsr _mul_b
  bcc _mul_skip
  clc
  adc _mul_a
_mul_skip:
  asl _mul_a
  dex
  bne _mul_loop
  rts

_div_a: .byte 0
_div_b: .byte 0
_divide:
  ldx #0
  lda _div_a
_div_loop:
  cmp _div_b
  bcc _div_done
  sec
  sbc _div_b
  inx
  jmp _div_loop
_div_done:
  stx _tmp
  lda _tmp
  rts

; write_u16_ln - print 16-bit number and newline
_print_val: .byte 0, 0
_print_buf: .byte 0, 0, 0, 0, 0, 0
write_u16_ln:
  sta _print_val
  stx _print_val+1
  ; Convert to decimal string
  ldy #0
_p16_loop:
  lda _print_val
  ora _print_val+1
  beq _p16_print
  ; Divide by 10
  jsr _div16_10
  ; Remainder (0-9) is in A
  clc
  adc #$30
  sta _print_buf,y
  iny
  jmp _p16_loop
_p16_print:
  cpy #0
  bne _p16_hasdigits
  lda #$30  ; print '0' if value was 0
  jsr $ffd2
  jmp _p16_newline
_p16_hasdigits:
_p16_printloop:
  dey
  lda _print_buf,y
  jsr $ffd2  ; CHROUT
  cpy #0
  bne _p16_printloop
_p16_newline:
  lda #13
  jsr $ffd2
  rts

_div16_10:
  lda #0
  ldx #16
_d10_loop:
  asl _print_val
  rol _print_val+1
  rol a
  cmp #10
  bcc _d10_skip
  sbc #10
  inc _print_val
_d10_skip:
  dex
  bne _d10_loop
  ; Remainder in A, quotient in _print_val
  rts

; Variables
_var_line:
  .byte 0