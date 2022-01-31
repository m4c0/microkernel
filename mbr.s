.section mbr
  cli
halt:
  hlt
  jmp halt

.org 510
.short 0xAA55
