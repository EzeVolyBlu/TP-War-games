proc establecerBase
    
    mov dx, offset msg_pedir_coordenadas_base 
    call print
    call leerCoordenadas
    
    ret
endp
