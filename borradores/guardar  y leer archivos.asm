
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h
      



call abrir
call leer
call cerrar  
call imprimir

   
ret  





; proc


proc abrir
	mov al, 0h                      ; modo lectura
	mov dx, offset path_archivo     ; debe estar la etiqueta
	mov ah, 3dh                     ; path_archivo db "c:\..."
	int 21h                         ; en ax dev uelve un puntero al archivo

	mov puntero_archivo, ax        ; debe estar la etiqueta
	ret			                    ; puntero_archivo dw ?	
endp  



proc leer

	mov dx, offset linea_leida	    ; buffer para guardar los datos leidos
	mov cx, 70 			            ; por ej. cantidad de bytes a leer
	mov bx, puntero_archivo		 
	mov ah, 3Fh, 
	int 21h				            ; invocamos a la interrupción. guarda en ax la cantidad de bytes leidos
	ret
endp


proc cerrar

	mov bx, puntero_archivo;
	mov ah, 3Eh
	int 21h
	ret

endp 

proc imprimir
    
MOV AH, 9
mov dx, offset linea_leida
INT 21h

ret 

endp   


path_archivo db "c:\archivo.txt"
puntero_archivo dw ?
linea_leida db 71 dup('$')
    
    




