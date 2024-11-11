# Lenguajes de Interfaz - Actividad 40
# Rotación de un arreglo (izquierda/derecha)
# Alumno: Gómez Aguilar Jared Emmanuel  
# Número de Control: 22210309  
# Python y Ensamblador
# Manipulación de arreglos

# -------------------------------------------
/*
def rotate_array(arr, k, direction="left"):
    k %= len(arr)
    if direction == "left":
        return arr[k:] + arr[:k]
    return arr[-k:] + arr[:-k]
*/
# ------------------------------------------

// Gómez Aguilar Jared Emmanuel
.global rotate_array
.text

// x0: puntero al arreglo
// x1: tamaño del arreglo
// x2: k posiciones
// x3: dirección (0=izquierda, 1=derecha)
rotate_array:
    // Ajustar k al tamaño del arreglo
    udiv x4, x2, x1
    mul x4, x4, x1
    sub x2, x2, x4
    
    // Si k es 0, no hay que rotar
    cbz x2, rotate_end
    
    // Ajustar dirección
    cmp x3, #0
    beq rotate_left
    
rotate_right:
    sub x2, x1, x2      // convertir rotación derecha a izquierda
    
rotate_left:
    // Crear buffer temporal en el stack
    sub sp, sp, x1, lsl #3
    
    // Copiar elementos al buffer temporal
    mov x4, #0          // índice
copy_loop:
    cmp x4, x1
    beq copy_done
    ldr x5, [x0, x4, lsl #3]
    str x5, [sp, x4, lsl #3]
    add x4, x4, #1
    b copy_loop
    
copy_done:
    // Copiar elementos rotados de vuelta al arreglo
    mov x4, #0          // índice destino
rotate_copy_loop:
    cmp x4, x1
    beq rotate_copy_done
    add x5, x4, x2      // índice fuente = (destino + k) % tamaño
    udiv x6, x5, x1
    mul x6, x6, x1
    sub x5, x5, x6
    ldr x6, [sp, x5, lsl #3]
    str x6, [x0, x4, lsl #3]
    add x4, x4, #1
    b rotate_copy_loop
    
rotate_copy_done:
    add sp, sp, x1, lsl #3
    
rotate_end:
    ret
