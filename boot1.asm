org 0x7c00

start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    ; 把栈放到安全区域，避免覆盖 0x7C00 附近的代码/数据
    mov ax, 0x9000
    mov ss, ax
    mov sp, 0xFFFF
    sti

    call clear_screen
    call set_cursor_home

    mov si, message
    call print

hang:
    jmp hang

; -------------------------
; 清屏并把光标移到(0,0)
; -------------------------
clear_screen:
    mov ah, 0x06    ; 向上滚屏/清屏功能
    mov al, 0x00    ; AL=0 清空整个窗口
    mov bh, 0x07    ; 页面属性（白底灰字，常用默认）
    mov cx, 0x0000  ; 左上 (row=0,col=0)
    mov dx, 0x184F  ; 右下 (row=24,col=79) -> 0x18=行,0x4F=列
    int 0x10
    ret

set_cursor_home:
    mov ah, 0x02
    mov bh, 0x00
    mov dh, 0x00  ; row = 0
    mov dl, 0x00  ; col = 0
    int 0x10
    ret

; -------------------------
; 简单的打印例程
; 使用: mov si, message; call print
; 支持换行 '\n' (0x0A) 和标记数字 '#'<lo><hi>（两个字节）打印16位数
; -------------------------
print:
.print_loop:
    mov al, [si]
    cmp al, 0
    je .done
    cmp al, 0x0A          ; 换行 '\n'
    je .new_line
    cmp al, '#'
    je .print_number
    ; 普通字符
    mov ah, 0x0E
    int 0x10
    inc si
    jmp .print_loop

.new_line:
    ; 输出回车 + 换行，使用 teletype 功能
    mov al, 0x0D
    mov ah, 0x0E
    int 0x10
    mov al, 0x0A
    mov ah, 0x0E
    int 0x10
    inc si
    jmp .print_loop

.print_number:
    inc si               ; 跳过 '#'
    xor ax, ax
    mov al, [si]         ; 低字节
    inc si
    mov ah, [si]         ; 高字节
    inc si
    call print_number16
    jmp .print_loop

.done:
    ret

; -------------------------
; 打印 AX 中的无符号16位十进制数
; 入口: AX = 数值
; 使用 BIOS teletype (AH=0x0E, AL=char)
; -------------------------
print_number16:
    pusha
    mov cx, 0
    mov bx, 10

.convert_loop:
    xor dx, dx
    div bx            ; AX / 10 -> AX=quotient, DX=remainder
    push dx
    inc cx
    cmp ax, 0
    jne .convert_loop

.print_digits:
    pop dx
    add dl, '0'
    mov al, dl
    mov ah, 0x0E
    int 0x10
    loop .print_digits

    popa
    ret

; -------------------------
; 数据
; -------------------------
message db 'Hello, World!', 0  ; 示例：# 后为低、高字节（这里随意）
; 注意：上面仅为示例，实际使用时按需设置数字字节或直接用普通字符串。

times 510-($-$$) db 0
dw 0xAA55