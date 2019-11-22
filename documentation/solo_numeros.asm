proc solo_numeros
    
    cmp AL, '0'
    jb SALIR
    
    cmp AL, '9'
    ja SALIR
    
    mov AH, 2  ; escribe un char en la salida standar
    mov DL, AL
    int 21h 
    
SALIR: 
    ret
endp  
