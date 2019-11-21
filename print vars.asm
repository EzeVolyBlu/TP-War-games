
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

xor ah, ah
mov al, 45

mov bl, 10

div bl

mov char_1, al
mov char_2, ah

add char_1, 48
add char_2, 48


mov dx, offset char_1
mov ah, 9
int 21h



; add your code here

ret

char_1 db ?
char_2 db ?, '$'


