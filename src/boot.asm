[org 0x7c00]

;设置屏幕模式为文本模式
mov ax,3
int 0x10

;初始化端寄存器
mov ax,0
mov ds,ax
mov es,ax
mov ss,ax
mov sp,0x7c00

mov si,booting
call print

xchg bx,bx; bochs 魔数断点 

mov edi,0x1000; 读取的目标内存
mov ecx,0; 起始扇区
mov bl,1; 扇区的数量

call read_disk

xchg bx,bx; bochs 魔数断点 

mov edi,0x1000; 读取的目标内存
mov ecx,2; 起始扇区
mov bl,1; 扇区的数量

call write_disk

xchg bx,bx; bochs 魔数断点 

;阻塞
jmp $

read_disk:

    ;设置读写扇区的数量
    mov dx,0x1F2
    mov al,bl
    out dx,al

    inc dx;0x1F3
    mov al,cl;起始扇区的低8位
    out dx,al

    inc dx;0x1F4
    shr ecx,8
    mov al,cl;起始扇区的中8位
    out dx,al

    inc dx;0x1F5
    shr ecx,8
    mov al,cl;起始扇区的高8位
    out dx,al

    inc dx;0x1F6
    shr ecx,8
    and cl,0b1111;将高四位置为0

    mov al,0b1110_0000
    or al,cl
    out dx,al;主盘 - LBA模式

    inc dx;0x1F7
    mov al,0x20;读硬盘
    out dx,al

    xor ecx,ecx;将ecx清空，性能更高
    mov cl,bl;得到读写扇区的数量

    .read:
        push cx;保存cx
        call .waits;等待数据准备完毕
        call .reads;读取一个扇区
        pop cx;恢复cx
        loop .read

    ret

    .waits:
        mov dx,0x1f7
        .check:
            in al,dx
            jmp $+2;延迟
            jmp $+2
            jmp $+2
            and al,0b1000_1000
            cmp al,0b0000_1000
            jnz .check
        ret

    .reads:
        mov dx,0x1f0
        mov cx,256;一个扇区256字
        .readw:
            in ax,dx
            jmp $+2;延迟
            jmp $+2
            jmp $+2
            mov [edi],ax
            add edi,2
            loop .readw
        ret

write_disk:

    ;设置读写扇区的数量
    mov dx,0x1F2
    mov al,bl
    out dx,al

    inc dx;0x1F3
    mov al,cl;起始扇区的低8位
    out dx,al

    inc dx;0x1F4
    shr ecx,8
    mov al,cl;起始扇区的中8位
    out dx,al

    inc dx;0x1F5
    shr ecx,8
    mov al,cl;起始扇区的高8位
    out dx,al

    inc dx;0x1F6
    shr ecx,8
    and cl,0b1111;将高四位置为0

    mov al,0b1110_0000
    or al,cl
    out dx,al;主盘 - LBA模式

    inc dx;0x1F7
    mov al,0x30;读硬盘
    out dx,al

    xor ecx,ecx;将ecx清空，性能更高
    mov cl,bl;得到读写扇区的数量

    .write:
        push cx;保存cx
        call .writes;写一个扇区
        call .waits;等待硬盘繁忙结束
        pop cx;恢复cx
        loop .write

    ret

    .waits:
        mov dx,0x1f7
        .check:
            in al,dx
            jmp $+2;延迟
            jmp $+2
            jmp $+2
            and al,0b1000_1000
            cmp al,0b0000_0000
            jnz .check
        ret

    .writes:
        mov dx,0x1f0
        mov cx,256;一个扇区256字
        .writew:
            mov ax,[edi]
            out dx,ax
            jmp $+2;延迟
            jmp $+2
            jmp $+2
            add edi,2
            loop .writew
        ret


print:
    mov ah,0x0e
.next:
    mov al,[si]
    cmp al,0
    jz .done
    int 0x10
    inc si
    jmp .next
.done:
    ret
    
booting:
    db "Booting Onix...",10,13,0

;填充为0
times 510 - ($ - $$) db 0

;主引导扇区最后两个字节是0x55aa
db 0x55,0xaa