default:
	make img

ipl.bin : ipl.asm Makefile
	nasm ipl.asm -o ipl.bin -l ipl.lst

hariote.sys : haribote.asm Makefile
	nasm	haribote.asm -o haribote.sys -l haribote.lst

haribote.img : ipl.bin haribote.sys Makefile
	mformat -f 1440 -C -B ipl.bin -i haribote.img ::
	mcopy haribote.sys -i haribote.img ::

asm :
	make -r ipl.bin

img :
	make -r haribote.img

run :
	make img
	qemu-system-i386 -fda haribote.img
clean:
	rm ipl.bin
	rm ipl.lst
	rm haribote.sys
	rm haribote.lst

src_only :
	make clean
	rm haribote.img
