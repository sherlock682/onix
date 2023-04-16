[org 0x1000]

dw 0x55aa;魔数，判断错误



;打印字符串
mov si,loading
call print

xchg bx,bx;魔数断点

detect_memory:
    ;将ebx置为0
    xor bx,bx

    ;es:di 结构体的缓存位置
    mov ax,0
    mov es,ax
    mov edi,ards_buffer

    mov edx,0x534d4150;固定签名

.next:
    ;子功能号
    mov eax,0xe820
    ;ards 结构体的大小（字节）
    mov ecx,20
    ;调用 0x15系统调用
    int 0x15

    ;如果cf置位，就表示出错
    jc error

    ;将缓存指针指向下一个结构体
    add di,cx

    ;将结构体的数量加一
    inc word[ards_count]

    cmp ebx,0
    jnz .next

    mov si,detecting
    call print
    
    jmp prepare_protected_mode
    
prepare_protected_mode:
    ; xchg bx,bx;断点

    cli;关闭中断

    ;打开A20线
    in al,0x92
    or al,0b10
    out 0x92,al

    lgdt [gdt_ptr];加载gdt

    ;启动保护模式
    mov eax,cr0
    or eax,1
    mov cr0,eax

    ;用跳转来刷新缓存，启用保护模式
    jmp dword code_selector:protect_mode

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
  
loading:
    db "Loading Onix...",10,13,0
detecting:
    db "Detecting Memory Success...",10,13,0


error:
    mov si, .msg
    call print
    hlt;让CPU停止
    jmp $
    .msg db "Loading Error!!!",10,13,0

[bits 32]
protect_mode:
    xchg bx,bx;断点
    mov ax,data_selector
    mov ds,ax
    mov es,ax
    mov fs,ax
    mov gs,ax
    mov ss,ax;初始换段寄存器

    mov esp,0x10000;修改栈顶

    mov edi,0x10000; 读取的目标内存
    mov ecx,10; 起始扇区
    mov bl,200; 扇区的数量

    call read_disk

    jmp dword code_selector:0x10000

    ud2;表示出错,Undefined Instruction 2,非法指令

jmp $;阻塞



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

code_selector equ (1 << 3)
data_selector equ (2 << 3)

memory_base equ 0;内存开始的位置，基地址

;内存界限 4G/4K-1
memory_limit equ ((1024*1024*1024*4)/(1024*4))-1

gdt_ptr:
    dw (gdt_end - gdt_base)-1
    dd gdt_base

gdt_base:
    dd 0,0;NULL 描述符

gdt_code:
    dw memory_limit & 0xffff;段界限的0~15位
    dw memory_base & 0xffff;基地址的0~15位
    db (memory_base>>16) & 0xff;基地址的16~23位
    ;存在 - dpl 0 - S _ 代码 - 非依从 - 可读 - 没有被访问过
    db 0b_1_00_1_1_0_1_0
    ;4K - 32位 - 不是64位 - 段界限16~19位
    db 0b1_1_0_0_0000 | (memory_limit>>16) & 0xf
    db (memory_base>>24) & 0xff;基地址24~31位

gdt_data:
    dw memory_limit & 0xffff;段界限的0~15位
    dw memory_base & 0xffff;基地址的0~15位
    db (memory_base>>16) & 0xff;基地址的16~23位
    ;存在 - dpl 0 - S _ 数据 - 向上 - 可写 - 没有被访问过
    db 0b_1_00_1_0_0_1_0
    ;4K - 32位 - 不是64位 - 段界限16~19位
    db 0b1_1_0_0_0000 | (memory_limit>>16) & 0xf
    db (memory_base>>24) & 0xff;基地址24~31位

gdt_end:

ards_count:
    dw 0
ards_buffer:
