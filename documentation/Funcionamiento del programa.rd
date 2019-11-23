“War Games” se compone de tres etapas, según se sugiere en las indicaciones del tp.: Iniciar juego, jugar y guardar ranking  
Se explicará el funcionamiento general del programa utilizando pseudocódigo como assembler. 

org 100h
programaPrincipal:

    call initJuego 
    call jugar
    call guardarRanking
    
ret

proc initJuego: 

    - call printMap -> carga los offset de los mapas en dx y los imprime (call print)
    - establecer base urss:
        
        mensaje: "Urss ingrese base..." -> todos los mensajes se imprimen con el proc call print ( int 21h / ah = 9 )
        call leerCoordenadas -> se explica al finalizar el proc initJuego
        verificar error de ingreso. ( out_of_range > 0 volver a 'establecer base urss' )
    
    - establecer base usa:
    
        mensaje: "Usa ingrese base..." 
        call leerCoordenadas 
        verificar error de ingreso. ( out_of_range > 0 volver a 'establecer base usa' )

    - elegir turno: 
    
        genera un nro aleatorio: ( 21h / ah = 2c  -> CH = hour CL = minute DH = second DL = 1/100 seconds)
        turno = dh (segundos)
        nro_inicio = dh: nro_inicio se usará al final de la partida para saber cuantas jugadas hubieron (turno - nro_inicio) 

    - informar quien empieza
    
        call clean_console: limpia la consola (int 10h / ax = 0600h)
        call revisa_paridad:  dh (segundos) / 2 -> ah = resto de la div. (ah = 0 par; ah = 1 impar) 
        
        switch (ah)
            case 0:
                mensaje: "empieza urss"
            case 1:
                mensaje: "empieza usa"
           
        call press_enter (ciclo): 
             mensaje "presione enter para continuar"
             call input_teclado (int 21h / ah = 7) -> al
             if (al != 13)      ; 13 es el ascii de enter
                volver a press_enter
        
        ret
endp
        
        leerCoordenadas es un procedimiento clave ya que se invoca en cada turno. Tanto para ingresar las bases como para                       disparar. Su funcionamiento se puede describir de la siguiente forma:
    
            Aclaración: cáda vez que se hace una verificación, si la coordenada no está en los límites el programa salta a la etiqueta                 out_of_range. 
    
            - mensaje: "ingrese coordenada x "
            - call input_coordenadas: se explica debajo. devuelve una cifra de dos dígitos.
            - verifico que no sobrepase el nro 76
            - switch 1 
            - guardo el valor en una variable coordenada_unica
            
            - mensaje "ingrese coordenada y "
            - call input_coordenadas
            - verifico que no sobrepase el nro 18 
            - switch 2 
            - multiplico el valor por 76 (largo de la fila) y lo sumo a la variable coordenada_unica. Esta variable transforma las                       coordenadas x e y en un punto en el mapa
            
            switch 1 y 2: el juego inicia con una variable llamada csa (contador super auxiliar) que vale 0 que se incrementa cuando se             guarda alguna base.  El funcionamiento se puede describir de esta manera:
            
                switch 1 (csa)
                    case 0: ingresar_x_urss
                            csa + 1
                    case 2: ingresar_x_usa
                            csa + 1
            
                switch 2 (csa)
                    case 1: ingresar_y_urss
                            csa + 1
                    case 3: ingresar_y_usa
                            csa + 1
              
              Cada vez que se ingresa una coordenada de base se verifica esté en los límites. Cuando csa > 3 los switches y csa no                      tienen más utilidad, el programa se ocupará de saltarlos.
              
              proc input_coordenadas:
                            
        


