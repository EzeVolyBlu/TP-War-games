proc informarResultado
    
    call clean_console
    
    MOV DH,19 ; Cursor en el renglon 00
    MOV DL,00 ; Cursor en la columna 19
    call mov_cursor
    
    cmp base_urss, -1
    je base_urss_hit
    
    cmp base_usa, -1
    je base_usa_hit
    
    jmp informar_w
    
    base_urss_hit:
    
        mov dx, offset msg_base_urss_hit    
        inc usa_win
        call print
         
        mov dx, offset msg_usa_win    
        call print
        
        jmp informar_w
        
    base_usa_hit:
    
        mov dx, offset msg_base_usa_hit    
        inc urss_win
        
        mov dx, offset msg_urss_win    
        call print
    
    informar_w:
    
        call convert_w_to_number
        mov dx, offset msg_urss_w ;imprime los 2 
        call print
        
    count_w:       
    
        cmp urss_w, 0
        jle urss_lost
        
        cmp usa_w, 0 
        jle usa_lost
        
        jmp end_informar_resultado
        
        urss_lost:
        
            inc usa_win
            jmp end_informar_resultado
            
            mov dx, offset msg_usa_win    
            call print
        
            
            
        usa_lost:
        
            inc urss_win
            
            mov dx, offset msg_urss_win    
            call print
        
            

    end_informar_resultado:
    
        mov dx, offset msg_presione_enter
        call print
        
    
    CICLO_inf_res:
        
        call input_teclado ; carga el valor en al
        
        cmp al, 013   ; si es 13 --> enter 
        jne CICLO_inf_res

     ret
endp     
