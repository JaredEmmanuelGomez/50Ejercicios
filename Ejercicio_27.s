# Lenguajes de Interfaz - Actividad 27
# Ordenamiento por mezcla (Merge Sort)
# Alumno: Gómez Aguilar Jared Emmanuel  
# Número de Control: 22210309  
# Python y Ensamblador
# Recursión y manejo de memoria

# -------------------------------------------------------------------------------
/*
def merge_sort(arr):
    if len(arr) > 1:
        mid = len(arr) // 2
        L = arr[:mid]
        R = arr[mid:]
        merge_sort(L)
        merge_sort(R)
        i = j = k = 0
        while i < len(L) and j < len(R):
            if L[i] < R[j]:
                arr[k] = L[i]
                i += 1
            else:
                arr[k] = R[j]
                j += 1
            k += 1
        while i < len(L):
            arr[k] = L[i]
            i += 1
            k += 1
        while j < len(R):
            arr[k] = R[j]
            j += 1
            k += 1

*/
# ---------------------------------------------------------------------------------


// Gómez Aguilar Jared Emmanuel
// 22210309
// merge_sort.s
.global _start

.data
    array:       .quad   38, 27, 43, 3, 9, 82, 10    // Array a ordenar
    array_size:  .quad   7                           // Tamaño del array
    temp_array:  .quad   0, 0, 0, 0, 0, 0, 0        // Array temporal para mezcla
    
.text
_start:
    ldr x0, =array
    ldr x1, =array_size
    ldr x1, [x1]
    mov x2, #0              // left = 0
    sub x3, x1, #1         // right = size - 1
    bl merge_sort
    
    mov x8, #93            // exit syscall
    mov x0, #0
    svc #0

merge_sort:
    // x0: dirección base del array
    // x2: índice izquierdo
    // x3: índice derecho
    stp x29, x30, [sp, #-32]!
    stp x19, x20, [sp, #16]
    mov x29, sp
    
    // Verificar si hay más de un elemento
    cmp x2, x3
    b.ge merge_sort_end
    
    // Calcular punto medio
    add x19, x2, x3
    lsr x19, x19, #1       // mid = (left + right) / 2
    
    // Guardar parámetros
    mov x20, x0            // Guardar dirección base
    
    // Ordenar mitad izquierda
    mov x0, x20
    mov x3, x19           // right = mid
    bl merge_sort
    
    // Ordenar mitad derecha
    mov x0, x20
    mov x2, x19
    add x2, x2, #1        // left = mid + 1
    ldr x3, [sp, #8]      // Restaurar right original
    bl merge_sort
    
    // Mezclar las mitades ordenadas
    mov x0, x20
    ldr x2, [sp, #0]      // Restaurar left original
    mov x3, x19           // mid
    ldr x4, [sp, #8]      // right
    bl merge

merge_sort_end:
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #32
    ret

merge:
    // x0: dirección base del array
    // x2: left
    // x3: mid
    // x4: right
    stp x29, x30, [sp, #-48]!
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    mov x29, sp
    
    // Inicializar índices
    mov x19, x2           // i = left
    add x20, x3, #1      // j = mid + 1
    mov x21, x2          // k = left
    
    // Cargar dirección del array temporal
    ldr x22, =temp_array
    
merge_loop:
    cmp x19, x3          // i > mid?
    b.gt copy_right
    cmp x20, x4          // j > right?
    b.gt copy_left
    
    // Comparar elementos
    ldr x5, [x0, x19, lsl #3]
    ldr x6, [x0, x20, lsl #3]
    cmp x5, x6
    b.gt copy_right_element
    
    // Copiar elemento izquierdo
    str x5, [x22, x21, lsl #3]
    add x19, x19, #1
    add x21, x21, #1
    b merge_loop
    
copy_right_element:
    str x6, [x22, x21, lsl #3]
    add x20, x20, #1
    add x21, x21, #1
    b merge_loop
    
copy_left:
    cmp x19, x3
    b.gt merge_end
    ldr x5, [x0, x19, lsl #3]
    str x5, [x22, x21, lsl #3]
    add x19, x19, #1
    add x21, x21, #1
    b copy_left
    
copy_right:
    cmp x20, x4
    b.gt merge_end
    ldr x5, [x0, x20, lsl #3]
    str x5, [x22, x21, lsl #3]
    add x20, x20, #1
    add x21, x21, #1
    b copy_right
    
merge_end:
    // Copiar array temporal al original
    mov x19, x2          // i = left
copy_temp:
    cmp x19, x4
    b.gt merge_complete
    ldr x5, [x22, x19, lsl #3]
    str x5, [x0, x19, lsl #3]
    add x19, x19, #1
    b copy_temp
    
merge_complete:
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #48
    ret
