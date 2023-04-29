%line 1+1 handler.asm
[bits 32]


[extern handler_table]

[section .text]

%line 16+1 handler.asm

interrupt_entry:

 mov eax, [esp]


 call [handler_table + eax * 4]

 add esp,8
 iret

%line 9+1 handler.asm
interrupt_handler_0x00:

 push 0x20222202

 push 0x00
 jmp interrupt_entry
%line 9+1 handler.asm
interrupt_handler_0x01:

 push 0x20222202

 push 0x01
 jmp interrupt_entry
%line 9+1 handler.asm
interrupt_handler_0x02:

 push 0x20222202

 push 0x02
 jmp interrupt_entry
%line 9+1 handler.asm
interrupt_handler_0x03:

 push 0x20222202

 push 0x03
 jmp interrupt_entry
%line 31+1 handler.asm

%line 9+1 handler.asm
interrupt_handler_0x04:

 push 0x20222202

 push 0x04
 jmp interrupt_entry
%line 9+1 handler.asm
interrupt_handler_0x05:

 push 0x20222202

 push 0x05
 jmp interrupt_entry
%line 9+1 handler.asm
interrupt_handler_0x06:

 push 0x20222202

 push 0x06
 jmp interrupt_entry
%line 9+1 handler.asm
interrupt_handler_0x07:

 push 0x20222202

 push 0x07
 jmp interrupt_entry
%line 36+1 handler.asm

%line 9+1 handler.asm
interrupt_handler_0x08:
%line 13+1 handler.asm
 push 0x08
 jmp interrupt_entry
%line 9+1 handler.asm
interrupt_handler_0x09:

 push 0x20222202

 push 0x09
 jmp interrupt_entry
%line 9+1 handler.asm
interrupt_handler_0x0a:
%line 13+1 handler.asm
 push 0x0a
 jmp interrupt_entry
%line 9+1 handler.asm
interrupt_handler_0x0b:
%line 13+1 handler.asm
 push 0x0b
 jmp interrupt_entry
%line 41+1 handler.asm

%line 9+1 handler.asm
interrupt_handler_0x0c:
%line 13+1 handler.asm
 push 0x0c
 jmp interrupt_entry
%line 9+1 handler.asm
interrupt_handler_0x0d:
%line 13+1 handler.asm
 push 0x0d
 jmp interrupt_entry
%line 9+1 handler.asm
interrupt_handler_0x0e:
%line 13+1 handler.asm
 push 0x0e
 jmp interrupt_entry
%line 9+1 handler.asm
interrupt_handler_0x0f:

 push 0x20222202

 push 0x0f
 jmp interrupt_entry
%line 46+1 handler.asm

%line 9+1 handler.asm
interrupt_handler_0x10:

 push 0x20222202

 push 0x10
 jmp interrupt_entry
%line 9+1 handler.asm
interrupt_handler_0x11:
%line 13+1 handler.asm
 push 0x11
 jmp interrupt_entry
%line 9+1 handler.asm
interrupt_handler_0x12:

 push 0x20222202

 push 0x12
 jmp interrupt_entry
%line 9+1 handler.asm
interrupt_handler_0x13:

 push 0x20222202

 push 0x13
 jmp interrupt_entry
%line 51+1 handler.asm

%line 9+1 handler.asm
interrupt_handler_0x14:

 push 0x20222202

 push 0x14
 jmp interrupt_entry
%line 9+1 handler.asm
interrupt_handler_0x15:
%line 13+1 handler.asm
 push 0x15
 jmp interrupt_entry
%line 9+1 handler.asm
interrupt_handler_0x16:

 push 0x20222202

 push 0x16
 jmp interrupt_entry
%line 9+1 handler.asm
interrupt_handler_0x17:

 push 0x20222202

 push 0x17
 jmp interrupt_entry
%line 56+1 handler.asm

%line 9+1 handler.asm
interrupt_handler_0x18:

 push 0x20222202

 push 0x18
 jmp interrupt_entry
%line 9+1 handler.asm
interrupt_handler_0x19:

 push 0x20222202

 push 0x19
 jmp interrupt_entry
%line 9+1 handler.asm
interrupt_handler_0x1a:

 push 0x20222202

 push 0x1a
 jmp interrupt_entry
%line 9+1 handler.asm
interrupt_handler_0x1b:

 push 0x20222202

 push 0x1b
 jmp interrupt_entry
%line 61+1 handler.asm

%line 9+1 handler.asm
interrupt_handler_0x1c:

 push 0x20222202

 push 0x1c
 jmp interrupt_entry
%line 9+1 handler.asm
interrupt_handler_0x1d:

 push 0x20222202

 push 0x1d
 jmp interrupt_entry
%line 9+1 handler.asm
interrupt_handler_0x1e:

 push 0x20222202

 push 0x1e
 jmp interrupt_entry
%line 9+1 handler.asm
interrupt_handler_0x1f:

 push 0x20222202

 push 0x1f
 jmp interrupt_entry
%line 66+1 handler.asm

%line 9+1 handler.asm
interrupt_handler_0x20:

 push 0x20222202

 push 0x20
 jmp interrupt_entry
%line 9+1 handler.asm
interrupt_handler_0x21:

 push 0x20222202

 push 0x21
 jmp interrupt_entry
%line 9+1 handler.asm
interrupt_handler_0x22:

 push 0x20222202

 push 0x22
 jmp interrupt_entry
%line 9+1 handler.asm
interrupt_handler_0x23:

 push 0x20222202

 push 0x23
 jmp interrupt_entry
%line 9+1 handler.asm
interrupt_handler_0x24:

 push 0x20222202

 push 0x24
 jmp interrupt_entry
%line 9+1 handler.asm
interrupt_handler_0x25:

 push 0x20222202

 push 0x25
 jmp interrupt_entry
%line 9+1 handler.asm
interrupt_handler_0x26:

 push 0x20222202

 push 0x26
 jmp interrupt_entry
%line 9+1 handler.asm
interrupt_handler_0x27:

 push 0x20222202

 push 0x27
 jmp interrupt_entry
%line 9+1 handler.asm
interrupt_handler_0x28:

 push 0x20222202

 push 0x28
 jmp interrupt_entry
%line 9+1 handler.asm
interrupt_handler_0x29:

 push 0x20222202

 push 0x29
 jmp interrupt_entry
%line 9+1 handler.asm
interrupt_handler_0x2a:

 push 0x20222202

 push 0x2a
 jmp interrupt_entry
%line 9+1 handler.asm
interrupt_handler_0x2b:

 push 0x20222202

 push 0x2b
 jmp interrupt_entry
%line 9+1 handler.asm
interrupt_handler_0x2c:

 push 0x20222202

 push 0x2c
 jmp interrupt_entry
%line 9+1 handler.asm
interrupt_handler_0x2d:

 push 0x20222202

 push 0x2d
 jmp interrupt_entry
%line 9+1 handler.asm
interrupt_handler_0x2e:

 push 0x20222202

 push 0x2e
 jmp interrupt_entry
%line 9+1 handler.asm
interrupt_handler_0x2f:

 push 0x20222202

 push 0x2f
 jmp interrupt_entry
%line 83+1 handler.asm


[section .data]
[global handler_entry_table]
handler_entry_table:
 dd interrupt_handler_0x00
 dd interrupt_handler_0x01
 dd interrupt_handler_0x02
 dd interrupt_handler_0x03
 dd interrupt_handler_0x04
 dd interrupt_handler_0x05
 dd interrupt_handler_0x06
 dd interrupt_handler_0x07
 dd interrupt_handler_0x08
 dd interrupt_handler_0x09
 dd interrupt_handler_0x0a
 dd interrupt_handler_0x0b
 dd interrupt_handler_0x0c
 dd interrupt_handler_0x0d
 dd interrupt_handler_0x0e
 dd interrupt_handler_0x0f
 dd interrupt_handler_0x10
 dd interrupt_handler_0x11
 dd interrupt_handler_0x12
 dd interrupt_handler_0x13
 dd interrupt_handler_0x14
 dd interrupt_handler_0x15
 dd interrupt_handler_0x16
 dd interrupt_handler_0x17
 dd interrupt_handler_0x18
 dd interrupt_handler_0x19
 dd interrupt_handler_0x1a
 dd interrupt_handler_0x1b
 dd interrupt_handler_0x1c
 dd interrupt_handler_0x1d
 dd interrupt_handler_0x1e
 dd interrupt_handler_0x1f
 dd interrupt_handler_0x20
 dd interrupt_handler_0x21
 dd interrupt_handler_0x22
 dd interrupt_handler_0x23
 dd interrupt_handler_0x24
 dd interrupt_handler_0x25
 dd interrupt_handler_0x26
 dd interrupt_handler_0x27
 dd interrupt_handler_0x28
 dd interrupt_handler_0x29
 dd interrupt_handler_0x2a
 dd interrupt_handler_0x2b
 dd interrupt_handler_0x2c
 dd interrupt_handler_0x2d
 dd interrupt_handler_0x2e
 dd interrupt_handler_0x2f
