proc jugar
                 
                 
    INICIO:             
                 
        call printMap
        
        again:
        
            call informarPaisTurno
            call leerCoordenadas
        
        cmp out_of_range, 0
        jg again
        
        call disparar
        call informarResultado
        ;call actualizarSiguienteTurno
        
        cmp usa_win, 0
        jg end_game
        
        cmp urss_win, 0
        jg end_game
        
        inc turno
        jmp INICIO
        
        
        
        
        end_game:
        
            
    ret
endp