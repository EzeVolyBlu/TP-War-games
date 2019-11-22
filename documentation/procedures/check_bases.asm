proc check_bases
    
    cmp base_urss, bx
    je destroy_urss_base
    
    
    cmp base_usa, bx
    je destroy_usa_base
    
    jmp end_check_bases
    
    destroy_urss_base:
    
        mov base_urss, -1
        jmp end_check_bases
        
    destroy_usa_base:       
        
        mov base_usa, -1
        
    end_check_bases:   
    
    ret
endp    
