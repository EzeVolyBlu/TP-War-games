proc initJuego 
    
    call printMap
    
    establecer_base_urss:
        
        mov dh, 19 ; Cursor en el renglon 19
        mov dl, 00 ; Cursor en la columna 00
        call mov_cursor
        
        call color_urss
        mov dx, offset URSS
        call print
        call establecerBase
        
        
        cmp out_of_range, 0
        jg  establecer_base_urss
        
    
    establecer_base_usa:
    
        call clean_console
    
        mov dh, 19 ; Cursor en el renglon 19
        mov dl, 00 ; Cursor en la columna 00
        call mov_cursor
                
        
        call color_usa
        mov dx, offset USA
        call print
        call establecerBase  
    
        cmp out_of_range, 0
        jg  establecer_base_usa
    
    call elegir_turno
    
    call informar_quien_empieza
    
    ret
endp    

