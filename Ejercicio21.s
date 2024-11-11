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
// fibonacci.s
.global _start

.data
    buffer:     .space  20     // Buffer para conversión de números
    newline:    .byte   10     // Carácter de nueva línea
    space:      .byte   32     // Carácter de espacio

.text
_start:
    mov x0, #10           // Número de términos a generar
    bl fibonacci
    
    // Salir del programa
    mov x8, #93
    mov x0, #0
    svc #0

fibonacci:
    // Entrada:
    // x0: número de términos a generar
    stp x29, x30, [sp, #-16]!  // Guardar registros
    mov x29, sp
    
    mov x19, x0                // Guardar n
    mov x20, #0               // a = 0
    mov x21, #1              // b = 1
    mov x22, #0             // contador = 0
    
fib_loop:
    cmp x22, x19            // Comparar contador con n
    b.ge fib_end           // Si contador >= n, terminar
    
    // Imprimir número actual (x20)
    mov x0, x20
    bl print_num
    
    // Imprimir espacio
    mov x0, #1          // fd = 1 (stdout)
    ldr x1, =space     // buffer
    mov x2, #1        // length
    mov x8, #64      // syscall write
    svc #0
    
    // Calcular siguiente número
    add x23, x20, x21    // temp = a + b
    mov x20, x21        // a = b
    mov x21, x23       // b = temp
    
    add x22, x22, #1    // contador++
    b fib_loop

fib_end:
    // Imprimir nueva línea
    mov x0, #1
    ldr x1, =newline
    mov x2, #1
    mov x8, #64
    svc #0
    
    ldp x29, x30, [sp], #16
    ret

print_num:
    // Entrada:
    // x0: número a imprimir
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    
    // Convertir número a string
    mov x1, #0          // Contador de dígitos
    ldr x2, =buffer
    add x2, x2, #19    // Apuntar al final del buffer
    
convert_loop:
    mov x3, #10
    udiv x4, x0, x3    // x4 = x0 / 10
    msub x5, x4, x3, x0 // x5 = x0 - (x4 * 10)
    add x5, x5, #'0'   // Convertir a ASCII
    strb w5, [x2]      // Guardar dígito
    sub x2, x2, #1     // Retroceder en buffer
    add x1, x1, #1     // Incrementar contador
    mov x0, x4         // Preparar siguiente división
    cbnz x0, convert_loop
    
    // Imprimir número
    add x2, x2, #1     // Ajustar puntero
    mov x0, #1         // fd = 1 (stdout)
    mov x8, #64       // syscall write
    svc #0
    
    ldp x29, x30, [sp], #16
    ret
