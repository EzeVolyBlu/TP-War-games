“War Games” se compone de tres etapas, según se sugiere en las indicaciones del tp.: Iniciar juego, jugar y guardar ranking  
Se explicará el funcionamiento general del programa utilizando pseudocódigo como assembler. 

 - Procedimientos simples: algunos procedimientos se usan repetidas veces y estan hechos por pocas líneas, por lo tanto sólo se explicará para qué sirven. Por ej.

    proc clean_console: limpia la consola desde la fila 19 a la 24. 

    proc mov_cursor: ubica el cursor en una posición q recibe por paramámetros. (param: dx = fila , dl = columna ) 

    proc print: imprime un mensaje en pantalla (param: dx, ret: null)
    
    proc printMap: ubica el cursor en la posición 0. imprime el mapa del juego (param. mapaArriba; utiliza proc mov_cursor y proc print) 

    proc input_teclado: ingresa un caracter por teclado en cod. ascii (ret: al)
    
    proc press_enter:  genera un ciclo con una entrada por teclado que sale cuando se presiona enter. (utiliza proc input_teclado)

- Variables globales (posiciones de memoria).
 
    w_usa = 40
    w_urss = 40 ; Aclaración: en principio se desarrolló un metodo que al iniciar el juego contaba las W en el mapa (está en carpeta borradores 'count_W ok'). Se descartó el mismo porque insumía un tiempo considerable de ejecución y además arrojaba una desventaja (w_urss = 54 , w_usa = 40). Por tanto se decidió asignarle a cada uno 40 W.   

    base_urss = ? : toma el valor de un punto único en el mapa
    base_usa = ? : idem anterior

    out_of_range = 0; sirve como flag de control para que se ingresen correctamente las coordenadas
   
    turno = ? ; tomará un valor aleatorio y luego se irá incrementando por cada turno.  
    
    nro_inicio = ? ; guardará el valor aleatorio original. cuando termina la partida se usa para conocer el número de jugadas (turno - nro_inicio) 
    
    coordenada_x = 0; se le asignará valor con cada proc leerCoordenadas. se utiliza para saber a qué jugador restarle W
    
               switch(coordenada_x < 33){
                    case true: 
                         w_usa - 1
                    case false: 
                         w_urss - 1
                 }
 
     
    
- Funcionamiento del juego         
    
org 100h
programaPrincipal:

   1 call initJuego 
   2 call jugar
   3 call guardarRanking
    
ret

1 proc initJuego: 

     call printMap 
     establecer base urss:
        
        call print: "Urss ingrese base..." 
        call leerCoordenadas -> se explica al finalizar el proc initJuego
        verificar error de ingreso. ( out_of_range > 0 volver a 'establecer base urss' )
    
     establecer base usa:
    
        call print: "Usa ingrese base..." 
        call leerCoordenadas 
        verificar error de ingreso. ( out_of_range > 0 volver a 'establecer base usa' )

    - elegir turno: 
    
        generar un nro aleatorio: ( 21h / ah = 2c  -> CH = hour CL = minute DH = second DL = 1/100 seconds)
        turno = dh (segundos)
        nro_inicio = dh

        ret
endp
        
        leerCoordenadas es un procedimiento clave ya que se invoca en cada turno. Su finalidad es introducir una coordenada x,y y               transformarla en un número en el mapa
    
            Aclaración: verificar rango cambia las condiciones según la ocasión. Sin embargo su funcionamiento general es: 
            if(fuera de rango){
                saltar a et_out_of_range
             }

            BH = 0
            call print: "ingrese coordenada x "
            call input_coordenadas: se explica debajo. devuelve una cifra de dos dígitos en BL
            verificar rango
            switch 1 (csa)
                    case 0: 
                        verificar rango
                        base_urss = BX
                        csa + 1
                    case 2: ingresar_x_usa
                        verificar rango
                        base_usa = BX
                        csa + 1

            - guardo el valor en una variable coordenada_unica
            - coordenada_x = BL
            - coordenada_unica = BX
            
            - mensaje "ingrese coordenada y "
            - call input_coordenadas
            - verifico que no sobrepase el nro 18 
            
              switch 2 (csa)
                    case 1: 
                        verificar dentro de rango
                        AX = BX * 76
                        base_urss = base_urss + AX
                        csa + 1
                    case 3: ingresar_x_usa
                        AX = BX * 76
                        base_usa = base_usa + AX
                        csa + 1

            - coordenada_unica = coordenada_unica + BL * 76 

            if(fuera de rango){
               out_of_range + 1
               call clean_console
               call print: "fuera de rango" 
               call press_enter
               call clean_console
             }
            
            ret
        endp
              Cuando csa > 3 los switches y csa no tienen más utilidad, el programa se ocupará de saltarlos.

       proc input_coordenadas se encarga de convertir 2 ingresos de teclado en un número de 2 dígitos. Su funcionamiento es el siguiente:

        Ingreso_1: (ej '4' -> ret 40)

            call input_teclado (ret: al)
            verifico sea un número: 
               if(al<'0' or al>'9')
                   saltar a Ingreso_1
            call pasar_decimal: ; el nombre del proc no es el adecuado. debería ser 'convertir_a_decena'
                 al =  al - 48 (para pasar del cod. ascii al valor del número)
                 bl = al * 10

          Ingreso_2: (ej. '5' -> ret 45) 
             
            call input_teclado (ret: al)
            verifico sea un número: 
               if(al<'0' or al>'9')
                   saltar a Ingreso_2
            call sumar_segunda_dec:
                al = al - 48
                bl = bl + al


2 proc jugar:

      Inicio:

         call printMap
         
         control: 
            
              call informarPaisTurno
              call leerCoordenadas
              if(out_of_range > 0)
                 volver a control

          call disparar
          call informarResultado

          if(hay ganador)
            saltar a end_game

          turno + 1 
          saltar a Inicio

           end_game:

           ret
endp

  proc informarPaisTurno:

        call clean_console
        call mov_cursor (0,0)
        call revisa_paridad:  turno / 2 -> ah = resto de la div. (ah = 0 par; ah = 1 impar) 
        
        switch (ah)
            case 0:
                call print: "empieza urss"
            case 1:
                call print: "empieza usa"
        
        call print: "presione enter para continuar"   
        call press_enter
             
        ret
   endp

proc disparar: consiste en tomar el punto dado en coordenada_unica y junto a todos los puntos adyacentes realizar ciertas operaciones. Para recorrer los 9 puntos utiliza 2 ciclos anidados de la sig. manera:

  BX = coordenada_unica (el punto q retorna leerCoordenadas)
  BX = BX - 77 
       (cada fila tiene 76 caractéres, por tanto - 77 posiciona en la fila anterior y columna anterior. Esta sería la 1er posición de la matriz de 3x3.
        
  for (ciclos_filas < 3){

    for(ciclos_columnas < 3){
        realizar operaciones en BX
        BX = BX + 1
        ciclo_columnas + 1
       }

    BX = BX + 74 ; BX toma el valor de la siguiente fila primera columna de la matriz
    ciclo_filas + 1
  }

 operaciones:
        
    - chequear si hay una base: 
        if(base){
         coordenada_base = -1
         }

   - chequear si hay salto de linea:
        if(BX = 10 || BX = 13){
         no hacer nada. saltar al fin de ciclo
         }

   - chequear si hay 'W' y en tal caso restarle al jugador que corresponda
       if(BX = 'W'){

        switch(BX < 33){
         case true:
           w_usa - 1
         case false:
           w_urss - 1
        }
     }   

Al terminar los ciclos se vuelve a imprimir el mapa (printMap)
        
proc informarResultado:         
    
    call clean_console
    call mov_cursor
    
    informar_w: 
       
        call convert_w_to_number : este proceso convierte la cifra de W de cada jugador en 2 cifras ascii y devuelve un mensaje como "urss tiene 25 espacios. usa tiene 30 espacios" . Debajo se detallará su funcionamiento 
        call print: imprime el mensaje anterior 
    
        
    if(base_urss = -1){
     usa_win = true
     call print: "la base de urss fue destruida"
     call print: "usa ganó"
    }

    if(...) idem a la inversa

    contar_w:
        
        if(w_urss <= 0){
         usa_win = true
         call print: "usa ganó"
        }
        
        if(...) idem a la inversa
        
     print: "presione enter para continuar"
     call press_enter
        
     ret
endp
        
proc convert_w_to_number:
        
     al = urss_w ; cargamos la cantidad de w de un jugador en al. ej.: 35
     al = al / 10 --> 3
     ah = resto --> 5
     
     ; luego insertamos los valores en un mensaje:
        "urss tiene ",[al],[ah]," w" --> "urss tiene 35 w"
     
           
            
        



        
        
        
        
        
        
        
        
        
        
        
        
