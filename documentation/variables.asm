msg_urss_w db 'URSS tiene ',?,?,' espacios',10,13
msg_usa_w db 'USA tiene ',?,?,' espacios$'
msg_intentos db 'La partida duro ',?,?,' turnos',10,13,'$'
msg_error db 'errorrororr$'

         
URSS db 'URSS',10,13,'$'
USA db 'USA',10,13,'$'
msg_pedir_coordenadas_base db 'Ingrese la ubicacion de su base secreta$'
msg_pedir_coordenada_x db '',10,13,'Ingrese coordenada x: $'
msg_pedir_coordenada_y db '',10,13,'Ingrese coordenada y: $'
msg_start_urss db 'Empieza disparando URSS$'
msg_start_usa db 'Empieza disparando USA$'
msg_turno_urss db 'turno de URSS$'
msg_turno_usa db 'turno de USA$'
msg_resultados db 'Resultado$'
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
urss_win db 0
usa_win db 0

puntero_archivo dw ?

buffer db 700 dup('$')
msg_results db "El ganador fue $";17
