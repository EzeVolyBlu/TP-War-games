
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

; add your code here  

call initJuego

ret




;PROC


proc initJuego 
    
    ;call PrintMap
    mov dx, offset URSS
    call print
    call establecerBase
    
    mov dx, offset URSS
    call print
    call establecerBase
    
    
    
        
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
                  
    mov dx, offset pedir_coordenada_y
    call print    
    call input_coordenada                  
                  
    
ret        
    
    
endp         
     

proc print

    mov AH, 9
    int 21h
    
    ret
    
endp


proc conver_decimal
       
    sub al, 48
    mov coordenada, al
    mov ultimo_ingreso, al   
       
    
    ret
endp
  
  
  
  
  
  
  
proc input_coordenada
    
    CICLO:
    
    xor ah,ah
    mov al,10
    mul coordenada
    mov coordenada, al
    mov al, ultimo_ingreso
    
    
    
    
    
    
    

    call input_teclado
    call solo_numeros
    call conver_decimal
    
    
    
    cmp AL, 013
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
         
URSS db 'URSS$'
USA db 'USA$'
iniciar_juego db 'Iniciar juego$'
pedir_coordenadas_base db '',10,13,'Ingrese la ubicacion de su base secreta$'
pedir_coordenada_x db '',10,13,'Ingrese coordenada x: $'
pedir_coordenada_y db '',10,13,'Ingrese coordenada y: $'

coordenada db 0
ultimo_ingreso db 0