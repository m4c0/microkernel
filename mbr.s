  .code16
start:
  cli

  # Setup stack
  xorw %ax, %ax
  movw %ax, %ss
  movw $0x7c00, %sp

  # Load bootstrap from the beginning of first disk 
  movb $0x02, %ah
  movb $bootstrap_sec_count, %al
  movw $0x0002, %cx
  movw $0x0080, %dx

  # Use the video memory as a buffer and a visual feedback 
  movw $0xb800, %bx
  movw %bx, %es
  xorw %bx, %bx
  int $0x13

halt:
  hlt
  jmp halt

.org 510
.short 0xAA55
