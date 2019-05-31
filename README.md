# memo
- edit binary file by vim
  - `vim -b file.bin`
  - `:%!xxd`
  - `:%!xxd -r`
- DB : data byte
  - write 1 byte directly?
- DW : data word
  - write 2 byte (= word) directly
- DD : data double-word
  - write 4 byte (= double-word) directly

- 1 sector = 512byte (floppy disk)

- boot sector
  - PC reads first sector
  - then reads last 2 bytes of the first sector
  - if the 2 bytes are 0x55, 0xaa, PC starts from first (= boot) sector

- ORG : alters the location counter
- JMP : jump
- MOV AX, 0 : AX = 0
- CPU 16 bit registers
  - AX : accumulator AH(15-8 bit) + AL(7-0 bit)
  - CX : counter
  - DX : data
  - BX : base
  - SP : stack pointer
  - BP : base pointer
  - SI : source index
  - DP : destination index
- CPU 8 bit registers
  - AL : accumulator low
  - CL : counter low
  - DL : data low
  - BL : base low
  - AH : accumulator high
  - CH : counter high
  - DH : data high
  - BH : base high

- CPU 32 bit register
  - EAX : accumulator 16 bit(no register name) + AX(15-0 bit)
  - ECX : counter
  - EDX : data
  - EBX : base
  - ESP : stack pointer
  - EBP : base pointer
  - ESI : source index
  - EDP : destination index
  - when you use higher bit of EAX, you need to shift 8 bits

- Segment register (16 bit)
  - ES : extra segment
  - CS : code segment
  - SS : stack segment
  - DS : data segment
  - FS : (no name) extra segment
  - GS : (no name) extra segment

- MOV WORD [678], 123
  - 123 = 0x0000000001111011 = 00000000 01111011
  - 01111011 stores address 678
  - 00000000 stores address 679
  - we can use BX, BP, SI, DI for indicating address

- ADD SI, 1 : SI + 1
- CMP : compare
- JE jump if equal
- INT : interrupt
  - INT 0x10 : BIOS interrupt call. video services
- JC : jump if carry. Jump, if carry flag is 1

- floppy disk has 80 cylinders
- 18 sectors in 1 cylinder
- the disk have front and back
- floppy disk is 1440KB(80 * 2 * 18 * 512KB)

- MOV AL, [ES:BX] : ES * 16 + BX
- if we don't use segment register when decide which memory address, the default segment is DS
  - MOV AL, [SI] = MOV AL, [DS:SI]

- JBE : jump if below or equal
- JB : jump if below
- CYLS EQU 10 : CYLS=10
- EQU : equal

- DB,DW,DD and ORG are not CPU instruction
- BIOS can use only 16 bit mode

- VRAM = video RAM
  - それぞれの番地が画面上の画素に対応していて、これを利用することで画面に絵を出すことができる

- I wanna create haribote-OS by rust.
  - To do this, I create it by C following the book.

- when 32 bit mode, we can use EAX, ECX, EDX freely

- ビデオDAコンバータにおけるパレットのアクセス手順
  - 割り込みを禁止する
  - 0x03c8に設定したいパレット番号を書き込み、RGBの順に0x03c9に書き込む.　連続書き込み可能。
  - 現在のパレット状態を読み出すときは、まず0x03c7にパレット番号を書き込んで、0x03c9に書き込む。RGBの順に読み出しが可能で連続読み出しも可能。
  - 割り込みを許可させる。

- 座標を(x,y)としたときに，VRAMの番地はそれぞれ(0,0),(0,1),(0,2)...(0,319),(1,0),(1,1)...の画素に対応しているってことです．なので，(x,y)に書き込もうと思ったら0xa0000+x+y*320に書き込めばいい
