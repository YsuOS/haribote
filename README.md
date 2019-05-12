nasm A.asm -o A.img

# memo
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

