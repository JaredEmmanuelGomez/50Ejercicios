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
    temp: .skip 400     // Temporary array for merging
    size: .skip 4       // Variable to store array size

.text
.global main
main:
    // Save registers
    stp x29, x30, [sp, -16]!
    mov x29, sp

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
    b.ge start_sort

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

start_sort:
    // Call mergesort with initial parameters
    mov w0, #0              // left = 0
    adrp x1, size
    add x1, x1, :lo12:size
    ldr w1, [x1]
    sub w1, w1, #1         // right = size - 1
    bl mergesort

    // Print sorted array
    adrp x0, output_msg
    add x0, x0, :lo12:output_msg
    bl printf

    mov w21, #0            // Initialize print counter

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

    // Restore registers and return
    ldp x29, x30, [sp], #16
    mov w0, #0
    ret

// Merge sort function
mergesort:
    // Save registers
    stp x29, x30, [sp, -32]!
    stp x19, x20, [sp, #16]
    mov x29, sp

    // Save parameters
    mov w19, w0            // left
    mov w20, w1            // right

    // Check if more than one element
    cmp w19, w20
    b.ge mergesort_end

    // Calculate middle point
    add w21, w19, w20
    lsr w21, w21, #1       // mid = (left + right)/2

    // Sort left half
    mov w0, w19
    mov w1, w21
    bl mergesort

    // Sort right half
    add w0, w21, #1
    mov w1, w20
    bl mergesort

    // Merge the sorted halves
    mov w0, w19            // left
    mov w1, w21            // mid
    mov w2, w20            // right
    bl merge

mergesort_end:
    // Restore registers and return
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #32
    ret

// Merge function
merge:
    // Save registers
    stp x29, x30, [sp, -48]!
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    mov x29, sp

    // Save parameters
    mov w19, w0            // left
    mov w20, w1            // mid
    mov w21, w2            // right

    // Copy to temp array
    mov w22, w19           // i = left
copy_loop:
    cmp w22, w21
    b.gt merge_arrays

    adrp x0, array
    add x0, x0, :lo12:array
    adrp x1, temp
    add x1, x1, :lo12:temp
    
    ldr w23, [x0, w22, sxtw #2]
    str w23, [x1, w22, sxtw #2]

    add w22, w22, #1
    b copy_loop

merge_arrays:
    mov w22, w19           // k = left
    mov w23, w19           // i = left
    add w24, w20, #1       // j = mid + 1

merge_loop:
    cmp w
