
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

mov dx, offset dir1
mov ah, 39h
int 21h


mov ah, 3ch
mov cx, 0
mov dx, offset file1
int 21h
jc err
mov handle, ax

; write to file:
mov ah, 40h
mov bx, handle
mov dx, offset text1
mov cx, 70
int 21h       

; close c:\emu8086\vdrive\C\test1\file2.txt
mov ah, 3eh
mov bx, handle
int 21h
err:
nop




ret

dir1 db "c:\test1", 0
file1 db "c:\test1\file1.txt", 0
handle dw ?

text1 db "texto1.",10,13,"/n","\n"
text2 db "texto2.",10,13
text3 db "texto3.",10,13,"$"

text_size = $ - offset text




