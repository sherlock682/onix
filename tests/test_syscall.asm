[bits 32]

section .text
global main
main:
    mov eax,4
    mov ebx,1
    mov ecx,message
    mov edx,message.end - message
    int 0x80

    mov eax,1
    mov ebx,0
    int 0x80

section .data
message:
    db "hello world!!!",10,13,0
.end:
