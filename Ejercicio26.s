# Lenguajes de Interfaz - Actividad 26
# Ordenamiento por selección
# Alumno: Gómez Aguilar Jared Emmanuel  
# Número de Control: 22210309  
# Python y Ensamblador
# Algoritmos de ordenamiento

# ---------------------------------------------
/*
def selection_sort(arr):
    for i in range(len(arr)):
        min_idx = i
        for j in range(i + 1, len(arr)):
            if arr[j] < arr[min_idx]:
                min_idx = j
        arr[i], arr[min_idx] = arr[min_idx], arr[i]

*/
# ----------------------------------------------

// Gómez Aguilar Jared Emmanuel
// 22210309
// selection_sort.s
.global _start

.data
    array:      .quad   64, 25, 12, 22, 11, 1, 90    // Array a ordenar
    array_size: .quad   7                            // Tamaño del array
    
.text
_start:
    ldr x0, =array
    ldr x1, =array_size
    ldr x1, [x1]
    bl selection_sort
    
    mov x8, #93    // exit syscall
    mov x0, #0
    svc #0

selection_sort:
    // x0: dirección base del array
    // x1: tamaño del array
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    
    mov x2, #0                  // i = 0
    
outer_loop:
    cmp x2, x1                  // i < size?
    b.ge sort_end
    
    mov x3, x2                  // min_idx = i
    add x4, x2, #1             // j = i + 1
    
inner_loop:
    cmp x4, x1                  // j < size?
    b.ge swap_elements
    
    // Comparar arr[j] con arr[min_idx]
    ldr x5, [x0, x4, lsl #3]    // x5 = arr[j]
    ldr x6, [x0, x3, lsl #3]    // x6 = arr[min_idx]
    cmp x5, x6
    b.ge skip_update
    mov x3, x4                  // min_idx = j
    
skip_update:
    add x4, x4, #1             // j++
    b inner_loop
    
swap_elements:
    cmp x2, x3                  // i != min_idx?
    b.eq continue_outer
    
    // Intercambiar arr[i] y arr[min_idx]
    ldr x5, [x0, x2, lsl #3]
    ldr x6, [x0, x3, lsl #3]
    str x6, [x0, x2, lsl #3]
    str x5, [x0, x3, lsl #3]
    
continue_outer:
    add x2, x2, #1             // i++
    b outer_loop
    
sort_end:
    ldp x29, x30, [sp], #16
    ret
