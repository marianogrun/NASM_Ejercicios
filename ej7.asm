; Se ingresa una matriz. La computadora muestra los valores en su diagonal principal.
;
; En Windows (1 en la consola de NASM; 2 y 3 en la consola de Visual Studio):
; 1) nasm -f win32 ej3.asm --PREFIX _
; 2) link /out:ej3.exe ej3.obj libcmt.lib
; 3) ej3
;
; En Windows (1 en la consola de NASM; 2 y 3 en la consola de Windows, dentro de la carpeta [ajustando los nros. de version]: C:\Qt\Qt5.3.1\Tools\mingw482_32\bin ):
; 1) nasm -f win32 ej3.asm --PREFIX _
; 2) gcc ej3.obj -o ej3.exe
; 3) ej3
;
; En GNU/Linux:
; 1) nasm -f elf ej3.asm
; 2) ld -s -o ej3 ej3.o -lc -I /lib/ld-linux.so.2
; 3) ./ej3
;
; En GNU/Linux de 64 bits (Previamente, en Ubuntu, hay que ejecutar: sudo apt-get install libc6-dev-i386):
; 1) nasm -f elf ej3.asm
; 2) ld -m elf_i386 -s -o ej3 ej3.o -lc -I /lib/ld-linux.so.2
; 3) ./ej3



        global main              ; ETIQUETAS QUE MARCAN EL PUNTO DE INICIO DE LA EJECUCION
        global _start

        extern printf            ;
        extern scanf             ; FUNCIONES DE C (IMPORTADAS)
        extern exit              ;
        extern gets              ; GETS ES MUY PELIGROSA. SOLO USARLA EN EJERCICIOS BASICOS, JAMAS EN EL TRABAJO!!!



section .bss                     ; SECCION DE LAS VARIABLES

numero:
        resd    1                ; 1 dword (4 bytes)
numero2:
        resd    1                ; 1 dword (4 bytes)


cadena:
        resb    0x0100           ; 256 bytes

caracter:
        resb    1                ; 1 byte (dato)
        resb    3                ; 3 bytes (relleno)

matriz:
	resd	100		 ;  matriz como maximo de 10x10

n:
	resd	1		 ;  lado de la matriz (cuadrada)
n2:
	resd	1		 ;  lado de la matriz (cuadrada)

f:
	resd	1		 ; fila

c:
	resd	1		 ; columna

section .data                    ; SECCION DE LAS CONSTANTES

fmtInt:
        db    "%d", 0            ; FORMATO PARA NUMEROS ENTEROS

fmtString:
        db    "%s", 0            ; FORMATO PARA CADENAS

fmtChar:
        db    "%c", 0            ; FORMATO PARA CARACTERES

fmtLF:
        db    0xA, 0             ; SALTO DE LINEA (LF)

nStrFila:
	db    "N fila: ", 0		 ; Cadena "N: "

nStrCol:
	db    "N columna: ", 0		 ; Cadena "N: "


filaStr:
	db    "Fila:", 0	 ;  Cadena "Fila:"

columnaStr:
	db    " Columna:", 0	 ;  Cadena "Columna:"

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

salirDelPrograma:                ; PUNTO DE SALIDA DEL PROGRAMA USANDO EXIT
        push 0
        call exit

_start:
main:                            ; PUNTO DE INICIO DEL PROGRAMA
	mov esi, 0
	mov ebx, 0
	mov eax, 1
	mov ecx, 0
	mov [numero2], eax
copiaAcadena1:
	mov al, [ebx+nStrCol]
	mov [ebx+cadena], al
	inc ebx
	cmp al, 0
	jne copiaAcadena1
	call mostrarCadena
	call leerNumero

	mov eax, [numero]
	cmp eax, 0
	jg seguir1
	jmp main
seguir1:
	cmp eax, 11
	jl seguir2
	jmp main
seguir2:
	mov [n], eax

	mov [f], dword 0
proximoF1:
	mov [c], dword 0
proximoC1:
	mov ebx, 0
copiaAcadena2:
	mov al, [ebx+nStrFila]
	mov [ebx+cadena], al
	inc ebx
	cmp al, 0
	jne copiaAcadena2
	call mostrarCadena
	call leerNumero

	mov ecx, [numero]
	cmp ecx, 0
	jg seguir3
	jmp main

seguir3:
	mov [n2], ecx

	mov [f], dword 0
proximoF2:
	mov [c], dword 0
proximoC2:
	mov ebx, 0
copiaAcadena3:
	mov al, [ebx+filaStr]
	mov [ebx+cadena], al
	inc ebx
	cmp al, 0
	jne copiaAcadena3
	call mostrarCadena

	mov eax, [f]
	mov [numero], eax
	call mostrarNumero

	mov ebx, 0
copiaAcadena4:
	mov al, [ebx+columnaStr]
	mov [ebx+cadena], al
	inc ebx
	cmp al, 0
	jne copiaAcadena4
	call mostrarCadena

	mov eax, [c]
	mov [numero], eax
	call mostrarNumero

	mov eax, 32
	mov [caracter], eax
	call mostrarCaracter
	call mostrarCaracter
	call leerNumero
	mov eax, [numero]
	mov [esi+matriz], eax
	add esi, 4

	inc dword [c]
	mov eax, [c]
	cmp eax, [n]
	jb proximoC2

	inc dword [f]
	mov ecx, [f]
	cmp ecx, [n2]
	jb proximoF2

	call mostrarSaltoDeLinea
    mov eax,[n]
	mov ebx,[n2]
	mul ebx
	mov [numero2],eax
	mov edi, 0
	mov esi, matriz
	mov ebx, 0
cicloDiagonal:

	mov eax, ebx
	mov [numero], eax
	call mostrarNumero

	mov eax,[esi]

	cmp eax, ebx
    jg numeroMayor

	mov eax, 32
	mov [caracter], eax
	call mostrarCaracter

    add esi, 4
	inc edi
	cmp edi, [numero2]
	jl cicloDiagonal

	call mostrarSaltoDeLinea

	mov eax, ebx
	mov [numero], eax
	call mostrarNumero

	jmp salirDelPrograma

numeroMayor:
    mov ebx, [esi]

    add esi, 4
	mov eax, 32
	mov [caracter], eax
	call mostrarCaracter

	inc edi
	cmp edi, [numero2]
	jl cicloDiagonal

	call mostrarSaltoDeLinea

	mov eax, ebx
	mov [numero], eax
	call mostrarNumero

        jmp salirDelPrograma
