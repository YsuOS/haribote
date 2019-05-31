; nasmfunc.asm
; TAB=4

section .text
    GLOBAL  io_hlt, io_cli, io_sti, io_stihlt
    GLOBAL  io_in8, io_in16, io_in32
    GLOBAL  io_out8, io_out16, io_out32
    GLOBAL  io_load_eflags, io_store_eflags


io_hlt:             ; void io_hlt(void);
    HLT
    RET             ; return

io_cli:             ; void io_cli(void);
    CLI
    RET

io_sti:             ; void io_sti(void);
    STI
    RET

io_stihlt:             ; void io_stihlt(void);
    STI
    HLT
    RET

/*
 * write_mem8:      ; void write_mem8(int addr, int data);
 *      MOV     ECX, [ESP+4]    ; [ESP+4]にaddrが入っているのでそれをECXに読み込む
 *      MOV     AL, [ESP+8]     ; [ESP+8]にdataが入っているのでそれをALに読み込む
 *      MOV     [ECX], AL
 *      RET
 */
io_in8:             ; int io_in8(int port);
    MOV     EDX, [ESP+4]    ; port
    MOV     EAX, 0
    IN      AL, DX
    RET

io_in16:             ; int io_in16(int port);
    MOV     EDX, [ESP+4]    ; port
    MOV     EAX, 0
    IN      AX, DX
    RET

io_in32:             ; int io_in32(int port);
    MOV     EDX, [ESP+4]    ; port
    IN      EAX, DX
    RET

io_out8:             ; int io_out8(int port);
    MOV     EDX, [ESP+4]    ; port
    MOV     AL, [ESP+8]
    OUT     DX, AL
    RET

io_out16:             ; int io_out16(int port);
    MOV     EDX, [ESP+4]    ; port
    MOV     EAX, [ESP+8]
    OUT     DX, AX
    RET

io_out32:             ; int io_out32(int port);
    MOV     EDX, [ESP+4]    ; port
    MOV     EAX, [ESP+8]    
    OUT     DX, EAX
    RET

io_load_eflags:        ; int io_load_eflags(void);
    PUSHFD              ; PUSH EFLAGSという意味
    POP     EAX
    RET                 ; C言語の規約では、RETしたときにEAXに入っていた値が関数の値とみなされる。

io_store_eflags:        ; int io_store_eflags(int eflags);
    MOV     EAX, [ESP+4]
    PUSH    EAX
    POPFD              ; POP EFLAGSという意味
    RET
