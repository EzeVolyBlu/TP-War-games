proc revisa_paridad
    
    xor ax, ax    
    mov al, turno
    mov bl, 2
    div bl 
    ret
endp
