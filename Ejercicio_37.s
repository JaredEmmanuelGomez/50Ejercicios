# Lenguajes de Interfaz - Actividad 37
# Mínimo Común Múltiplo (MCM)
# Alumno: Gómez Aguilar Jared Emmanuel  
# Número de Control: 22210309  
# Python y Ensamblador
# Operaciones aritméticas

# -------------------------------------
/*
def lcm(a, b):
    return abs(a * b) // gcd(a, b)
*/
# --------------------------------------

// Gómez Aguilar Jared Emmanuel
// 22210309
.global lcm
.text

// x0: número a
// x1: número b
lcm:
    // Guardar registros
    stp x29, x30, [sp, #-16]!
    stp x19, x20, [sp, #-16]!
    
    // Guardar a y b
    mov x19, x0
    mov x20, x1
    
    // Calcular GCD
    bl gcd
    
    // Calcular |a * b|
    mul x2, x19, x20
    
    // Dividir |a * b| / gcd
    udiv x0, x2, x0
    
    // Restaurar registros y retornar
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret
