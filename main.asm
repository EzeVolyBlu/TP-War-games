org 100h

programaPrincipal:


    call initJuego
    call jugar
    ;call guardarRanking
    
  
    
ret

;       PROC
;------------------------

proc initJuego 
    
    call printMap
    call pedir_coordenadas_bases
    call elegir_turno
    call informar_quien_empieza
    
    ret
endp    




proc jugar
                 
                 
    INICIO:             
                 
        call printMap
        call informarPaisTurno
        call leerCoordenadas
        call disparar
        call informarResultado
        ;call actualizarSiguienteTurno
        inc turno
        
        
        jmp INICIO
    
    ret
endp

proc informarResultado
    
    ;call clean_console
    
    MOV DH,25 ; Cursor en el renglon 00
    MOV DL,00 ; Cursor en la columna 19
    call mov_cursor
    
    ;mov dx, offset urss_w
    mov dx, offset msg_informar_resultado
    
    call print    
    
    
    
    

     ret
endp     


proc disparar
    
    xor bx, bx
    mov bx, aux_disparo 
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


proc leerCoordenadas 
    
    start_leer_coor:
    
    mov out_of_range, 0
    
    mov dx, offset msg_pedir_coordenada_x
    call print
        
    ;este es 
    call input_coordenada
    
    
    mov coordenada_x, bl                        
    call coordenada_unica
    
    cmp out_of_range, 1
    
    je start_leer_coor:
    
    
    
    
                  
    mov dx, offset msg_pedir_coordenada_y
    call print    
    call input_coordenada
    
    mov bl, coordenada
    call mul_input_76
    add aux_disparo, ax
       
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

proc elegir_turno
    
    mov ah,2Ch 
    int 21h 
    ;Return: CH = hour CL = minute DH = second DL = 1/100 seconds
    
    mov turno, dh
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
    
        IMPAR:      
        
            mov dx, offset msg_start_usa
            jmp END 
        
        ;Union Sovietica
        
        PAR:
            mov dx, offset msg_start_urss
            
        ;Estados Unidos
    
        END:                  
             
            call print   
    
    ret
endp    
   

proc pedir_coordenadas_bases
    
    establecer_base_urss:
        
        MOV DH,19 ; Cursor en el renglon 00
        MOV DL,00 ; Cursor en la columna 19
        call mov_cursor
        
        
        mov dx, offset URSS
        call print
        call establecerBase
        
    
    establecer_base_usa:
    
        call clean_console
    
        MOV DH,19 ; Cursor en el renglon 00
        MOV DL,00 ; Cursor en la columna 19
        call mov_cursor
                
        
        
        mov dx, offset USA
        call print
        call establecerBase
        
   ret
endp

proc establecerBase
    
    mov dx, offset msg_pedir_coordenadas_base 
    call print
    call leerCoordenadas
    
    ret
endp



proc printMap

IMPRIMIR:
 
    mov dh, 00 ; Cursor en el renglon 00
    mov dl, 00 ; Cursor en la columna 00   
    call mov_cursor
    
    mov dx,offset mapaArriba
    call print
    mov dx, offset mapaAbajo
    call print
    
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
     
proc color_urss
    mov ax, 0600h ;config editar pantalla
    mov bh, 04h ; color
    
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
        
proc coordenada_unica
    
        xor dh, dh
        mov dl, coordenada
        mov aux_disparo, dx
    
        ret
endp      

     
        
     

proc print

    mov AH, 9
    int 21h
    
    ret
    
endp


proc mul_input_76
    
    xor bh, bh
    xor ah, ah
    mov al, 76
    mul bl
    
    
    ret
endp    

proc input_coordenada
    
    CICLO:

    call input_teclado
    call solo_numeros 
    call pasar_decimal
    call input_teclado
    call solo_numeros
    call sumar_segundodec
    
    
    mov coordenada, al
    mov bl, coordenada
    
    cmp csa, 3
    
    jg fin_ingreso
    
    cmp csa, 0
    je INGRESAR_X_URSS
    
    cmp csa, 1
    je INGRESAR_Y_URSS
    
    cmp csa, 2
    je INGRESAR_X_USA
    
    cmp csa, 3
    je INGRESAR_Y_USA
    
    jmp fin_ingreso
    
    INGRESAR_X_URSS:
                   
        xor bh, bh                  
        
        mov base_urss, bx
        
        jmp fin_ingreso
    
    INGRESAR_Y_URSS:
                  
        call mul_input_76 ;res en ax      
        add base_urss, ax
         
        jmp fin_ingreso
          
    INGRESAR_X_USA:
        
        xor bh, bh
        
        mov base_usa, bx 
        
        jmp fin_ingreso
        
    INGRESAR_Y_USA:
    
        call mul_input_76 ;res en ax
        add base_usa, ax
        
        jmp fin_ingreso
    
    fin_ingreso:
    
        inc csa   
    
    
    
     
    call input_teclado ; carga el valor en al
    
    cmp al, 013   ; si es 13 --> enter 
    jne CICLO
    
    cmp csa, 1
    je check_coordenada_urss
    
    cmp csa, 3
    je check_coordenada_usa
    
    jmp ok
    
    check_coordenada_urss:
    
        cmp coordenada, 33
        jl et_out_of_range
        
        cmp coordenada, 76
        jg et_out_of_range
                  
        jmp ok
    
    check_coordenada_usa:
    
        cmp coordenada, 33
        jg et_out_of_range   
        
        jmp ok
        
        
    et_out_of_range:
 
        inc out_of_range
        dec csa   
        call clean_console
    
        MOV DH,19 ; Cursor en el renglon 00
        MOV DL,00 ; Cursor en la columna 19
        call mov_cursor
        
        mov dx, offset msg_out_of_range
        call print
    
        ciclo_enter:       
        
            call input_teclado ; carga el valor en al
            cmp al, 013   ; si es 13 --> enter  
            jne ciclo_enter
            
    
    ok:   
    
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

proc sumar_segundodec
    
    sub al,48d
    add al,bl
    
    ret
    
endp    
         
URSS db 'URSS$'
USA db 'USA$'
msg_pedir_coordenadas_base db '',10,13,'Ingrese la ubicacion de su base secreta$'
msg_pedir_coordenada_x db '',10,13,'Ingrese coordenada x: $'
msg_pedir_coordenada_y db '',10,13,'Ingrese coordenada y: $'
msg_start_urss db 'Empieza disparando URSS$'
msg_start_usa db 'Empieza disparando USA$'
msg_turno_urss db 'turno de URSS$'
msg_turno_usa db 'turno de USA$'
msg_resultados db 'Resultado$'
msg_out_of_range db 'Fuera de rango$'


mapaArriba db "00..........................WAR GAMES -1983...............................",10,13,"01.......-.....:**:::*=-..-++++:............:--::=WWW***+-++-.............",10,13,"02...:=WWWWWWW=WWW=:::+:..::...--....:=+W==WWWWWWWWWWWWWWWWWWWWWWWW+-.....",10,13,"03..-....:WWWWWWWW=-=WW*.........--..+::+=WWWWWWWWWWWWWWWWWWWW:..:=.......",10,13,"04.......+WWWWWW*+WWW=-:-.........-+*=:::::=W*W=WWWW*++++++:+++=-.........",10,13,"05......*WWWWWWWWW=..............::..-:--+++::-++:::++++++++:--..-........",10,13,"06.......:**WW=*=...............-++++:::::-:+::++++++:++++++++............",10,13,"08........-+:...-..............:+++++::+:++-++::-.-++++::+:::-............",10,13,"09..........--:-...............::++:+++++++:-+:.....::...-+:...-..........",10,13,"$"
mapaAbajo db "10..............-+++:-..........:+::+::++++++:-......-....-...---.........",10,13,"11..............:::++++:-............::+++:+:.............:--+--.-........",10,13,"12..............-+++++++++:...........+:+::+................--.....---....",10,13,"13................:++++++:...........-+::+::.:-................-++:-:.....",10,13,"14.................++::+-.............::++:..:...............++++++++-....",10,13,"15.................:++:-...............::-..................-+:--:++:.....",10,13,"16.................:+-............................................-.....--",10,13,"17.................:....................................................--",10,13,"18.......UNITED STATES.........................SOVIET UNION...............$"


turno db ?
aux db 10
coordenada db ?
csa db 0
base_urss dw ?
base_usa dw ?
aux_disparo dw 0
urss_w db 40
usa_w db 40    
coordenada_x db 0
out_of_range db 0
msg_informar_resultado db 'informar resultado$'