# Lenguajes de Interfaz - Actividad 34
# Establecer, borrar y alternar bits
# Alumno: Gómez Aguilar Jared Emmanuel  
# Número de Control: 22210309  
# Python y Ensamblador
# Manipulación de bits

# -----------------------------------------
/*
def set_clear_toggle_bits(n, pos, action):
    if action == "set":
        return n | (1 << pos)
    elif action == "clear":
        return n & ~(1 << pos)
    elif action == "toggle":
        return n ^ (1 << pos)
*/
# -------------------------------------------

// Gómez Aguilar Jared Emmanuel
// 22210309
.global set_clear_toggle_bits
.text

// x0: número n
// x1: posición pos
// x2: acción (1=set, 2=clear, 3=toggle)
set_clear_toggle_bits:
    // Crear máscara con 1 en la posición deseada
    mov x3, #1
    lsl x3, x3, x1
    
    cmp x2, #1
    beq set_bit
    cmp x2, #2
    beq clear_bit
    b toggle_bit

set_bit:
    orr x0, x0, x3
    ret

clear_bit:
    mvn x3, x3
    and x0, x0, x3
    ret

toggle_bit:
    eor x0, x0, x3
    ret
