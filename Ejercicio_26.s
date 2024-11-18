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
.data
    input_size: .asciz "Enter array size: "
    input_num: .asciz "Enter number %d: "
    output_msg: .asciz "Sorted array: "
    scan_format: .asciz "%d"
    print_format: .asciz "%d "
    newline: .asciz "\n"

.bss
    .align 4
    array: .skip 400    // Space for up to 100 integers
    size: .skip 4       // Variable to store array size

.text
.global main
main:
    // Save link register
    str lr, [sp, -16]!

    // Print prompt for array size
    adrp x0, input_size
    add x0, x0, :lo12:input_size
    bl printf

    // Read array size
    adrp x0, scan_format
    add x0, x0, :lo12:scan_format
    adrp x1, size
    add x1, x1, :lo12:size
    bl scanf

    // Initialize counter for array input
    mov w21, #0

input_loop:
    // Check if we've input all numbers
    adrp x0, size
    add x0, x0, :lo12:size
    ldr w1, [x0]
    cmp w21, w1
    b.ge selection_sort

    // Print prompt for number
    adrp x0, input_num
    add x0, x0, :lo12:input_num
    mov w1, w21
    bl printf

    // Read number
    adrp x0, scan_format
    add x0, x0, :lo12:scan_format
    adrp x1, array
    add x1, x1, :lo12:array
    add x1, x1, w21, lsl #2
    bl scanf

    // Increment counter
    add w21, w21, #1
    b input_loop

selection_sort:
    // Initialize outer loop counter
    mov w21, #0        // i = 0

outer_loop:
    // Check outer loop condition
    adrp x0, size
    add x0, x0, :lo12:size
    ldr w1, [x0]
    sub w1, w1, #1
    cmp w21, w1
    b.ge print_array

    // Initialize min_idx
    mov w22, w21       // min_idx = i
    add w23, w21, #1   // j = i + 1

find_min:
    // Check inner loop condition
    adrp x0, size
    add x0, x0, :lo12:size
    ldr w1, [x0]
    cmp w23, w1
    b.ge swap_min

    // Compare array[j] with array[min_idx]
    adrp x0, array
    add x0, x0, :lo12:array
    ldr w24, [x0, w23, sxtw #2]    // array[j]
    ldr w25, [x0, w22, sxtw #2]    // array[min_idx]
    
    cmp w24, w25
    b.ge next_j
    mov w22, w23       // Update min_idx

next_j:
    add w23, w23, #1
    b find_min

swap_min:
    // Check if swap needed
    cmp w22, w21
    b.eq next_i

    // Perform swap
    adrp x0, array
    add x0, x0, :lo12:array
    ldr w23, [x0, w21, sxtw #2]    // temp = array[i]
    ldr w24, [x0, w22, sxtw #2]    // array[min_idx]
    str w24, [x0, w21, sxtw #2]    // array[i] = array[min_idx]
    str w23, [x0, w22, sxtw #2]    // array[min_idx] = temp

next_i:
    add w21, w21, #1
    b outer_loop

print_array:
    // Print sorted array message
    adrp x0, output_msg
    add x0, x0, :lo12:output_msg
    bl printf

    // Initialize print counter
    mov w21, #0

print_loop:
    // Check print condition
    adrp x0, size
    add x0, x0, :lo12:size
    ldr w1, [x0]
    cmp w21, w1
    b.ge print_newline

    // Print number
    adrp x0, print_format
    add x0, x0, :lo12:print_format
    adrp x2, array
    add x2, x2, :lo12:array
    ldr w1, [x2, w21, sxtw #2]
    bl printf

    add w21, w21, #1
    b print_loop

print_newline:
    adrp x0, newline
    add x0, x0, :lo12:newline
    bl printf

    // Restore link register and return
    ldr lr, [sp], #16
    mov w0, #0
    ret
