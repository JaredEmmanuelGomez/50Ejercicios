# Lenguajes de Interfaz - Actividad 19
# Suma de elementos en un arreglo
# Alumno: Gómez Aguilar Jared Emmanuel  
# Número de Control: 22210309  
# Python y Ensamblador

# ---------------------------------------
/*
def suma_arreglo(arreglo):
    return sum(arreglo)
*/
# ---------------------------------------

// Gómez Aguilar Jared Emmanuel
// 22210309
.data
    prompt_size:    .asciz "Enter the number of elements in the array: "
    prompt_element: .asciz "Enter element #"
    buffer:         .skip   20
    array:          .skip   100     // Space for 25 integers (4 bytes each)
    result:         .skip   64
    colon:          .asciz ": "
    newline:        .asciz "\n"

.text
.global _start

_start:
    // Print prompt for array size
    mov     x0, #1
    adr     x1, prompt_size
    mov     x2, #44
    mov     x8, #64
    svc     #0

    // Read array size
    mov     x0, #0
    adr     x1, buffer
    mov     x2, #20
    mov     x8, #63
    svc     #0

    // Convert array size to integer
    adr     x1, buffer
    mov     x2, #0              // result
    mov     x3, #10             // multiplier
convert_size_loop:
    ldrb    w4, [x1]
    cmp     w4, #'\n'
    beq     convert_size_done
    sub     w4, w4, #'0'
    mul     x2, x2, x3
    add     x2, x2, x4
    add     x1, x1, #1
    b       convert_size_loop

convert_size_done:
    mov     x9, x2              // Save array size
    mov     x10, #0             // Array index
    adr     x11, array          // Array base address

    // Input array elements
input_loop:
    cmp     x10, x9
    bge     input_done

    // Print prompt for current element
    mov     x0, #1
    adr     x1, prompt_element
    mov     x2, #19
    mov     x8, #64
    svc     #0

    // Print element number
    adr     x1, buffer
    mov     x2, x10
    add     x2, x2, #1          // 1-based indexing
    bl      int_to_ascii
    mov     x0, #1
    adr     x1, buffer
    bl      print_string

    // Print colon
    mov     x0, #1
    adr     x1, colon
    mov     x2, #2
    mov     x8, #64
    svc     #0

    // Read element
    mov     x0, #0
    adr     x1, buffer
    mov     x2, #20
    mov     x8, #63
    svc     #0

    // Convert element to integer
    adr     x1, buffer
    mov     x2, #0              // result
    mov     x3, #10             // multiplier
convert_element_loop:
    ldrb    w4, [x1]
    cmp     w4, #'\n'
    beq     convert_element_done
    sub     w4, w4, #'0'
    mul     x2, x2, x3
    add     x2, x2, x4
    add     x1, x1, #1
    b       convert_element_loop

convert_element_done:
    // Store element in array
    str     x2, [x11, x10, lsl #3]  // 8-byte integers
    add     x10, x10, #1

    b       input_loop

input_done:
    // Calculate sum of array
    mov     x2, #0              // Sum
    mov     x10, #0             // Index
sum_loop:
    cmp     x10, x9
    bge     sum_done
    ldr     x3, [x11, x10, lsl #3]
    add     x2, x2, x3
    add     x10, x10, #1
    b       sum_loop

sum_done:
    // Convert sum to ASCII
    adr     x1, result
    mov     x3, #10             // Divisor
    mov     x4, #0              // Digit counter

convert_to_ascii:
    udiv    x5, x2, x3          // Divide by 10
    msub    x6, x5, x3, x2      // Get remainder
    add     x6, x6, #'0'        // Convert to ASCII
    strb    w6, [x1, x4]        // Store digit
    add     x4, x4, #1          // Increment counter
    mov     x2, x5              // Update number
    cbnz    x2, convert_to_ascii

    // Reverse the string
    mov     x5, #0              // Start index
    sub     x6, x4, #1          // End index
reverse_loop:
    cmp     x5, x6
    bhs     reverse_done
    ldrb    w7, [x1, x5]
    ldrb    w8, [x1, x6]
    strb    w8, [x1, x5]
    strb    w7, [x1, x6]
    add     x5, x5, #1
    sub     x6, x6, #1
    b       reverse_loop

reverse_done:
    // Add newline
    strb    w3, [x1, x4]
    mov     w3, #'\n'
    strb    w3, [x1, x4]

    // Print result
    mov     x0, #1              // stdout
    adr     x1, result
    add     x2, x4, #1          // Length including newline
    mov     x8, #64             // sys_write
    svc     #0

exit:
    mov     x0, #0              // return 0
    mov     x8, #93             // sys_exit
    svc     #0

// Helper function to convert integer to ASCII
int_to_ascii:
    adr     x1, buffer
    mov     x3, #10             // Divisor
    mov     x4, #0              // Digit counter

int_to_ascii_loop:
    udiv    x5, x2, x3          // Divide by 10
    msub    x6, x5, x3, x2      // Get remainder
    add     x6, x6, #'0'        // Convert to ASCII
    strb    w6, [x1, x4]        // Store digit
    add     x4, x4, #1          // Increment counter
    mov     x2, x5              // Update number
    cbnz    x2, int_to_ascii_loop

    // Reverse the string
    mov     x5, #0              // Start index
    sub     x6, x4, #1          // End index
int_to_ascii_reverse:
    cmp     x5, x6
    bhs     int_to_ascii_reverse_done
    ldrb    w7, [x1, x5]
    ldrb    w8, [x1, x6]
    strb    w8, [x1, x5]
    strb    w7, [x1, x6]
    add     x5, x5, #1
    sub     x6, x6, #1
    b       int_to_ascii_reverse

int_to_ascii_reverse_done:
    mov     x2, #0
    strb    w2, [x1, x4]
    ret

// Helper function to print string
print_string:
    mov     x8, #64             // sys_write
    svc     #0
    ret

ASCIINEMA
https://asciinema.org/a/688680
