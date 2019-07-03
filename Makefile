CC = gcc
CFLAGS = -m32 -march=i486 -nostdlib

default:
	make img

convHankakuTxt : convHankakuTxt.c
	$(CC) $< -o $@

hankaku.c : hankaku.txt convHankakuTxt
	./convHankakuTxt

ipl10.bin : ipl10.asm
	nasm $< -o $@ -l ipl10.lst

asmhead.bin : asmhead.asm
	nasm $< -o $@ -l asmhead.lst

nasmfunc.o : nasmfunc.asm
	nasm -g -f elf $< -o $@ -l nasmfunc.lst

bootpack.hrb : bootpack.c har.ld hankaku.c nasmfunc.o mysprintf.c graphic.c dsctbl.c
	$(CC) $(CFLAGS) -fno-pie -T har.ld bootpack.c nasmfunc.o hankaku.c mysprintf.c graphic.c dsctbl.c -o bootpack.hrb

#bootpack.o : bootpack.c
#	$(CC) $(CFLAGS) $< -o $@
#hankaku.o : hankaku.c
#	$(CC) $(CFLAGS) $< -o $@
#mysprintf.o : mysprintf.c
#	$(CC) $(CFLAGS) $^ -o $@
#graphic.o : graphic.c
#	$(CC) $(CFLAGS) $< -o $@
#dsctbl.o : dsctbl.c
#	$(CC) $(CFLAGS) $< -o $@
#
#OBJS_BOOTPACK = bootpack.o hankaku.o nasmfunc.o mysprintf.o graphic.o dsctbl.o
#
#bootpack.hrb : $(OBJS_BOOTPACK) har.ld
#	ld -m elf_i386 -T har.ld $(OBJS_BOOTPACK) -o $@

haribote.sys : asmhead.bin bootpack.hrb
	cat asmhead.bin bootpack.hrb > haribote.sys

haribote.img : ipl10.bin haribote.sys
	mformat -f 1440 -C -B ipl10.bin -i haribote.img ::
	mcopy haribote.sys -i haribote.img ::

img :
	make haribote.img

run :
	make img
	qemu-system-i386 -fda haribote.img
clean:
	rm *.bin *.lst *.sys *.img *.hrb *.o
	rm hankaku.c
	rm convHankakuTxt
