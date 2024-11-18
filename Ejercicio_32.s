# Lenguajes de Interfaz - Actividad 32
# Operaciones AND, OR, XOR a nivel de bits
# Alumno: Gómez Aguilar Jared Emmanuel  
# Número de Control: 22210309  
# Python y Ensamblador
# Operaciones a nivel de bits

# -----------------------------------
/*
def bitwise_operations(a, b):
    return a & b, a | b, a ^ b
*/
# -----------------------------------

// Gómez Aguilar Jared Emmanuek
// 22210309
// bit_operations.s
.global _start

.text
_start:
    mov x0, #42
    mov x1, #27
    bl bitwise_operations
    
    mov x8, #93
    mov x0, #0
    svc #0

bitwise_operations:
    // x0, x1: números a operar
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    
    // AND
    and x2, x0, x1
    
    // OR
    orr x3, x0, x1
    
    // XOR
    eor x4, x0, x1
    
    // NOT (complemento a uno)
    mvn x5, x0
    
    // Desplazamiento izquierda
    lsl x6, x0, #2
    
    // Desplazamiento derecha
    lsr x7, x0, #2
    
    // Desplazamiento aritmético derecha
    asr x8, x0, #2
    
    // Rotación derecha
    ror x9, x0, #2
    
    ldp x29, x30, [sp], #16
    ret

count_set_bits:
    // x0: número a contar bits
    mov x1, #0              // contador
    
count_loop:
    cbz x0, count_end      // Si el número es 0, terminar
    
    // Técnica de Brian Kernighan
    sub x2, x0, #1         // n-1
    and x0, x0, x2         // n = n & (n-1)
    add x1, x1, #1         // incrementar contador
    b count_loop
    
count_end:
    mov x0, x1             // retornar contador
    ret

set_bit:
    // x0: número
    // x1: posición
    mov x2, #1
    lsl x2, x2, x1
    orr x0, x0, x2
    ret

clear_bit:
    // x0: número
    // x1: posición
    mov x2, #1
    lsl x2, x2, x1
    mvn x2, x2
    and x0, x0, x2
    ret

toggle_bit:
    // x0: número
    // x1: posición
    mov x2, #1
    lsl x2, x2, x1
    eor x0, x0, x2
    ret
