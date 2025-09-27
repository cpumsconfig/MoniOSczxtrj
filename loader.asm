    org 0x100

    mov ax, 0xB800
    mov gs, ax ; 将gs设置为0xB800，即文本模式下的显存地址
    mov ah, 0xF ; 显示属性，此处指白色
    mov al, 'L' ; 待显示的字符
    mov [gs:((80 * 0 + 39) * 2)], ax ; 直接写入显存

    jmp $ ; 卡死在此处