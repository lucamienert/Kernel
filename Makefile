ASM_FILES = $(wildcard boot/*.s)
C_SOURCES = $(wildcard kernel/*.c)
HEADERS = $(wildcard include/kernel/*.h)

C_OBJ_FILES = ${C_SOURCES:.c=.o}
ASM_OBJ_FILES = ${ASM_FILES:.s=.o}

OBJ_FILES = ${C_SOURCES:.c=.o}
OBJ_FILES += ${ASM_FILES:.s=.o}

C_FLAGS = -m32 -ffreestanding -Wall -Iinclude -nostdlib -nostdinc -fno-builtin -fno-stack-protector

OUTPUT_ISO = LumaOS.iso

all: multiboot buildgrub run

%.o: %.s
	$(info [asm] $@)
	nasm -f elf32 $< -o $@

%.o: %.c ${HEADERS}
	$(info [c] $@)
	x86_64-elf-gcc -g ${C_FLAGS} -c $< -o $@

LumaOS.bin: ${ASM_OBJ_FILES} ${C_OBJ_FILES}
	x86_64-elf-ld -m elf_i386 -Tlinker.ld -o $@ $^ -nostdlib

multiboot: LumaOS.bin
	grub-file --is-x86-multiboot $<

buildgrub: LumaOS.bin
	mkdir -p bin/boot/grub
	cp $< bin/boot/$<
	cp grub.cfg bin/boot/grub/grub.cfg
	grub-mkrescue -o ${OUTPUT_ISO} bin

run:
	@echo "[Makefile]: Running the ISO"
	qemu-system-i386 -cdrom ${OUTPUT_ISO} -display gtk -serial mon:stdio

${OUTPUT_ISO}:
	$(info [all] writing $@)
	@grub-mkrescue -o ${OUTPUT_ISO} bin

qemu: ${OUTPUT_ISO}
	qemu-system-x86_64 -cdrom ${OUTPUT_ISO}

clean:
	rm kernel/*.o
	rm boot/*.o