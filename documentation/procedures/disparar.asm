proc disparar
    
    xor bx, bx
    mov bx, coordenada_unica 
    xor dh, dh   ; filas
    
    sub bx, 77 
    
    
    ciclo_filas:
    
        xor dl, dl   ; columnas    
        ciclo_columnas:
        
            call check_bases
            call check_w
            call remove_w
            
            
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
    
    call printMap   

    ret
endp
         
