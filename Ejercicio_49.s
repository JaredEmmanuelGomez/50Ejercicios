# Lenguajes de Interfaz - Actividad 49
# Medir el tiempo de ejecución de una función
# Alumno: Gómez Aguilar Jared Emmanuel  
# Número de Control: 22210309  
# Python y Ensamblador
# Operaciones con temporizadores

# --------------------------------------------
/*
import time

def measure_execution_time(func, *args):
    start_time = time.time()
    func(*args)
    end_time = time.time()
    return end_time - start_time
*/
# ------------------------------------------

.arch armv8-a
    .global _start

    .section ".data"
    msg_start:    .ascii "Iniciando medicion de tiempo...\n"
    len_start    = . - msg_start
    
    msg_end:      .ascii "Funcion ejecutada.\n"
    len_end      = . - msg_end
    
    msg_time:     .ascii "Tiempo de ejecucion: "
    len_time     = . - msg_time
    
    msg_ms:       .ascii " microsegundos\n"
    len_ms       = . - msg_ms
    
    timespec_start:
        .quad 0   // tv_sec
        .quad 0   // tv_nsec
        
    timespec_end:
        .quad 0   // tv_sec
        .quad 0   // tv_nsec
        
    buffer:       .skip 32
    iterations:   .quad 1000000    // Número de iteraciones

    .section ".text"
    .align 2
_start:
    // Imprimir mensaje de inicio
    mov     x0, #1
    ldr     x1, =msg_start
    mov     x2, #len_start
    mov     x8, #64
    svc     #0

    // Obtener tiempo inicial
    mov     x0, #1              // CLOCK_MONOTONIC = 1
    ldr     x1, =timespec_start
    mov     x8, #113           // syscall clock_gettime
    svc     #0

    // Ejecutar la función a medir
    bl      funcion_a_medir

    // Obtener tiempo final
    mov     x0, #1
    ldr     x1, =timespec_end
    mov     x8, #113
    svc     #0

    // Imprimir mensaje de fin
    mov     x0, #1
    ldr     x1, =msg_end
    mov     x2, #len_end
    mov     x8, #64
    svc     #0

    // Calcular diferencia de tiempo
    bl      calcular_tiempo

    // Imprimir mensaje de tiempo
    mov     x0, #1
    ldr     x1, =msg_time
    mov     x2, #len_time
    mov     x8, #64
    svc     #0

    // Convertir tiempo a string
    mov     x0, x19            // x19 contiene el tiempo en microsegundos
    ldr     x1, =buffer
    bl      num_to_str

    // Imprimir tiempo
    mov     x0, #1
    ldr     x1, =buffer
    mov     x2, #32
    mov     x8, #64
    svc     #0

    // Imprimir unidad de medida
    mov     x0, #1
    ldr     x1, =msg_ms
    mov     x2, #len_ms
    mov     x8, #64
    svc     #0

    // Salir
    mov     x8, #93
    mov     x0, #0
    svc     #0

// Función ejemplo a medir
funcion_a_medir:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp
    
    mov     x0, #0              // Contador
    ldr     x1, =iterations
    ldr     x1, [x1]           // Cargar número de iteraciones
loop:
    add     x0, x0, #1
    cmp     x0, x1
    b.lt    loop
    
    ldp     x29, x30, [sp], #16
    ret

// Función para calcular la diferencia de tiempo
calcular_tiempo:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

    // Cargar tiempos
    ldr     x0, =timespec_start
    ldr     x1, [x0]        // segundos inicio
    ldr     x2, [x0, #8]    // nanosegundos inicio
    
    ldr     x0, =timespec_end
    ldr     x3, [x0]        // segundos fin
    ldr     x4, [x0, #8]    // nanosegundos fin

    // Calcular diferencia
    sub     x3, x3, x1      // diferencia segundos

    // Convertir segundos a microsegundos (x1000000)
    movz    x5, #0xF424
    movk    x5, #0x000F, lsl #16
    mul     x3, x3, x5
    
    sub     x4, x4, x2      // diferencia nanosegundos
    
    // Convertir nanosegundos a microsegundos (dividir por 1000)
    mov     x5, #1000
    udiv    x4, x4, x5
    
    add     x19, x3, x4     // tiempo total en microsegundos

    ldp     x29, x30, [sp], #16
    ret

// Función para convertir número a string
num_to_str:
    mov     x2, #0          // contador de dígitos
    mov     x3, #10         // divisor

convert_loop:
    udiv    x4, x0, x3      // dividir por 10
    msub    x5, x4, x3, x0  // obtener resto
    add     x5, x5, #'0'    // convertir a ASCII
    strb    w5, [x1, x2]    // guardar dígito
    add     x2, x2, #1      // incrementar contador
    mov     x0, x4          // actualizar número
    cbnz    x0, convert_loop

    // Agregar null terminator
    strb    wzr, [x1, x2]

    // Invertir string
    sub     x2, x2, #1      // último índice
    mov     x3, #0          // primer índice
reverse:
    cmp     x3, x2
    b.ge    done_reverse
    ldrb    w4, [x1, x3]    // cargar primer carácter
    ldrb    w5, [x1, x2]    // cargar último carácter
    strb    w5, [x1, x3]    // intercambiar
    strb    w4, [x1, x2]
    add     x3, x3, #1
    sub     x2, x2, #1
    b       reverse

done_reverse:
    ret
