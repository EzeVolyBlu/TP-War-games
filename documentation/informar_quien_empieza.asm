proc informar_quien_empieza
    
    call clean_console
    
    MOV DH,19 ; Cursor en el renglon 00
    MOV DL,00 ; Cursor en la columna 19
    call mov_cursor
    
    
    call revisa_paridad ; param turno; resto = ah
    cmp ah, 0
    
    je PAR; resto = 0 -> par 
    
        IMPAR: ;Estados Unidos     
            
            call color_usa
            mov dx, offset msg_start_usa
            jmp END 
        
        
        
        PAR: ;Union Sovietica
        
            call color_urss
            mov dx, offset msg_start_urss
            
        
    
        END:                  
             
            call print   
            
        
        mov dx, offset msg_presione_enter
        call print    
            
        press_enter:
            
            call input_teclado
            cmp al, 013   ; si es 13 --> enter  
            jne press_enter           
            
    ret
endp    

