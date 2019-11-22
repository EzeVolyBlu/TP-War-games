org 100h

programaPrincipal:


    call initJuego
    call jugar
    call guardarRanking
    
ret

proc guardarRanking
    
    calcular_intentos:
    
        mov dh, turno
        sub dh, nro_inicio
        inc dh 
        
        xor ah, ah
        mov al, dh
        mov bl, 10
        div bl
        
        mov msg_intentos[16],al  
        mov msg_intentos[17],ah
        
        add msg_intentos[16],48  
        add msg_intentos[17],48
                                
    
    open_file:
        
        xor ax,ax
        xor dx, dx
        
        mov al, 2 ;read/write
        mov dx, offset filename2 
        mov ah, 3dh ;open file
        
        int 21h ; returns CF clear if succesful, ax = file handle
                ; CF set on error -> ax = error code
                
        ;jc err
        mov puntero_archivo, ax
    
    
    read_file:        
    
        mov dx, offset buffer	    ; buffer para guardar los datos leidos
    	mov cx, 699 			            ; por ej. cantidad de bytes a leer
    	mov bx, puntero_archivo
    	mov ah, 3Fh, 
    	int 21h				   ; guarda en ax la cantidad de bytes leidos
    	;mov cant_bytes,ax
    	
    write_file:
        
        mov  ah, 40h
        mov  bx, puntero_archivo
        mov  cx, 15  ;STRING LENGTH.
        mov  dx, offset msg_results
        int  21h
        
        cmp usa_win, 0
        jg msg_ranking_usa_win
    
    
    msg_ranking_urss_win:
    
        mov  ah, 40h
        mov  cx, 6  ;STRING LENGTH.
        mov  dx, offset urss
        int  21h
        
        jmp duracion_partida
    
    msg_ranking_usa_win:
    
        mov  ah, 40h
        mov  cx, 5  ;STRING LENGTH.
        mov  dx, offset usa
        int  21h
        
    
    duracion_partida:

        mov  ah, 40h
        mov  cx, 27  ;STRING LENGTH.
        mov  dx, offset msg_intentos
        int  21h
            
    w_destruidas:
        
        mov  ah, 40h
        mov  cx, 49  ;STRING LENGTH.
        mov  dx, offset msg_urss_w         
        int  21h
        
        
    close_file:
    
        mov ah, 3eh
        mov puntero_archivo, bx
        int 21h       
    
    ret
endp    

proc write_line
    
    
    ret
endp    




;------------------------
;       initJuego
;------------------------

proc initJuego 
    
    call printMap
    
    establecer_base_urss:
        
        mov dh, 19 ; Cursor en el renglon 19
        mov dl, 00 ; Cursor en la columna 00
        call mov_cursor
        
        call color_urss
        mov dx, offset URSS
        call print
        call establecerBase
        
        
        cmp out_of_range, 0
        jg  establecer_base_urss
        
    
    establecer_base_usa:
    
        call clean_console
    
        mov dh, 19 ; Cursor en el renglon 19
        mov dl, 00 ; Cursor en la columna 00
        call mov_cursor
                
        
        call color_usa
        mov dx, offset USA
        call print
        call establecerBase  
    
        cmp out_of_range, 0
        jg  establecer_base_usa
    
    call elegir_turno
    
    call informar_quien_empieza
    
    ret
endp    

proc establecerBase
    
    mov dx, offset msg_pedir_coordenadas_base 
    call print
    call leerCoordenadas
    
    ret
endp

proc leerCoordenadas
    
    ;leerCoordenadas es un proc general. Se usa tanto para
    ;ingresar las bases como para disparar.
    
    xor bh, bh     
    mov out_of_range, 0
    
    INGRESO_COORDENADA_X:
    
        mov dx, offset msg_pedir_coordenada_x
        call print
            
        call input_coordenadas ;res en bl
        
        cmp bl, 76
        ja et_out_of_range ; 1er filtro: no puede ser mayor a 76
        
        cmp case, 2
        jg INGRESO_COORDENADA_Y
                    
            ;switch ingreso bases. se ejecuta 2 veces
            
            cmp case, 0
            je INGRESAR_X_URSS
            
            cmp case, 2
            je INGRESAR_X_USA
            
            
            INGRESAR_X_URSS:
                           
                cmp bl, 33
                jl et_out_of_range ; filtro base urss. no puede ser menor a 33
                
                mov base_urss, bx
                
                inc case
                jmp INGRESO_COORDENADA_Y
        
             
            INGRESAR_X_USA:
            
                cmp bl, 33
                ja et_out_of_range ; filtro base usa. no puede ser mayor a 33
            
                mov base_usa, bx 
                inc case           
    
    
    INGRESO_COORDENADA_Y:
            
        mov coordenada_x, bl                        
        
        mov coordenada_unica, bx
        
    
        mov dx, offset msg_pedir_coordenada_y
        call print
            
        call input_coordenadas ;res en bl
        
        cmp bl, 18
        ja et_out_of_range ; 2do filtro: no puede ser mayor a 18
        
        cmp case, 3
        jg ok
        
            
            ;switch ingreso bases. se ejecuta 2 veces
            
            cmp case, 1
            je INGRESAR_Y_URSS
            
            cmp case, 3
            je INGRESAR_Y_USA
            
            jmp ok
            
            INGRESAR_Y_URSS:
                          
                call mul_input_76 ;bl * 76 = res en ax      
                add base_urss, ax
                 
                inc case
                jmp ok
                  
            INGRESAR_Y_USA:
            
                call mul_input_76 ;bl * 76 = res en ax
                add base_usa, ax
                
                
                inc case
                jmp ok
  
       
    et_out_of_range:
 
        inc out_of_range
        call clean_console
    
        MOV DH,19 ; Cursor en el renglon 00
        MOV DL,00 ; Cursor en la columna 19
        call mov_cursor
        
        call color_error
        mov dx, offset msg_out_of_range
        call print
    
        ciclo_enter:       
        
            call input_teclado ; carga el valor en al
            cmp al, 013   ; si es 13 --> enter  
            jne ciclo_enter
            
            call clean_console
    
            MOV DH,19 ; Cursor en el renglon 00
            MOV DL,00 ; Cursor en la columna 19
            call mov_cursor
                
    
    ok:   
    
        call mul_input_76 ;bl * 76 = res en ax
        add coordenada_unica, ax
           
    ret
endp

proc input_coordenadas
    
    INGRESO_1:

        call input_teclado
        ;call solo_numeros 
        
        cmp al, '0'
        jb INGRESO_1
        
        cmp al, '9'
        ja INGRESO_1
        
        mov ah, 2  ; escribe un char en la salida standar
        mov dl, al
        int 21h 
    
        call pasar_decimal
    
      
      INGRESO_2:
      
        call input_teclado
        
        
        cmp AL, '0'
        jb INGRESO_2
        
        cmp AL, '9'
        ja INGRESO_2
        
        mov AH, 2  ; escribe un char en la salida standar
        mov DL, AL
        int 21h 
        
        call sumar_segundo_dec
        
        wait_enter:
            
            call input_teclado
            cmp al, 013   ; si es 13 --> enter  
            jne wait_enter
   ret
    
endp

proc elegir_turno
    
    mov ah,2Ch 
    int 21h 
    ;Return: CH = hour CL = minute DH = second DL = 1/100 seconds
    
    mov turno, dh
    mov nro_inicio, dh 
    ret
endp      

proc informar_quien_empieza
    
    call clean_console
    
    MOV DH,19 ; Cursor en el renglon 00
    MOV DL,00 ; Cursor en la columna 19
    call mov_cursor
    
    
    call revisa_paridad ; param turno; resto = ah
    cmp ah, 0
    
    je PAR; resto = 0 -> par 
    
        IMPAR: ;Estados Unidos     
            
            call color_usa
            mov dx, offset msg_start_usa
            jmp END 
        
        
        
        PAR: ;Union Sovietica
        
            call color_urss
            mov dx, offset msg_start_urss
            
        
    
        END:                  
             
            call print   
            
        
        mov dx, offset msg_presione_enter
        call print    
            
        press_enter:
            
            call input_teclado
            cmp al, 013   ; si es 13 --> enter  
            jne press_enter           
            
    ret
endp    

;-----------------------------------------
;               jugar
;-----------------------------------------
    

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

proc informarResultado
    
    call clean_console
    
    MOV DH,19 ; Cursor en el renglon 00
    MOV DL,00 ; Cursor en la columna 19
    call mov_cursor
    
    cmp base_urss, -1
    je base_urss_hit
    
    cmp base_usa, -1
    je base_usa_hit
    
    jmp informar_w
    
    base_urss_hit:
    
        mov dx, offset msg_base_urss_hit    
        inc usa_win
        call print
         
        mov dx, offset msg_usa_win    
        call print
        
        jmp informar_w
        
    base_usa_hit:
    
        mov dx, offset msg_base_usa_hit    
        inc urss_win
        
        mov dx, offset msg_urss_win    
        call print
    
    informar_w:
    
        call convert_w_to_number
        mov dx, offset msg_urss_w ;imprime los 2 
        call print
        
    count_w:       
    
        cmp urss_w, 0
        jle urss_lost
        
        cmp usa_w, 0 
        jle usa_lost
        
        jmp end_informar_resultado
        
        urss_lost:
        
            inc usa_win
            jmp end_informar_resultado
            
            mov dx, offset msg_usa_win    
            call print
        
            
            
        usa_lost:
        
            inc urss_win
            
            mov dx, offset msg_urss_win    
            call print
        
            

    end_informar_resultado:
    
        mov dx, offset msg_presione_enter
        call print
        
    
    CICLO_inf_res:
        
        call input_teclado ; carga el valor en al
        
        cmp al, 013   ; si es 13 --> enter 
        jne CICLO_inf_res

     ret
endp     


proc disparar
    
    xor bx, bx
    mov bx, coordenada_unica 
    xor dh, dh   ; filas
    
    sub bx, 77 
    
    
    ciclo_filas:
    
        xor dl, dl   ; columnas    
        ciclo_columnas:
        
            call check_bases
            call check_w
            call remove_w
            
            
            cmp dl, 2
            je end_ciclo_columnas
            
            inc bx
            inc dl
            jmp ciclo_columnas
            
        end_ciclo_columnas:    
                                     
        
        cmp dh, 2
        je end_ciclo_filas
        
        add bx, 74       
        inc dh;
        jmp ciclo_filas
    
    end_ciclo_filas:
    
    call printMap   

    ret
endp
         
proc remove_w
    
    mov mapaArriba[bx], " "
    
    ret
endp             
         
         
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

 
proc informarPaisTurno
    
    call clean_console
    
    MOV DH,19 ; Cursor en el renglon 00
    MOV DL,00 ; Cursor en la columna 19
    call mov_cursor
    
    call revisa_paridad
    cmp ah, 0
    je turno_urss
    
    turno_usa:
        
        call color_usa
        
        mov bx, offset msg_turno_usa
        ;mov msg_aux, bx
        
        
        jmp end_informar
        
    turno_urss:       
    
        call color_urss
        
        mov bx, offset msg_turno_urss
        ;mov msg_aux, bx
        
    
    end_informar: 
    
        mov dx, bx
        call print       
        ret
endp

proc revisa_paridad
    
    xor ax, ax    
    mov al, turno
    mov bl, 2
    div bl 
    ret
endp

   

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

proc color_usa 
    
    mov ax, 0600h
    mov bh, 09h
    
    MOV CX,1300H ; Se posiciona el cursor en Ren=0 Col=0
    MOV DX,244FH ; Cursor al final de la pantalla Ren=24(18)
    
    
    int 10h
    ret
endp

proc reset_color

    mov ax, 0500h
    mov bh, 09h
    
    MOV CX,1300H ; Se posiciona el cursor en Ren=0 Col=0
    MOV DX,244FH ; Cursor al final de la pantalla Ren=24(18)
    
    
    int 10h
    ret
endp
     
proc color_urss
    mov ax, 0600h ;config editar pantalla
    mov bh, 0Ch ; color
    
    MOV CX,1300H ; Se posiciona el cursor en Ren=0 Col=0
    MOV DX,244FH ; Cursor al final de la pantalla Ren=24(18)
    
    int 10h
    ret
endp         

proc color_error
    mov ax, 0600h ;config editar pantalla
    mov bh, 0Eh ; color
    
    MOV CX,1300H ; Se posiciona el cursor en Ren=0 Col=0
    MOV DX,244FH ; Cursor al final de la pantalla Ren=24(18)
    
    
    int 10h
    ret
endp         




proc mov_cursor
    
    MOV AH,02H ; Peticion para colocar el cursor
    MOV BH,00 ; Nunmero de pagina a imprimir
    INT 10H ; Interrupcion al bios
    
    ret
endp
    
proc clean_console
    
    mov ax, 0600h ;config editar pantalla
    mov bh, 07h ; color
    
    MOV CX,1300H ; Se posiciona el cursor en Ren=0 Col=0
    MOV DX,244FH ; Cursor al final de la pantalla Ren=24(18)
    
    
    int 10h
    ret
endp        
        
 
        
     

proc print

    mov AH, 9
    int 21h
    
    ret
endp


proc mul_input_76
    
    xor ah, ah
    mov al, 76
    mul bl
    
    ret
endp    

proc solo_numeros
    
    cmp AL, '0'
    jb SALIR
    
    cmp AL, '9'
    ja SALIR
    
    mov AH, 2  ; escribe un char en la salida standar
    mov DL, AL
    int 21h 
    
SALIR: 
    ret
endp  

     
proc input_teclado
    
    mov AH, 7 ;leer teclado
    int 21h
    
 ret 
endp


proc pasar_decimal
    
    mov ah,0
    sub al,48d
    mul aux
    mov bl, al
    
    ret
    
endp

proc sumar_segundo_dec
    
    sub al,48d
    add bl,al
    
    ret
    
endp

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



msg_urss_w db 'URSS tiene ',?,?,' espacios',13,10
msg_usa_w db 'USA tiene ',?,?,' espacios',13,10,13,10,'$'
msg_intentos db 'La partida duro ',?,?,' turnos',13,10,'$'

         
URSS db 'URSS',13,10,'$'
USA db 'USA',13,10,'$'
msg_pedir_coordenadas_base db 'Ingrese la ubicacion de su base secreta$'
msg_pedir_coordenada_x db '',10,13,'Ingrese coordenada x: $'
msg_pedir_coordenada_y db '',10,13,'Ingrese coordenada y: $'
msg_start_urss db 'Empieza disparando URSS$'
msg_start_usa db 'Empieza disparando USA$'
msg_turno_urss db 'turno de URSS$'
msg_turno_usa db 'turno de USA$'
msg_out_of_range db 'Fuera de rango'
msg_presione_enter db 10,13,10,13,'Presione enter para continuar$'
msg_usa_win db 'Gano USA',10,13,'$'
msg_urss_win db 'Gano URSS',10,13,'$'

msg_base_urss_hit db 'La base de URSS fue acertada',10,13,'$'
msg_base_usa_hit db 'La base de USA fue acertada$',10,13,'$'

mapaArriba db "00..........................WAR GAMES -1983...............................",10,13,"01.......-.....:**:::*=-..-++++:............:--::=WWW***+-++-.............",10,13,"02...:=WWWWWWW=WWW=:::+:..::...--....:=+W==WWWWWWWWWWWWWWWWWWWWWWWW+-.....",10,13,"03..-....:WWWWWWWW=-=WW*.........--..+::+=WWWWWWWWWWWWWWWWWWWW:..:=.......",10,13,"04.......+WWWWWW*+WWW=-:-.........-+*=:::::=W*W=WWWW*++++++:+++=-.........",10,13,"05......*WWWWWWWWW=..............::..-:--+++::-++:::++++++++:--..-........",10,13,"06.......:**WW=*=...............-++++:::::-:+::++++++:++++++++............",10,13,"08........-+:...-..............:+++++::+:++-++::-.-++++::+:::-............",10,13,"09..........--:-...............::++:+++++++:-+:.....::...-+:...-..........",10,13,
mapaAbajo db "10..............-+++:-..........:+::+::++++++:-......-....-...---.........",10,13,"11..............:::++++:-............::+++:+:.............:--+--.-........",10,13,"12..............-+++++++++:...........+:+::+................--.....---....",10,13,"13................:++++++:...........-+::+::.:-................-++:-:.....",10,13,"14.................++::+-.............::++:..:...............++++++++-....",10,13,"15.................:++:-...............::-..................-+:--:++:.....",10,13,"16.................:+-............................................-.....--",10,13,"17.................:....................................................--",10,13,"18.......UNITED STATES.........................SOVIET UNION...............$"

nro_inicio db 0

turno db ?
aux db 10
coordenada db ?
case db 0
base_urss dw ?
base_usa dw ?
coordenada_unica dw 0
urss_w db 40
usa_w db 40    
coordenada_x db 0
out_of_range db 0
filename db 'ranking.txt'
filename2 db 'ranking.txt'
urss_win db 0
usa_win db 0

puntero_archivo dw ?

buffer db 700 dup('$')
msg_results db "El ganador fue $";17
