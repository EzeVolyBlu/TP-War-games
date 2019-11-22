proc input_coordenadas
    
    INGRESO_1:

        call input_teclado
        ;call solo_numeros 
        
        cmp al, '0'
        jb INGRESO_1
        
        cmp al, '9'
        ja INGRESO_1
        
        mov ah, 2  ; escribe un char en la salida standar
        mov dl, al
        int 21h 
    
        call pasar_decimal
    
      
      INGRESO_2:
      
        call input_teclado
        
        
        cmp AL, '0'
        jb INGRESO_2
        
        cmp AL, '9'
        ja INGRESO_2
        
        mov AH, 2  ; escribe un char en la salida standar
        mov DL, AL
        int 21h 
        
        call sumar_segundo_dec
        
        wait_enter:
            
            call input_teclado
            cmp al, 013   ; si es 13 --> enter  
            jne wait_enter
   ret
    
endp

