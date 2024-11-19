# Lenguajes de Interfaz - Actividad 44
# Calculadora simple (Suma, Resta, Multiplicación, División)
# Alumno: Gómez Aguilar Jared Emmanuel  
# Número de Control: 22210309  
# Python y Ensamblador
# Aritmética y flujo de control

# ----------------------------------------------------
/*
def calculator(a, b, operation):
    if operation == "add":
        return a + b
    elif operation == "subtract":
        return a - b
    elif operation == "multiply":
        return a * b
    elif operation == "divide":
        return a / b if b != 0 else "Undefined"

*/
# -----------------------------------------------------

.data
    msg_menu:   .asciz "\n=== Calculadora Simple ===\n"
                .asciz "1. Suma\n"
                .asciz "2. Resta\n"
                .asciz "3. Multiplicacion\n"
                .asciz "4. Division\n"
                .asciz "5. Salir\n"
                .asciz "Opcion: "
               
    prompt1:    .asciz "Primer numero: "
    prompt2:    .asciz "Segundo numero: "
    result:     .asciz "\nResultado: "
    negativo:   .asciz "-"
    newline:    .asciz "\n"
    buffer:     .skip 4

.text
.global _start

_start:
inicio_menu:
    // Mostrar menú
    mov x0, #1              // stdout
    ldr x1, =msg_menu
    mov x2, #100           // longitud del menú
    mov x8, #64            // syscall write
    svc #0

    // Leer opción
    mov x0, #0              // stdin
    ldr x1, =buffer
    mov x2, #2              // leer 2 bytes (número + newline)
    mov x8, #63            // syscall read
    svc #0

    // Obtener opción
    ldr x1, =buffer
    ldrb w19, [x1]         // w19 = opción
    sub w19, w19, #'0'     // convertir ASCII a número

    // Verificar si es salir
    cmp w19, #5
    beq exit

    // Pedir primer número
    mov x0, #1
    ldr x1, =prompt1
    mov x2, #15
    mov x8, #64
    svc #0

    // Leer primer número
    mov x0, #0
    ldr x1, =buffer
    mov x2, #2
    mov x8, #63
    svc #0

    // Convertir primer número
    ldr x1, =buffer
    ldrb w20, [x1]         // w20 = primer número
    sub w20, w20, #'0'

    // Pedir segundo número
    mov x0, #1
    ldr x1, =prompt2
    mov x2, #16
    mov x8, #64
    svc #0

    // Leer segundo número
    mov x0, #0
    ldr x1, =buffer
    mov x2, #2
    mov x8, #63
    svc #0

    // Convertir segundo número
    ldr x1, =buffer
    ldrb w21, [x1]         // w21 = segundo número
    sub w21, w21, #'0'

    // Realizar operación según opción
    cmp w19, #1
    beq suma
    cmp w19, #2
    beq resta
    cmp w19, #3
    beq multiplicacion
    cmp w19, #4
    beq division
    b inicio_menu

suma:
    add w22, w20, w21      // w22 = resultado
    mov w23, #0            // w23 = 0 (positivo)
    b print_result

resta:
    cmp w20, w21           // Comparar números
    blt numero_negativo    // Si w20 < w21, resultado será negativo
    sub w22, w20, w21      // w22 = w20 - w21
    mov w23, #0            // w23 = 0 (positivo)
    b print_result

numero_negativo:
    sub w22, w21, w20      // w22 = w21 - w20 (invertimos la resta)
    mov w23, #1            // w23 = 1 (negativo)
    b print_result

multiplicacion:
    mul w22, w20, w21
    mov w23, #0            // w23 = 0 (positivo)
    b print_result

division:
    sdiv w22, w20, w21
    mov w23, #0            // w23 = 0 (positivo)
    b print_result

print_result:
    // Mostrar mensaje de resultado
    mov x0, #1
    ldr x1, =result
    mov x2, #11
    mov x8, #64
    svc #0

    // Si es negativo, mostrar el signo menos
    cmp w23, #1
    bne skip_negative
    mov x0, #1
    ldr x1, =negativo
    mov x2, #1
    mov x8, #64
    svc #0

skip_negative:
    // Convertir resultado a ASCII
    add w22, w22, #'0'     // convertir número a ASCII
    ldr x1, =buffer
    strb w22, [x1]         // guardar en buffer

    // Mostrar resultado
    mov x0, #1
    ldr x1, =buffer
    mov x2, #1
    mov x8, #64
    svc #0

    // Mostrar nueva línea
    mov x0, #1
    ldr x1, =newline
    mov x2, #1
    mov x8, #64
    svc #0

    b inicio_menu

exit:
    mov x0, #0
    mov x8, #93
    svc #0

ASCIINEMA REC
https://asciinema.org/a/690877
