
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h


;call create_file


open_file:

    mov al, 2 ;read/write
    mov dx, offset filename 
    mov ah, 3dh ;open file
    
    int 21h ; returns CF clear if succesful, ax = file handle
            ; CF set on error -> ax = error code
            
    jc err
    mov puntero_archivo, ax


read_file:        

    mov dx, offset buffer	    ; buffer para guardar los datos leidos
	mov cx, 70 			            ; por ej. cantidad de bytes a leer
	mov bx, puntero_archivo
	mov ah, 3Fh, 
	int 21h				   ; guarda en ax la cantidad de bytes leidos
	mov cant_bytes,ax
	

write_file:
    
    xor dx, dx
    mov  ah, 40h
    mov  bx, puntero_archivo
    mov  cx, 5  ;STRING LENGTH.
    mov  dx, offset text
    int  21h
    

	
close_file:

    
	mov bx, puntero_archivo;
	mov ah, 3Eh
	int 21h

	
	

jmp k



err:

    inc error

k:    

ret

filename db "ranking2.txt", 0
puntero_archivo dw ? 
error db 0
buffer db 71 dup('$')
cant_bytes dw 0
text db "Adam$"





proc create_file:
    
    mov cx, 0   ; normal - no attributes
    mov dx, offset filename 
    mov ah, 3ch ; create or truncate file
    
    int 21h ; returns CF clear if succesful, ax = file handle
            ; CF set on error -> ax = error code
             
    jc err
    mov puntero_archivo, ax
    
    ret
endp    