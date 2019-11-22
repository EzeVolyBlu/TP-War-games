proc color_error
    mov ax, 0600h ;config editar pantalla
    mov bh, 0Eh ; color
    
    MOV CX,1300H ; Se posiciona el cursor en Ren=0 Col=0
    MOV DX,244FH ; Cursor al final de la pantalla Ren=24(18)
    
    
    int 10h
    ret
endp         
