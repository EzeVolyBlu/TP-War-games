proc printMap

    mov dh, 00 ; Cursor en el renglon 00
    mov dl, 00 ; Cursor en la columna 00   
    call mov_cursor
    
    mov dx,offset mapaArriba
    call print
    ;mov dx, offset mapaAbajo
    ;call print
    
    ret
endp 
