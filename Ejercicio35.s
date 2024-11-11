# Lenguajes de Interfaz - Actividad 35
# Contar los bits activados en un número
# Alumno: Gómez Aguilar Jared Emmanuel  
# Número de Control: 22210309  
# Python y Ensamblador
# Operaciones bit a bit

# ------------------------------
/*
def count_set_bits(n):
    return bin(n).count('1')
*/
# ------------------------------

// Gómez Aguilar Jared Emmanuel
// 22210309
.global count_set_bits
.text

// x0: número n
// Retorna en x0 la cantidad de bits activados
count_set_bits:
    mov x1, #0          // contador
    
count_loop:
    cbz x0, end_count   // si el número es 0, terminar
    and x2, x0, #1      // obtener último bit
    add x1, x1, x2      // sumar al contador si es 1
    lsr x0, x0, #1      // desplazar a la derecha
    b count_loop
    
end_count:
    mov x0, x1          // mover resultado al registro de retorno
    ret
