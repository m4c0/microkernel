ENTRY(start)
INPUT(bootstrap.o)
INPUT(mbr.o)

/* 0x7c00 */
SECTIONS {
  .text : {
    mbr.o(.text);
    bootstrap.o(.text);
  }
}

