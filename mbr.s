  .code16
start:
  cli

  # Setup stack
  xorw %ax, %ax
  movw %ax, %ss
  movw $0x7c00, %sp

  # Set mode (also clear screen, also also funny 40x25 screen)
  xorw %ax, %ax
  int $0x10

  # Print debug string
  movw $0x1301, %ax # 13="puts" 01=update cursor
  movw $0x000F, %bx # page 0 + attributes
  movw $hello_len, %cx
  xorw %dx, %dx
  movw $hello, %bp
  int $0x10

  # Load bootstrap from the beginning of first disk 
  movb $0x02, %ah
  movb $bootstrap_sec_count, %al
  movw $0x0002, %cx
  movw $0x0080, %dx

  # Use the video memory as a buffer and a visual feedback 
  movw $0xb820, %bx
  movw %bx, %es
  xorw %bx, %bx
  int $0x13

halt:
  hlt
  jmp halt

  .org 0x1e0
hello_data:
  .ascii "Hello from MBR..."
  .equ hello_len, . - hello_data
  .equ hello, hello_data + 0x7c00

.org 510
.short 0xAA55
