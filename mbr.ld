ENTRY(start)
INPUT(mbr.o)

/* 0x7c00 */
SECTIONS {
  .text : {
    bootstrap_sec_count = 1 + bootstrap_size / 512;
    mbr.o(.text);
  }
}

