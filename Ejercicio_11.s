# Lenguajes de Interfaz - Actividad 11
# Invertir una cadena
# Alumno: Gómez Aguilar Jared Emmanuel  
# Número de Control: 22210309  
# Python y Ensamblador

# ------------------------
/*
def invertir_cadena(cadena):
    return cadena[::-1]
*/
# --------------------------


//Alumno: Gómez Aguilar Jared Emmanuel 
//Número de Control: 22210309 
.data
msg1:    .ascii "Ingrese una cadena: "
len1 = . - msg1
msg2:    .ascii "Cadena invertida: "
len2 = . - msg2
buffer:  .skip 100       // Buffer para almacenar la cadena
newline: .ascii "\n"
.text
.global _start
_start:
    // Mostrar mensaje para ingresar la cadena
    mov x0, #1              // stdout
    ldr x1, =msg1           // mensaje
    mov x2, #len1           // longitud
    mov x8, #64            // syscall write
    svc #0

// Leer la cadena
mov x0, #0              // stdin
ldr x1, =buffer         // buffer
mov x2, #100            // tamaño máximo
mov x8, #63            // syscall read
svc #0

// Guardar longitud de la cadena
sub x0, x0, #1          // Restar 1 para quitar el newline
mov x19, x0             // Guardar longitud en x19

// Preparar para invertir
ldr x1, =buffer         // Dirección inicio
add x2, x1, x19         // Dirección final
sub x2, x2, #1          // Ajustar para último carácter

invertir:
    // Verificar si terminamos
    cmp x1, x2
    b.ge mostrar_resultado

// Intercambiar caracteres
ldrb w3, [x1]           // Cargar primer carácter
ldrb w4, [x2]           // Cargar último carácter

strb w4, [x1], #1       // Guardar y avanzar desde inicio
strb w3, [x2], #-1      // Guardar y retroceder desde final

b invertir

mostrar_resultado:
    // Mostrar mensaje de resultado
    mov x0, #1              // stdout
    ldr x1, =msg2           // mensaje
    mov x2, #len2           // longitud
    mov x8, #64            // syscall write
    svc #0

// Mostrar cadena invertida
mov x0, #1              // stdout
ldr x1, =buffer         // cadena invertida
mov x2, x19             // longitud original
mov x8, #64            // syscall write
svc #0

// Mostrar nueva línea
mov x0, #1              // stdout
ldr x1, =newline        // nueva línea
mov x2, #1              // longitud
mov x8, #64            // syscall write
svc #0

salir:
    // Terminar programa
    mov x0, #0
    mov x8, #93
    svc #0

ASCIINEMA
https://asciinema.org/a/690679
