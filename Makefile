LLVM_DIR=/usr/local/opt/llvm/bin
CLANG=${LLVM_DIR}/clang
LD=${LLVM_DIR}/ld.lld

TARGET=x86_64-pc-none-eabi
LDTARGET=elf_x86_64

CXXFLAGS=-O3 -ffreestanding -target ${TARGET}

.PHONY: all clean

all: disk

run: disk
	qemu-system-x86_64 -boot c -drive file=disk,format=raw

debug: disk
	qemu-system-x86_64 -boot c -s -S -drive file=disk,format=raw &
	lldb --one-line 'gdb-remote 1234'

disk: linker.ld bootstrap.o mbr.o
	${LD} -m ${LDTARGET} -o disk -T linker.ld --no-dynamic-linker --oformat binary

mbr.o: mbr.s
	${CLANG} -target ${TARGET} -c -o mbr.o mbr.s

bootstrap.o: bootstrap.cpp
	${CLANG} ${CXXFLAGS} -c -o bootstrap.o bootstrap.cpp

clean:
	rm -f bootstrap.o mbr.o disk
