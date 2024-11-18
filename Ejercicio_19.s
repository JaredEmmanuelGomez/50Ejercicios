# Lenguajes de Interfaz - Actividad 19
# Suma de elementos en un arreglo
# Alumno: Gómez Aguilar Jared Emmanuel  
# Número de Control: 22210309  
# Python y Ensamblador

# ---------------------------------------
/*
def suma_arreglo(arreglo):
    return sum(arreglo)
*/
# ---------------------------------------

// Gómez Aguilar Jared Emmanuel
// 22210309
.data
    array:      .quad 1, 2, 3, 4, 5  // Arreglo de números
    arr_size:   .quad 5              // Tamaño del arreglo
    result:     .quad 0              // Resultado
    fmt_str:    .asciz "Suma del arreglo: %lld\n"

.text
.global main
.align 2

main:
    stp x29, x30, [sp, #-16]!    // Guardar registros
    mov x29, sp

    // Inicializar
    adr x0, array                // Dirección del arreglo
    ldr x1, arr_size            // Tamaño del arreglo
    mov x2, #0                   // Suma inicial

sum_loop:
    ldr x3, [x0], #8            // Cargar siguiente elemento
    add x2, x2, x3              // Sumar al total
    subs x1, x1, #1             // Decrementar contador
    b.ne sum_loop               // Continuar si no es cero

    // Guardar resultado
    adr x3, result
    str x2, [x3]

    // Imprimir resultado
    adr x0, fmt_str
    ldr x1, result
    bl printf

    mov w0, #0
    ldp x29, x30, [sp], #16
    ret

ASCIINEMA
https://asciinema.org/a/688680
