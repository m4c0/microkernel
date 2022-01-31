ENTRY(start)
INPUT(bootstrap.o)
INPUT(mbr.o)
SECTIONS {
  .text : {
    *(mbr);
    *(.text);
  }
}

