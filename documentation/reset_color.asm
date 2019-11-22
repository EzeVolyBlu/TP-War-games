proc reset_color

    mov ax, 0500h
    mov bh, 09h
    
    MOV CX,1300H ; Se posiciona el cursor en Ren=0 Col=0
    MOV DX,244FH ; Cursor al final de la pantalla Ren=24(18)
    
    
    int 10h
    ret
endp
