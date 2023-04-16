[bits 32]

extern exit

global main
main:
    pusha
    popa
    
    push 5
    push eax

    pop ebx
    pop ecx
    call exit