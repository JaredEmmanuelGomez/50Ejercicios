# Lenguajes de Interfaz - Actividad 21
# Serie de Fibonacci
# Alumno: Gómez Aguilar Jared Emmanuel  
# Número de Control: 22210309  
# Python y Ensamblador
# Bucles y manejo de memoria

# -------------------------------
/*
def fibonacci(n):
    a, b = 0, 1
    for _ in range(n):
        print(a, end=' ')
        a, b = b, a + b
*/
# -------------------------------

// Gómez Aguilar Jared Emmanuel
// 22210309
.data
    newline: .ascii "\n"
    space:   .ascii " "
    buffer:  .skip 20
    
.text
.global _start

_start:
    // x19 = primer número
    // x20 = segundo número
    // x21 = contador
    // x22 = límite
    mov x19, #0         // F(0)
    mov x20, #1         // F(1)
    mov x21, #0         // contador = 0
    mov x22, #10        // límite = 10 números

print_loop:
    // Guardamos los registros que vamos a usar
    stp x19, x20, [sp, #-16]!
    stp x21, x22, [sp, #-16]!

// Convertimos x19 a string
mov x0, x19
bl int_to_string

// Imprimimos el número
bl print_string

// Imprimimos espacio
ldr x0, =space
mov x1, #1
bl print_text

// Restauramos registros
ldp x21, x22, [sp], #16
ldp x19, x20, [sp], #16

// Calculamos siguiente número Fibonacci
mov x23, x19        // Guardamos F(n)
mov x19, x20        // F(n) = F(n+1)
add x20, x23, x20   // F(n+1) = F(n) + F(n+1)

// Incrementamos contador y verificamos si terminamos
add x21, x21, #1
cmp x21, x22
b.lt print_loop

// Imprimimos nueva línea al final
ldr x0, =newline
mov x1, #1
bl print_text

// Terminamos el programa
mov x0, #0
mov x8, #93
svc #0

// Función para convertir entero a string
int_to_string:
    // Preparamos buffer
    ldr x1, =buffer
    mov x2, #0          // longitud

// Si el número es 0, manejamos caso especial
cmp x0, #0
b.ne convert_loop
mov w3, #'0'
strb w3, [x1]
mov x0, x1
mov x1, #1
ret

convert_loop:
    // Dividimos por 10
    mov x3, #10
    udiv x4, x0, x3     // x4 = x0 / 10
    msub x5, x4, x3, x0 // x5 = remainder

// Convertimos dígito a ASCII y guardamos
add x5, x5, #'0'
strb w5, [x1, x2]

// Incrementamos longitud
add x2, x2, #1

// Actualizamos número
mov x0, x4

// Si quedan dígitos, continuamos
cbnz x0, convert_loop

// Invertimos string
mov x3, #0          // inicio
sub x4, x2, #1      // fin

reverse_loop:
    cmp x3, x4
    b.ge reverse_done

// Intercambiamos caracteres
ldrb w5, [x1, x3]
ldrb w6, [x1, x4]
strb w6, [x1, x3]
strb w5, [x1, x4]

add x3, x3, #1
sub x4, x4, #1
b reverse_loop

reverse_done:
    mov x0, x1          // retornamos puntero al string
    mov x1, x2          // retornamos longitud
    ret

// Función para imprimir texto
print_text:
    mov x2, x1          // longitud
    mov x1, x0          // buffer
    mov x0, #1          // stdout
    mov x8, #64         // syscall write
    svc #0
    ret

// Función para imprimir string
print_string:
    mov x2, x1          // longitud
    mov x1, x0          // buffer
    mov x0, #1          // stdout
    mov x8, #64         // syscall write
    svc #0
    ret

ASCIINEMA REC
https://asciinema.org/a/690689
