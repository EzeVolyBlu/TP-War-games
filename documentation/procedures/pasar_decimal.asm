proc pasar_decimal
    
    mov ah,0
    sub al,48d
    mul aux
    mov bl, al
    
    ret
    
endp
