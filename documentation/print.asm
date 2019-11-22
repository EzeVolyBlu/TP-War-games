proc mov_cursor
    
    MOV AH,02H ; Peticion para colocar el cursor
    MOV BH,00 ; Nunmero de pagina a imprimir
    INT 10H ; Interrupcion al bios
    
    ret
endp
proc print

    mov AH, 9
    int 21h
    
    ret
endp
