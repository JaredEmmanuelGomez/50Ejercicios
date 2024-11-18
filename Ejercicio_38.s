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
.global power
.text

// x0: base x
// x1: exponente n
power:
    mov x2, #1          // resultado
    
power_loop:
    cbz x1, power_end   // si exponente es 0, terminar
    mul x2, x2, x0      // multiplicar resultado por base
    sub x1, x1, #1      // decrementar exponente
    b power_loop
    
power_end:
    mov x0, x2          // mover resultado al registro de retorno
    ret
