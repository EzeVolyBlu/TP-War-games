proc press_enter

        mov dx, offset msg_presione_enter
        call print    
    
    ciclo_enter:
    
        call input_teclado
        cmp al, 013   ; si es 13 --> enter  
        jne ciclo_enter
    
    ret
endp
