proc leerCoordenadas
    
    ;leerCoordenadas es un proc general. Se usa tanto para
    ;ingresar las bases como para disparar.
    
    xor bh, bh     
    mov out_of_range, 0
    
    INGRESO_COORDENADA_X:
    
        mov dx, offset msg_pedir_coordenada_x
        call print
            
        call input_coordenadas ;res en bl
        
        cmp bl, 76
        ja et_out_of_range ; 1er filtro: no puede ser mayor a 76
        
        cmp case, 2
        jg INGRESO_COORDENADA_Y
                    
            ;switch ingreso bases. se ejecuta 2 veces
            
            cmp case, 0
            je INGRESAR_X_URSS
            
            cmp case, 2
            je INGRESAR_X_USA
            
            
            INGRESAR_X_URSS:
                           
                cmp bl, 33
                jl et_out_of_range ; filtro base urss. no puede ser menor a 33
                
                mov base_urss, bx
                
                inc case
                jmp INGRESO_COORDENADA_Y
        
             
            INGRESAR_X_USA:
            
                cmp bl, 33
                ja et_out_of_range ; filtro base usa. no puede ser mayor a 33
            
                mov base_usa, bx 
                inc case           
    
    
    INGRESO_COORDENADA_Y:
            
        mov coordenada_x, bl                        
        
        mov coordenada_unica, bx
        
    
        mov dx, offset msg_pedir_coordenada_y
        call print
            
        call input_coordenadas ;res en bl
        
        cmp bl, 18
        ja et_out_of_range ; 2do filtro: no puede ser mayor a 18
        
        cmp case, 3
        jg ok
        
            
            ;switch ingreso bases. se ejecuta 2 veces
            
            cmp case, 1
            je INGRESAR_Y_URSS
            
            cmp case, 3
            je INGRESAR_Y_USA
            
            jmp ok
            
            INGRESAR_Y_URSS:
                          
                call mul_input_76 ;bl * 76 = res en ax      
                add base_urss, ax
                 
                inc case
                jmp ok
                  
            INGRESAR_Y_USA:
            
                call mul_input_76 ;bl * 76 = res en ax
                add base_usa, ax
                
                
                inc case
                jmp ok
  
       
    et_out_of_range:
 
        inc out_of_range
        call clean_console
    
        MOV DH,19 ; Cursor en el renglon 00
        MOV DL,00 ; Cursor en la columna 19
        call mov_cursor
        
        call color_error
        mov dx, offset msg_out_of_range
        call print
    
        ciclo_enter:       
        
            call input_teclado ; carga el valor en al
            cmp al, 013   ; si es 13 --> enter  
            jne ciclo_enter
            
            call clean_console
    
            MOV DH,19 ; Cursor en el renglon 00
            MOV DL,00 ; Cursor en la columna 19
            call mov_cursor
                
    
    ok:   
    
        call mul_input_76 ;bl * 76 = res en ax
        add coordenada_unica, ax
           
    ret
endp

