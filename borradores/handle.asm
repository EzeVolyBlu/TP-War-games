
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h


;call create_file


open_file:

    mov al, 2 ;read/write
    mov dx, offset filename 
    mov ah, 3dh ;open file
    
    int 21h ; returns CF clear if succesful, ax = file handle
            ; CF set on error -> ax = error code
            
    jc err
    mov puntero_archivo, ax


read_file:        

    mov dx, offset buffer	    ; buffer para guardar los datos leidos
	mov cx, 70 			            ; por ej. cantidad de bytes a leer
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
        ;mov  bx, puntero_archivo
        mov  cx, 5  ;STRING LENGTH.
        mov  dx, offset urss
        int  21h
        
        jmp duracion_partida
    
    msg_ranking_usa_win:
    
        mov  ah, 40h
        ;mov  bx, puntero_archivo
        mov  cx, 4  ;STRING LENGTH.
        mov  dx, offset usa
        int  21h
        
    
    duracion_partida:
    
        mov al,1
        mov ah,2
        
        
        mov msg_intentos[16],al  
        mov msg_intentos[17],ah
        
        add msg_intentos[16],48  
        add msg_intentos[17],48
               
        mov  ah, 40h
        ;mov  bx, puntero_archivo
        mov  cx, 26  ;STRING LENGTH.
        mov  dx, offset msg_intentos
        int  21h
        
    

	
close_file:

    
	mov bx, puntero_archivo;
	mov ah, 3Eh
	int 21h

	
	

jmp k



err:

    inc error

k:    

ret

filename db "ranking.txt", 0
puntero_archivo dw ? 
error db 0
buffer db 71 dup('$')
;cant_bytes dw 0

msg_intentos db 'La partida duro ',?,?,' turnos',10,13,'$'
 


msg_results db "El ganador fue $";17

urss db 'urss',10,13
usa db 'usa',10,13

urss_win db 1
usa_win db 0




proc create_file:
    
    mov cx, 0   ; normal - no attributes
    mov dx, offset filename 
    mov ah, 3ch ; create or truncate file
    
    int 21h ; returns CF clear if succesful, ax = file handle
            ; CF set on error -> ax = error code
             
    jc err
    mov puntero_archivo, ax
    
    ret
endp    