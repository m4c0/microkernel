  .code16
start:
  cli
  movw $0xb800, %bx
  movw %bx, %es
  xorw %di, %di
  movb $0x40, %al
  movw $10, %cx
  rep stosb
halt:
  hlt
  jmp halt

.org 510
.short 0xAA55
