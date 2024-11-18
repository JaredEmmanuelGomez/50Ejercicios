# Lenguajes de Interfaz - Actividad 39
# Invertir los elementos de un arreglo
# Alumno: Gómez Aguilar Jared Emmanuel  
# Número de Control: 22210309  
# Python y Ensamblador
# Manipulación de arreglos

# ---------------------------
/*
def reverse_array(arr):
    return arr[::-1]
*/
# ---------------------------

// Gómez Aguilar Jared Emmanuel
// 22210309
.global reverse_array
.text

// x0: puntero al arreglo
// x1: tamaño del arreglo
reverse_array:
    mov x2, #0          // índice inicio
    sub x3, x1, #1      // índice final
    
reverse_loop:
    cmp x2, x3
    bge reverse_end
    
    // Intercambiar elementos
    ldr x4, [x0, x2, lsl #3]    // cargar elemento inicio
    ldr x5, [x0, x3, lsl #3]    // cargar elemento final
    str x5, [x0, x2, lsl #3]    // guardar elemento final en inicio
    str x4, [x0, x3, lsl #3]    // guardar elemento inicio en final
    
    add x2, x2, #1      // incrementar índice inicio
    sub x3, x3, #1      // decrementar índice final
    b reverse_loop
    
reverse_end:
    ret
