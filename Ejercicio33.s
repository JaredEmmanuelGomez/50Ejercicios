# Lenguajes de Interfaz - Actividad 33
# Desplazamientos a la izquierda y derecha
# Alumno: Gómez Aguilar Jared Emmanuel  
# Número de Control: 22210309  
# Python y Ensamblador
# Operaciones de desplazamiento

# ----------------------------
/*
def bit_shifts(n, shift):
    return n << shift, n >> shift
*/
# ----------------------------

// Gómez Aguilar Jared Emmanuel
// 22210309
.global bit_shifts
.text

// x0: número n
// x1: cantidad de desplazamiento (shift)
// Retorna en x0 el desplazamiento a la izquierda
// Retorna en x1 el desplazamiento a la derecha
bit_shifts:
    // Guardar el número original
    mov x2, x0
    
    // Realizar desplazamiento a la izquierda
    lsl x0, x0, x1
    
    // Realizar desplazamiento a la derecha usando el número original
    lsr x1, x2, x1
    
    ret
