
org 100h

    mov ah, 09
    mov dx,offset mapaArriba
    int 21h
    mov bx, 76   
    
    ciclo_filas_w:
        
        
        xor cx, cx
        ciclo_columnas_w:
        
            cmp mapaArriba[bx], 'W'
            jne it_col_w
            
            sum_w:
            
                cmp cx, 30
                jl sum_w_usa
                
                    sum_w_urss:
                    
                        inc w_urss
                        jmp it_col_w
                        
                    sum_w_usa:
                    
                        inc w_usa    
                    
            
            it_col_w:
            inc bx
            inc cx
            cmp cx, 76
            je it_row_w
            jmp ciclo_columnas_w
        
        it_row_w:
            
            cmp bx, 760
            jge end_ciclo_filas_w    
            jmp ciclo_filas_w
    
    end_ciclo_filas_w:   
    
    ret
    
mapaArriba db "00..........................WAR GAMES -1983...............................",10,13,"01.......-.....:**:::*=-..-++++:............:--::=WWW***+-++-.............",10,13,"02...:=WWWWWWW=WWW=:::+:..::...--....:=+W==WWWWWWWWWWWWWWWWWWWWWWWW+-.....",10,13,"03..-....:WWWWWWWW=-=WW*.........--..+::+=WWWWWWWWWWWWWWWWWWWW:..:=.......",10,13,"04.......+WWWWWW*+WWW=-:-.........-+*=:::::=W*W=WWWW*++++++:+++=-.........",10,13,"05......*WWWWWWWWW=..............::..-:--+++::-++:::++++++++:--..-........",10,13,"06.......:**WW=*=...............-++++:::::-:+::++++++:++++++++............",10,13,"08........-+:...-..............:+++++::+:++-++::-.-++++::+:::-............",10,13,"09..........--:-...............::++:+++++++:-+:.....::...-+:...-..........",10,13,"$"
w_urss db 0
w_usa db 0    

