# Lenguajes de Interfaz - Actividad 38
# Potencia (x^n)
# Alumno: Gómez Aguilar Jared Emmanuel  
# Número de Control: 22210309  
# Python y Ensamblador
# Recursión/bucles

# --------------------
/*
def power(x, n):
    return x ** n
*/
# -------------------

// Gómez Aguilar Jared Emmanuel
// 22210309
.global _start

.section .data
msg1: .ascii "Calculando "    // 11 caracteres
base_str: .ascii "2"          // Base (x)
msg2: .ascii " elevado a "    // 11 caracteres
exp_str: .ascii "5"           // Exponente (n)
msg3: .ascii " es: "          // 5 caracteres
len1 = . - msg1
buffer: .skip 20
newline: .ascii "\n"

.text
_start:
    // Inicializar valores
    mov x19, #2         // Base (x)
    mov x20, #5         // Exponente (n)
    mov x21, #1         // Resultado, comenzamos con 1

calcular_potencia:
    // Si el exponente es 0, ya tenemos el resultado (1)
    cbz x20, imprimir_resultado
    
    // Multiplicar resultado por la base
    mul x21, x21, x19   // resultado = resultado * base
    
    // Decrementar exponente
    sub x20, x20, #1    // exponente--
    
    // Continuar si el exponente > 0
    cbnz x20, calcular_potencia

imprimir_resultado:
    // Imprimir mensaje inicial
    mov x0, #1          // stdout
    ldr x1, =msg1      
    mov x2, len1        
    mov x8, #64         // syscall write
    svc #0

    // Convertir resultado a string
    ldr x1, =buffer     // puntero al buffer
    mov x2, x21         // número a convertir
    mov x4, #0          // contador de dígitos

convertir_loop:
    mov x3, #10
    udiv x5, x2, x3     // dividir por 10
    msub x6, x5, x3, x2 // obtener resto
    add x6, x6, #'0'    // convertir a ASCII
    strb w6, [x1, x4]   // guardar dígito
    add x4, x4, #1      // incrementar contador
    mov x2, x5          // actualizar número
    cbnz x2, convertir_loop

    // Invertir string
    mov x5, #0          // índice inicio
    sub x6, x4, #1      // índice final
invertir:
    cmp x5, x6
    bge print_result
    ldrb w7, [x1, x5]   // cargar byte inicio
    ldrb w8, [x1, x6]   // cargar byte final
    strb w8, [x1, x5]   // guardar final en inicio
    strb w7, [x1, x6]   // guardar inicio en final
    add x5, x5, #1      // incrementar inicio
    sub x6, x6, #1      // decrementar final
    b invertir

print_result:
    // Imprimir resultado
    mov x0, #1          // stdout
    ldr x1, =buffer     // puntero al buffer
    mov x2, x4          // longitud del número
    mov x8, #64         // syscall write
    svc #0

    // Imprimir nueva línea
    mov x0, #1          // stdout
    ldr x1, =newline    // puntero a nueva línea
    mov x2, #1          // longitud = 1
    mov x8, #64         // syscall write
    svc #0

exit:
    mov x0, #0          // código de retorno
    mov x8, #93         // syscall exit
    svc #0
