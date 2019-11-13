org 100h

programaPrincipal:


    call initJuego
    call jugar
    ;call guardarRanking
    
    
ret


;PROC

proc jugar
                 
                 
    INICIO:             
                 
        call printMap
        call informarPaisTurno
        call leerCoordenadas
        ;call disparar
        ;call informarResultado
        ;call actualizarSiguienteTurno
        inc turno
        
        
        jmp INICIO
    
    ret
endp    

proc leerCoordenadas
    
    
    call ingresarCoordenadas
    
    
    
    mov al, 4
    
    
    
    ret
endp    
 
proc informarPaisTurno
    
    call clean_console
    call cursor_bl_map
    
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


proc initJuego 
    
    call printMap
    call pedir_coordenadas_bases
    call elegir_turno
    call informar_quien_empieza
    
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
    call cursor_bl_map  
    
    
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

    call cursor_bl_map       
    
    
    mov dx, offset URSS
    call print
    call establecerBase
    
    
    call clean_console
    call cursor_bl_map              
            
    
    
    mov dx, offset USA
    call print
    call establecerBase
    
    
    
    ret
endp         


proc printMap
    
;se imprme el mapa en dos partes
mov bx,76
mov cx,2
add bx, cx
mov mapaArriba [bx],"z"

IMPRIMIR:
    
    call cursor_top
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

proc cursor_top       
        
    MOV AH,02H ; Peticion para colocar el cursor
    MOV BH,00 ; Nunmero de pagina a imprimir
    MOV DH,00 ; Cursor en el renglon 00
    MOV DL,00 ; Cursor en la columna 00
    INT 10H ; Interrupcion al bios
    ret
endp               




    
proc cursor_bl_map       
        
        MOV AH,02H ; Peticion para colocar el cursor
        MOV BH,00 ; Nunmero de pagina a imprimir
        MOV DH,19 ; Cursor en el renglon 00
        MOV DL,00 ; Cursor en la columna 00
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
        
        

proc establecerBase
    
    mov dx, offset pedir_coordenadas_base 
    call print
    call ingresarCoordenadas
ret
         
endp
     
     

     
proc ingresarCoordenadas
    
    mov dx, offset pedir_coordenada_x
    call print    
    call input_coordenada
                         
    xor dh, dh
    mov dl, coordenada
    mov aux_disparo, dx
                  
    mov dx, offset pedir_coordenada_y
    call print    
    call input_coordenada
    
    mov bl, coordenada
    call mul_input_76
    add aux_disparo, ax
                      
                  
    
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
    
    
    
     
    call input_teclado
    
    
    
    cmp al, 013
    jne CICLO
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
iniciar_juego db 'Iniciar juego$'
pedir_coordenadas_base db '',10,13,'Ingrese la ubicacion de su base secreta$'
pedir_coordenada_x db '',10,13,'Ingrese coordenada x: $'
pedir_coordenada_y db '',10,13,'Ingrese coordenada y: $'
mapaArriba db "00..........................WAR GAMES -1983..............................",10,13,"01.......-.....:**:::*=-..-++++:............:--::=WWW***+-++-.............",10,13,"02...:=WWWWWWW=WWW=:::+:..::...--....:=+W==WWWWWWWWWWWWWWWWWWWWWWWW+-.....",10,13,"03..-....:WWWWWWWW=-=WW*.........--..+::+=WWWWWWWWWWWWWWWWWWWW:..:=.......",10,13,"04.......+WWWWWW*+WWW=-:-.........-+*=:::::=W*W=WWWW*++++++:+++=-.........",10,13,"05......*WWWWWWWWW=..............::..-:--+++::-++:::++++++++:--..-........",10,13,"06.......:**WW=*=...............-++++:::::-:+::++++++:++++++++............",10,13,"08........-+:...-..............:+++++::+:++-++::-.-++++::+:::-............",10,13,"09..........--:-...............::++:+++++++:-+:.....::...-+:...-..........",10,13,"$"
mapaAbajo db "10..............-+++:-..........:+::+::++++++:-......-....-...---.........",10,13,"11..............:::++++:-............::+++:+:.............:--+--.-........",10,13,"12..............-+++++++++:...........+:+::+................--.....---....",10,13,"13................:++++++:...........-+::+::.:-................-++:-:.....",10,13,"14.................++::+-.............::++:..:...............++++++++-....",10,13,"15.................:++:-...............::-..................-+:--:++:.....",10,13,"16.................:+-............................................-.....--",10,13,"17.................:....................................................--",10,13,"18.......UNITED STATES.........................SOVIET UNION...............$"

msg_start_urss db 'Empieza disparando URSS$'
msg_start_usa db 'Empieza disparando USA$'

msg_turno_urss db 'turno de URSS$'
msg_turno_usa db 'turno de USA$'

turno db ?
               
msg_aux db ?               

    
aux db 10
coordenada db ?

csa db 0


base_urss dw ?
base_usa dw ?

aux_disparo dw 0

