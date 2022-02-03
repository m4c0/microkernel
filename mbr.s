  # This MBR is meant to "just work" in a QEMU environment.

  # If some insane mind wants to use it on real hardware, there is a lot of
  # heavylifting to do: setup segments, test CPUID, etc. Or just use a
  # modern bootloader if you just want to boot the kernel and you don't
  # care about the MBR.

  # This MBR does the bare minimal to load "bootstrap" and run it with a
  # clean 64-bit ("long mode") enviroment, suitable for C/C++ code.

  .section .text.short
  .code16
start:
  cli

  # Setup stack
  movw $0x7c00, %sp

  # Set mode (also clear screen, also also funny 40x25 screen)
  xorw %ax, %ax
  int $0x10

  # Print debug string
  movw $0x1300, %ax # 13="puts" 00=dont update cursor
  movw $0x000F, %bx # page 0 + attributes
  movw $hello_len, %cx
  xorw %dx, %dx
  movw $hello, %bp
  int $0x10

  # Load bootstrap from the beginning of first disk 
  movb $0x42, %ah
  movb $0x80, %dl
  movw $disk_addr_pkt, %si
  int $0x13

  # Configure PAE tables
  movl $0x1000, %edi # PDPT at 0x1000
  movl %edi, %cr3

  movl $0x2001, (%edi) # PDT at 0x2000 (1 = Present)
  addw $0x1000, %di
  movl $0x83, (%edi) # Single 2M page (0x80), present+RW (0x3)

  # Disable all IRQs
  movb $0xff, %al
  outb %al, $0xa1
  outb %al, $0x21

  # Enable PAE (physical address extension) and Page Global
  movl $0xa0, %eax
  movl %eax, %cr4

  # Enable long-mode in the EFER MSR
  movl $0xc0000080, %ecx
  rdmsr
  or $0x100, %eax
  wrmsr

  # Enable paging (bit 31) and protected mode (bit 0)
  movl %cr0, %ebx
  or $0x80000001, %ebx
  movl %ebx, %cr0

  # Engage!
  lidt idt_ptr
  lgdt gdt_ptr
  jmpl $0x08, $halt

disk_addr_pkt:
  .byte 0x10 # size
  .byte 0x0  # reserved
  .word bootstrap_sec_count
  .long bootstrap_start
  .quad 1 # First sector to read

  .section .text.long
  .code64
halt:
  movq $0xb8000, %rdi
  movq $0x1f201f201f201f20, %rax
  movq $250, %rcx
  rep stosq
  hlt
  jmp halt

  .data
hello:
  .ascii "Hello from MBR..."
  .equ hello_len, . - hello

  .align 8
gdt:
  .quad 0                  # null descriptor
  .quad 0x00209A0000000000 # code (r/x), ring 0, long
  .quad 0x0000920000000000 # data (r/w), ring 0 (can't be long)

  .align 4
gdt_ptr:
  .short . - gdt - 1 # Length
  .long gdt          # Base

  .align 4
idt_ptr:
  .short 0  # Length
  .long 0   # Base

