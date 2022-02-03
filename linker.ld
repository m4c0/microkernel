ENTRY(boot)
INPUT(bootstrap.o)
INPUT(something.o)

SECTIONS {
  .text : AT(0x7e00) {
    bootstrap.o(.text);
    something.o(.text);
  }
  .shstrtab : { *(.shstrtab); }
  /DISCARD/ : {
    *(.*);
  }
}

