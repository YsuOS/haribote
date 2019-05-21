; hello-os

CYLS    EQU     10          ; どこまで読み込むか？

        ORG     0x7c00              ; このプログラムがメモリ上のどこに読み込まれるか？

; description for floppy disk
        JMP     entry
        DB      0x90
        DB      "HELLOIPL"
        DW      512
        DB      1
        DW      1
        DB      2
        DW      224
        DW      2880
        DB      0xf0
        DW      9
        DW      18
        DW      2
        DD      0
        DD      2880
; FAT12/16におけるオフセット36以降のフィールド
        DB      0,0,0x29

        DD      0xffffffff
        DB      "HELLO-OS   "
        DB      "FAT12   "
        TIMES   18 DB 0

; START BS_BootCode 64(0x14) 448(0x1C0) 
entry:
        MOV     AX, 0           ; initialize Accumulator
        MOV     SS, AX          ; Stack Segment
        MOV     SP, 0x7c00      ; Stack Pointer
        MOV     DS, AX          ; Data Segment

; load disk
        MOV     AX, 0x0820
        MOV     ES, AX              ; buffer address    0x0820
        MOV     CH, 0               ; cylinder  0
        MOV     DH, 0               ; head      0
        MOV     CL, 2               ; sector    2

readloop:
        MOV     SI, 0           ; 失敗回数を数えるレジスタ

retry:
        MOV     AH, 0x02        ; accumulator high  : 0x02 - read disk
        MOV     AL, 1           ; accumulator low   : sector
        MOV     BX, 0           ; buffer address    0x0000
                                ; ES:BX ESは代入済み
        MOV     DL, 0x00        ; data low          : drive number
        INT     0x13            ; BIOS  call
        JNC     next            ; jump if not carry
        
        ADD     SI, 1           ; increment SI
        CMP     SI, 5
        JAE     error           ; SI >= 5 then jump to error
    
        MOV     AH, 0x00        ; 0x00 - reset
        MOV     DL, 0x00        ; A drive
        INT     0x13            ; reset drive
        JMP     retry

next:
        ; add 0x20 to ES
        ; = ADD BX 512
        MOV     AX, ES          ; 0x20だけアドレスを進める
        ADD     AX, 0x0020      ; 512 / 16 = 0x20
        MOV     ES, AX
    
        ; increment CL (sector number)
        ADD     CL, 1
        CMP     CL, 18
        JBE     readloop
    
        ; ディスクのウラ面
        MOV     CL, 1           ; reset sector
        ADD     DH, 1           ; reverse HEAD
        CMP     DH, 2
        JB      readloop
    
        ; next Cylinder
        MOV     DH, 0           ; reset HEAD
        ADD     CH, 1           ; cylinder += 1
        CMP     CH, CYLS
        JB      readloop

; ブートセクタの読み込みが終わったので、OSを実行
        MOV     [0x0ff0], CH        ; IPLがどこまで読んだのかメモ
        JMP     0xc200

error:
        MOV     SI, msg

putloop:
        MOV     AL, [SI]        ; BYTE (accumulator low)
        ADD     SI, 1           ; increment
        CMP     AL, 0           ; 終了条件
        JE      fin             ; jump to fin if equal to 0
    
        MOV     AH, 0x0e        ; 1 char-function
        MOV     BX, 15          ; color code
        INT     0x10            ; interrupt, call BIOS
        JMP     putloop

fin:
        HLT                     ; なにかあるまでCPUを停止させる
        JMP fin                 ; 無限ループ

msg:
        DB      0x0a, 0x0a
        DB      "load error"
        DB      0x0a
        DB      0               ; end point

        TIMES   0x1fe-($-$$) DB 0   
        ; 現在の場所から0x1fdまで(残りの未使用領域)を0で埋める
        ; 0x7c00スタートなのでその分を引いてる
; END BS_BootCode
        DB      0x55, 0xaa          ; BS_BootSign, boot signature
