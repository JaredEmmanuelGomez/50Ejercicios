# Lenguajes de Interfaz - Actividad 36
# Máximo Común Divisor (MCD)
# Alumno: Gómez Aguilar Jared Emmanuel  
# Número de Control: 22210309  
# Python y Ensamblador
# Aritmética, algoritmo de Euclides

# ---------------------------
/*
def gcd(a, b):
    while b:
        a, b = b, a % b
    return a
*/
# ---------------------------

// Gómez Aguilar Jared Emmanuel
// 22210309
.global gcd
.text

// x0: número a
// x1: número b
gcd:
    // Si b es 0, retornar a
    cbz x1, gcd_end
    
    // Guardar b
    mov x2, x1
    
    // Calcular a % b
    udiv x3, x0, x1     // x3 = a / b
    mul x3, x3, x1      // x3 = (a / b) * b
    sub x1, x0, x3      // x1 = a - (a / b) * b (resto)
    
    // Preparar siguiente iteración
    mov x0, x2          // a = b
    b gcd               // recursión
    
gcd_end:
    ret
