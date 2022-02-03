LLVM_DIR=/usr/local/opt/llvm/bin
CLANG=${LLVM_DIR}/clang
LD=${LLVM_DIR}/ld.lld

TARGET=x86_64-pc-none-eabi
LDTARGET=elf_x86_64

CXXFLAGS=-O3 -ffreestanding -target ${TARGET}

.PHONY: all clean debug run

all: disk.bin

run: disk.bin
	qemu-system-x86_64 -boot c -drive file=disk.bin,format=raw

debug: disk.bin
	qemu-system-x86_64 -boot c -s -S -drive file=disk.bin,format=raw &
	lldb --one-line 'gdb-remote 1234'

disk.bin: mbr.bin bootstrap.bin
	cat mbr.bin bootstrap.bin > disk.bin

mbr.bin: mbr.o mbr.ld bootstrap.bin
	${LD} -m ${LDTARGET} -o mbr.bin -T mbr.ld --oformat binary --defsym bootstrap_size=$(shell stat -f '%z' bootstrap.bin)

mbr.o: mbr.s
	${CLANG} -target ${TARGET} -c -o mbr.o mbr.s

bootstrap.bin: bootstrap.o something.o linker.ld
	${LD} -m ${LDTARGET} -o bootstrap.bin -T linker.ld --oformat binary

clean:
	rm -f *.bin *.o

%.o: %.cpp
	${CLANG} ${CXXFLAGS} -c -o $@ $<

