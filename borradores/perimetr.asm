
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

proc per

    mov bx, 100  ; 100 > var
    xor dh, dh   ; filas
    
    sub bx, 77 
    
    
    ciclo_filas:
    
        xor dl, dl   ; columnas    
        ciclo_columnas:
        
            ;proc
            
            
            cmp dl, 2
            je end_ciclo_columnas
            
            inc bx
            inc dl
            jmp ciclo_columnas
            
        end_ciclo_columnas:    
                                     
        
        cmp dh, 2
        je end_ciclo_filas
        
        add bx, 74       
        inc dh;
        jmp ciclo_filas
    
    end_ciclo_filas:   
    
ret




