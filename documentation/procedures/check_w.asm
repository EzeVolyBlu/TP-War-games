proc check_w
    
    cmp mapaArriba[bx], 'W'
    jne end_count_w
    
    cmp coordenada_x, 30
    jl sub_usa_w
    
        sub_urss_w:
        
            dec urss_w 
            jmp end_count_w
            
        sub_usa_w:
        
            dec usa_w 
        
    end_count_w:

    ret
endp    
