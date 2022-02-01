  .code16
start:
  cli
  xorw %ax, %ax
  movw %ax, %ss
  movw $0x7c00, %sp

  movw $0x0201, %ax
  movw $0x0002, %cx
  movw $0x0080, %dx

  movw $0xb800, %bx
  movw %bx, %es
  xorw %bx, %bx
  int $0x13

halt:
  hlt
  jmp halt

.org 510
.short 0xAA55
