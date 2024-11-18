# Lenguajes de Interfaz - Actividad 24
# Búsqueda binaria
# Alumno: Gómez Aguilar Jared Emmanuel  
# Número de Control: 22210309  
# Python y Ensamblador
# Recursión y saltos

# ---------------------------------------
/*
def binary_search(arr, target):
    left, right = 0, len(arr) - 1
    while left <= right:
        mid = (left + right) // 2
        if arr[mid] == target:
            return mid
        elif arr[mid] < target:
            left = mid + 1
        else:
            right = mid - 1
    return -1

*/
# -------------------------------------

// Gómez Aguilar Jared Emmanuel
// 22210309
.data
    input_size: .asciz "Enter array size: "
    input_num: .asciz "Enter number %d: "
    search_prompt: .asciz "Enter number to search: "
    found_msg: .asciz "Number found at position %d\n"
    not_found_msg: .asciz "Number not found\n"
    scan_format: .asciz "%d"
    print_format: .asciz "%d "
    newline: .asciz "\n"

.bss
    .align 4
    array: .skip 400    // Space for up to 100 integers
    size: .skip 4       // Variable to store array size
    target: .skip 4     // Number to search for

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
    b.ge end_input

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

end_input:
    // Prompt for search number
    adrp x0, search_prompt
    add x0, x0, :lo12:search_prompt
    bl printf

    // Read search number
    adrp x0, scan_format
    add x0, x0, :lo12:scan_format
    adrp x1, target
    add x1, x1, :lo12:target
    bl scanf

    // Binary search initialization
    mov w21, #0          // left = 0
    adrp x0, size
    add x0, x0, :lo12:size
    ldr w22, [x0]       // right = size-1
    sub w22, w22, #1

search_loop:
    // Check if search is complete
    cmp w21, w22
    b.gt not_found

    // Calculate mid point
    add w23, w21, w22
    lsr w23, w23, #1    // mid = (left + right)/2

    // Load array[mid]
    adrp x0, array
    add x0, x0, :lo12:array
    ldr w24, [x0, w23, sxtw #2]

    // Load target
    adrp x0, target
    add x0, x0, :lo12:target
    ldr w25, [x0]

    // Compare
    cmp w24, w25
    b.eq found
    b.lt search_greater
    sub w22, w23, #1    // right = mid-1
    b search_loop

search_greater:
    add w21, w23, #1    // left = mid+1
    b search_loop

found:
    adrp x0, found_msg
    add x0, x0, :lo12:found_msg
    mov w1, w23
    bl printf
    b exit

not_found:
    adrp x0, not_found_msg
    add x0, x0, :lo12:not_found_msg
    bl printf

exit:
    // Restore link register and return
    ldr lr, [sp], #16
    mov w0, #0
    ret
