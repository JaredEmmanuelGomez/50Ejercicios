# Lenguajes de Interfaz - Actividad 25
# Ordenamiento burbuja
# Alumno: Gómez Aguilar Jared Emmanuel  
# Número de Control: 22210309  
# Python y Ensamblador
# Algoritmos de ordenamiento

# -------------------------------------------------------
/*
def bubble_sort(arr):
    n = len(arr)
    for i in range(n):
        for j in range(0, n - i - 1):
            if arr[j] > arr[j + 1]:
                arr[j], arr[j + 1] = arr[j + 1], arr[j]
*/
# -------------------------------------------------------


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
    b.ge bubble_sort

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

bubble_sort:
    // Initialize outer loop counter
    adrp x0, size
    add x0, x0, :lo12:size
    ldr w21, [x0]       // n = size
    sub w21, w21, #1    // n-1 for outer loop

outer_loop:
    // Check outer loop condition
    cmp w21, #0
    b.le print_array
    
    // Initialize inner loop counter
    mov w22, #0

inner_loop:
    // Check inner loop condition
    cmp w22, w21
    b.ge next_outer

    // Load array[j] and array[j+1]
    adrp x0, array
    add x0, x0, :lo12:array
    ldr w23, [x0, w22, sxtw #2]
    add x1, x0, #4
    ldr w24, [x0, w22, sxtw #2, lsl #1]

    // Compare and swap if needed
    cmp w23, w24
    b.le no_swap

    // Swap elements
    str w24, [x0, w22, sxtw #2]
    str w23, [x1, w22, sxtw #2]

no_swap:
    add w22, w22, #1
    b inner_loop

next_outer:
    sub w21, w21, #1
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
