ENTRY(boot)
INPUT(bootstrap.o)

SECTIONS {
  .text 0x100000 : AT(0xc00000) {
    *(.text);
  }
  /DISCARD/ : {
    *(.comment);
  }
}

