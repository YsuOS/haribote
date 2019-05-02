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
  - then reads last 2 sectors
  - if the 2 sectors are 0x55, 0xaa, PC starts from first (= boot) sector?

