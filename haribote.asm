; haribote-os
; TAB=4

; BOOT_INFO関係
CYLS    EQU     0x0ff0      ; ブートセクタが設定する この辺のメモリは誰も使っていないからOK
LEDS    EQU     0x0ff1
VMODE   EQU     0x0ff2      ; 色数に関する情報(何ビットカラーか)
SCRNX   EQU     0x0ff4      ; 解像度(screen x)
SCRNY   EQU     0x0ff6      ; 解像度(screen y)
VRAM    EQU     0x0ff8      ; グラフィックバッファの開始番地

        ORG     0xc200      ; 0xc200 <- 0x8000 + 0x4200
                            ; Where on memory this program will be loaded
        MOV     AL, 0x13    ; VGA graphics, 320x200x8bit
        MOV     AH, 0x00
        INT     0x10        ; 画面モード切り替えビデオBIOS
        
        MOV     BYTE [VMODE], 8     ; 画面モードをメモする
        MOV     WORD [SCRNX], 320
        MOV     WORD [SCRNY], 200
        MOV     DWORD [VRAM], 0x000a0000 ; VRAMは色んな所にmappingされてる、この画面モードでは0x000a0000 - 0x000affff の64KB
        
; LED state on keyboardをBIOSから教えてもらう

        MOV     AH, 0x02
        INV     0x16        ; keyboard BIOS
        MOV     [LEDS], AL

fin:
    HLT
    JMP     fin
