;  Se ingresan 10 n�meros enteros. La computadora los muestra en orden creciente.

        global main              ; ETIQUETAS QUE MARCAN EL PUNTO DE INICIO DE LA EJECUCION
        global _start

        extern printf            ;
        extern scanf             ; FUNCIONES DE C (IMPORTADAS)
        extern exit              ;
        extern gets              ; GETS ES MUY PELIGROSA. SOLO USARLA EN EJERCICIOS BASICOS, JAMAS EN EL TRABAJO!!!



section .bss                     ; SECCION DE LAS VARIABLES

numero:
        resd    1                ; 1 dword (4 bytes)

cadena:
        resb    0x0100           ; 256 bytes

caracter:
        resb    1                ; 1 byte (dato)
        resb    3                ; 3 bytes (relleno)

section .data                    ; SECCION DE LAS CONSTANTES

x:                               ; Inicializo el array
   dd  10
   dd  9
   dd  8
   dd  7
   dd  6
   dd  3
   dd  2
   dd  4
   dd  5
   dd  100

y:                               ; Inicializo el segundo array
   dd  10
   dd  9
   dd  8
   dd  7
   dd  6
   dd  3
   dd  2
   dd  4
   dd  5
   dd  100

fmtInt:
        db    "%d", 0            ; FORMATO PARA NUMEROS ENTEROS

fmtString:
        db    "%s", 0            ; FORMATO PARA CADENAS

fmtChar:
        db    "%c", 0            ; FORMATO PARA CARACTERES

fmtLF:
        db    0xA, 0             ; SALTO DE LINEA (LF)

posicion:
	db    "Coincidio en la Posicion: ", 0		 ; Cadena "Coincidencia: "

segundoArray:
	db    "Ingrese numeros para comparar. 0 para terminar de cargar: ", 0		 ; Cadena "Coincidencia: "



section .text                    ; SECCION DE LAS INSTRUCCIONES

leerCadena:                      ; RUTINA PARA LEER UNA CADENA USANDO GETS
        push cadena
        call gets
        add esp, 4
        ret

leerNumero:                      ; RUTINA PARA LEER UN NUMERO ENTERO USANDO SCANF
        push numero
        push fmtInt
        call scanf
        add esp, 8
        ret

mostrarCadena:                   ; RUTINA PARA MOSTRAR UNA CADENA USANDO PRINTF
        push cadena
        push fmtString
        call printf
        add esp, 8
        ret

mostrarNumero:                   ; RUTINA PARA MOSTRAR UN NUMERO ENTERO USANDO PRINTF
        push dword [numero]
        push fmtInt
        call printf
        add esp, 8
        ret

mostrarCaracter:                 ; RUTINA PARA MOSTRAR UN CARACTER USANDO PRINTF
        push dword [caracter]
        push fmtChar
        call printf
        add esp, 8
        ret

mostrarSaltoDeLinea:             ; RUTINA PARA MOSTRAR UN SALTO DE LINEA USANDO PRINTF
        push fmtLF
        call printf
        add esp, 4
        ret

mostrarEspacio:             ; RUTINA PARA MOSTRAR UN ESPACIO USANDO PRINTF
        mov [caracter], byte ' '
        call mostrarCaracter
        ret

salirDelPrograma:                ; PUNTO DE SALIDA DEL PROGRAMA USANDO EXIT
        push 0
        call exit

_start:
main:                            ; PUNTO DE INICIO DEL PROGRAMA
        mov edi,0
        mov eax, 0
        mov ecx, 0
        mov ebx, 0
        mov esi, 0
        mov ebp, 0
        mov edx, 0

top:                             ; Llenamos el array
        call leerNumero
        mov eax, [numero]
        mov [x+edi], eax
        add edi, 4               ; Aumento de a 4 bytes porque es un dword
        add ebx, 1
        cmp ebx, 10              ; Si llego a 10 ya complet� el array
        jne top

        mov eax, 0
        mov ebx, 0
        mov edi, 0
copiaAcadena1:
	mov al, [edx+segundoArray]
	mov [edx+cadena], al
	inc edx
	cmp al, 0
	jne copiaAcadena1
	call mostrarCadena

top2:                             ; Llenamos el segundo array
        call leerNumero
        mov eax, [numero]
        mov [y+edi], eax
        add edi, 4               ; Aumento de a 4 bytes porque es un dword
        add ebx, 1
        cmp eax, 0              ; Si ingresa un 0 se termina la carga
        jne top2

        mov eax, 0
        mov ebx, 0
        mov edi, 0

ordenar:
        add ebx, 1
		mov ecx, [x+esi]
		cmp ecx, [y+edi]
		je ubicarMayor
		mov ebp, [y+edi]
		cmp ebp, 0
		je finPrograma
		add esi, 4
		cmp esi, 40               ; Como es un array de 10 n�meros y ESI aumenta de a 4, si llego a 40 llegu� al final del array
		je reiniciar
		jmp ordenar

ubicarMayor:
        mov ebp, [y + edi]
        mov [numero], ebp
        call mostrarNumero

        mov eax, 32
        mov [caracter], eax
        call mostrarCaracter

        jmp copiaAcadena2

copiaAcadena2:
	mov al, [edx+posicion]
	mov [edx+cadena], al
	inc edx
	cmp al, 0
	jne copiaAcadena2
	call mostrarCadena

mostrarSiguiente:
        mov [numero], ebx
        call mostrarNumero
        call mostrarSaltoDeLinea
        add edi, 4
        mov esi, 0
        mov ebx, 0

		jmp ordenar


reiniciar:

		mov esi, 0
		add edi, 4
		mov ebx, 0
		jmp ordenar

finPrograma:
        call mostrarSaltoDeLinea
        jmp salirDelPrograma
