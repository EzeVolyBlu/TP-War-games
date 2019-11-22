proc input_teclado
    
    mov AH, 7 ;leer teclado
    int 21h
    
 ret 
endp
