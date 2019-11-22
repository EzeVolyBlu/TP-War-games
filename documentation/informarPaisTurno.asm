proc informarPaisTurno
    
    call clean_console
    
    MOV DH,19 ; Cursor en el renglon 00
    MOV DL,00 ; Cursor en la columna 19
    call mov_cursor
    
    call revisa_paridad
    cmp ah, 0
    je turno_urss
    
    turno_usa:
        
        call color_usa
        
        mov bx, offset msg_turno_usa
        ;mov msg_aux, bx
        
        
        jmp end_informar
        
    turno_urss:       
    
        call color_urss
        
        mov bx, offset msg_turno_urss
        ;mov msg_aux, bx
        
    
    end_informar: 
    
        mov dx, bx
        call print       
        ret
endp
