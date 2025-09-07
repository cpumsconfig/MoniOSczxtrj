
org 0x7c00

call vga_graphics  ; 切换到图形模式
call vga_text      ; 切换回文本模式



mov ah,0x0E

mov si, 3
add si, 8

call print_register_number

mov si, message  ; 将字符串地址加载到si寄存器
call print       ; 调用print函数

jmp $            ; 无限循环，防止程序继续执行

; 定义要打印的字符串
message db '8848', 0  ; 0x0A是换行符的ASCII码

print:
    mov ah, 0x0E    ; 设置显示字符功能
.print_loop:
    mov al, [si]    ; 获取当前字符
    cmp al, 0       ; 检查是否到达字符串末尾
    je .done        ; 如果是，跳转到结束
    ; 检查是否为换行符
    cmp al, 0x0A    ; 检查是否为换行符
    je .new_line    ; 如果是，跳转到换行处理
    ; 检查是否为数字标记
    cmp al, '#'     ; 检查是否为数字标记
    je .print_number ; 如果是，跳转到数字处理
    ; 否则，打印字符
    int 0x10        ; 显示字符
    inc si          ; 移动到下一个字符
    jmp .print_loop ; 继续循环
.new_line:
    ; 先输出回车符
    mov al, 0x0D    ; 设置回车符
    int 0x10        ; 显示回车符
    ; 再输出换行符
    mov al, 0x0A    ; 设置换行符
    int 0x10        ; 显示换行符
    inc si          ; 移动到下一个字符
    jmp .print_loop ; 继续循环
.print_number:
    inc si          ; 跳过'#'标记
    ; 获取数字值
    xor ax, ax      ; 清空ax
    mov al, [si]    ; 获取第一个字节
    inc si
    mov ah, [si]    ; 获取第二个字节
    inc si
    call print_number16 ; 调用数字打印函数
    jmp .print_loop ; 继续循环
.done:
    ret             ; 返回

; 打印16位数字的函数
print_number16:
    pusha           ; 保存所有寄存器
    mov cx, 0       ; 初始化计数器
    mov bx, 10      ; 设置除数为10
    
.convert_loop:
    xor dx, dx      ; 清空dx
    div bx          ; ax = ax / 10, dx = ax % 10
    push dx         ; 将余数(数字)压入栈
    inc cx          ; 增加计数器
    cmp ax, 0       ; 检查商是否为0
    jne .convert_loop ; 如果不是，继续循环
    
.print_loop:
    pop dx          ; 从栈中弹出数字
    add dl, '0'     ; 将数字转换为ASCII字符
    mov ah, 0x0E    ; 设置显示字符功能
    int 0x10        ; 显示字符
    loop .print_loop ; 循环直到所有数字都打印完毕
    
    popa            ; 恢复所有寄存器
    ret             ; 返回

print_register_number:
    pusha          ; 保存所有寄存器
    mov ax, si     ; 假设数字在bx寄存器中
    call print_number16 ; 调用数字打印函数
    popa           ; 恢复所有寄存器
    ret            ; 返回


vga_graphics:
    mov ax, 0x0013  ; 设置视频模式13h (320x200, 256色)
    int 0x10        ; 调用BIOS中断
    ret

vga_text:
    mov ax, 0x0003  ; 设置视频模式03h (80x25文本模式)
    int 0x10        ; 调用BIOS中断
    ret

clear_screen:
    call vga_graphics  ; 切换到图形模式
    call vga_text      ; 切换回文本模式
    ret

times 510-($-$$) db 0
dw 0xaa55