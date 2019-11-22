proc convert_w_to_number
    
    convert_w_to_number_urss: 
    
        xor ah, ah
        mov al, urss_w
        mov bl, 10
        div bl
        
        mov msg_urss_w[11], al
        mov msg_urss_w[12], ah
        
        add msg_urss_w[11], 48
        add msg_urss_w[12], 48
    
    convert_w_to_number_usa: 
    
        xor ah, ah
        mov al, usa_w
        mov bl, 10
        div bl
        
        mov msg_usa_w[10], al
        mov msg_usa_w[11], ah
        
        add msg_usa_w[10], 48
        add msg_usa_w[11], 48
    
    ret
endp
