
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt
    
    
    
    
org 100h
         
         
    mov cx, 5
    xor bx, bx
             
CICLO:

    cmp cx, 26
    je SALIR
    
    
    mov al, texto[bx]
    
    
    cmp al, 'w'
    je count_w
    jmp INCREMENTAR
    
    
    count_w:
        inc cantidad_w
                
                
                
    INCREMENTAR:         
    inc bx
    inc cx
    jmp CICLO         
    
    SALIR:

    

ret


texto db 'kasdoaksdokjkjwsadijwjdasd$'
cantidad_w db 0


