ENTRY(start)
INPUT(mbr.o)

/* 0x7c00 */
SECTIONS {
  .text 0x7c00 : {
    mbr.o(.text.short);
    . = 0x7d00;
    mbr.o(.text.long);
  }
  .data : {
    *(.data);
  }
  magic 0x7dfe : {
    BYTE(0x55);
    BYTE(0xAA);

    bootstrap_sec_count = 1 + bootstrap_size / 512;
    bootstrap_start = .;
  }
}

