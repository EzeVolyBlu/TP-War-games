proc guardarRanking
    
    calcular_intentos:
    
        mov dh, turno
        sub dh, nro_inicio
        inc dh 
        
        xor ah, ah
        mov al, dh
        mov bl, 10
        div bl
        
        mov msg_intentos[16],al  
        mov msg_intentos[17],ah
        
        add msg_intentos[16],48  
        add msg_intentos[17],48
                                
    
    open_file:

        mov al, 2 ;read/write
        mov dx, offset filename 
        mov ah, 3dh ;open file
        
        int 21h ; returns CF clear if succesful, ax = file handle
                ; CF set on error -> ax = error code
                
        ;jc err
        mov puntero_archivo, ax
    
    
    read_file:        
    
        mov dx, offset buffer	    ; buffer para guardar los datos leidos
    	mov cx, 699 			            ; por ej. cantidad de bytes a leer
    	mov bx, puntero_archivo
    	mov ah, 3Fh, 
    	int 21h				   ; guarda en ax la cantidad de bytes leidos
    	;mov cant_bytes,ax
    	
    write_file:
        
        mov  ah, 40h
        mov  bx, puntero_archivo
        mov  cx, 15  ;STRING LENGTH.
        mov  dx, offset msg_results
        int  21h
        
        cmp usa_win, 0
        jg msg_ranking_usa_win
    
    
    msg_ranking_urss_win:
    
        mov  ah, 40h
        mov  cx, 5  ;STRING LENGTH.
        mov  dx, offset urss
        int  21h
        
        jmp duracion_partida
    
    msg_ranking_usa_win:
    
        mov  ah, 40h
        mov  cx, 4  ;STRING LENGTH.
        mov  dx, offset usa
        int  21h
        
    
    duracion_partida:

        mov  ah, 40h
        mov  cx, 28  ;STRING LENGTH.
        mov  dx, offset msg_intentos
        int  21h
            
    w_destruidas:
        
        mov  ah, 40h
        mov  cx, 40  ;STRING LENGTH.
        mov  dx, offset msg_urss_w         
        int  21h
    
    ret
endp    
