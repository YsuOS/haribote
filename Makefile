CC = gcc
CFLAGS = -c -m32 -march=i486 -nostdlib

default:
	make img

convHankakuTxt : convHankakuTxt.c
	gcc $< -o $@ # $< : 最初の依存するファイルの名前, $@ : ターゲットファイル名

hankaku.c : hankaku.txt convHankakuTxt
	./convHankakuTxt

ipl10.bin : ipl10.asm Makefile
	nasm ipl10.asm -o ipl10.bin -l ipl10.lst

asmhead.bin : asmhead.asm Makefile
	nasm asmhead.asm -o asmhead.bin -l asmhead.lst

nasmfunc.o : nasmfunc.asm Makefile
	nasm -g -f elf nasmfunc.asm -o nasmfunc.o -l asmfunc.lst

#hankaku.o : hankaku.c
#	gcc -march=i486 -m32 -nostdlib hankaku.c -o hankaku.o

bootpack.o : bootpack.c
	$(CC) $(CFLAGS) bootpack.c -o bootpack.o

#mysprintf.o : mysprintf.c
#	gcc -march=i486 -m32 -nostdlib $^ -o $@

bootpack.hrb : bootpack.c har.ld hankaku.c nasmfunc.o mysprintf.c Makefile
	gcc -march=i486 -m32 -nostdlib -fno-pie -T har.ld bootpack.c nasmfunc.o hankaku.c mysprintf.c -o bootpack.hrb

haribote.sys : asmhead.bin bootpack.hrb  Makefile
	cat asmhead.bin bootpack.hrb > haribote.sys

haribote.img : ipl10.bin haribote.sys Makefile
	mformat -f 1440 -C -B ipl10.bin -i haribote.img ::
	mcopy haribote.sys -i haribote.img ::

asm :
	make -r ipl10.bin

img :
	make -r haribote.img

run :
	make img
	qemu-system-i386 -fda haribote.img

clean:
	rm *.bin *.lst *.sys *.img *.hrb *.o
	rm hankaku.c
	rm convHankakuTxt
