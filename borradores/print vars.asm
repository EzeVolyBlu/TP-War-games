
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

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
        
    mov dx, offset msg_urss_w 
    mov ah, 9
    int 21h

    ret
endp

msg_urss_w db 'URSS tiene ',?,?,' espacios',10,13
msg_usa_w db 'USA tiene ',?,?,' espacios$'

urss_w db 40
usa_w db 50   

