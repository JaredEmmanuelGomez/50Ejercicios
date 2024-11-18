# Lenguajes de Interfaz - Actividad 7
# Conversión de entero a ASCII
# Alumno: Gómez Aguilar Jared Emmanuel  
# Número de Control: 22210309  
# Python y Ensamblador

# ----------------------------------------------------------------------------------------
/*
# Función para convertir un número entero a su carácter ASCII
def entero_a_ascii(numero):
    try:
        # Verificar si el número está en el rango válido de caracteres ASCII (0-127)
        if 0 <= numero <= 127:
            return chr(numero)
        else:
            return "Error: El número debe estar en el rango de 0 a 127."
    except TypeError:
        return "Error: Debes ingresar un valor numérico."

# Solicitar un número entero al usuario
numero = int(input("Introduce un número entero: "))

# Llamar a la función y mostrar el resultado
resultado = entero_a_ascii(numero)
print("El carácter ASCII correspondiente es:", resultado)
*/
# --------------------------------------------------------------------------------------------


//Gómez Aguilar Jared Emmanuel
//22210309
.data
    prompt:     .asciz "Enter an integer: "
    scanfmt:    .asciz "%ld"
    outfmt:     .asciz "Result: %s\n"
    number:     .quad 0              // Storage for input number
    buffer:     .skip 20            // Buffer for ASCII result

.text
    .global main
    .align 2

main:
    stp     x29, x30, [sp, -16]!
    mov     x29, sp

    // Print prompt
    adrp    x0, prompt
    add     x0, x0, :lo12:prompt
    bl      printf

    // Read input
    adrp    x0, scanfmt
    add     x0, x0, :lo12:scanfmt
    adrp    x1, number
    add     x1, x1, :lo12:number
    bl      scanf

    // Load number and initialize buffer pointer
    adrp    x19, number
    add     x19, x19, :lo12:number
    ldr     x19, [x19]            // Number to convert
    
    adrp    x20, buffer
    add     x20, x20, :lo12:buffer
    add     x20, x20, #19         // Start from end of buffer
    mov     w21, #0
    strb    w21, [x20]            // Null terminator
    sub     x20, x20, #1          // Move pointer back

convert_loop:
    mov     x21, #10
    udiv    x22, x19, x21         // Divide by 10
    msub    x23, x22, x21, x19    // Get remainder
    add     w23, w23, #'0'        // Convert to ASCII
    strb    w23, [x20], #-1       // Store digit and move pointer back
    mov     x19, x22              // Update number
    cbnz    x19, convert_loop     // Continue if number not zero

    // Print result
    adrp    x0, outfmt
    add     x0, x0, :lo12:outfmt
    add     x1, x20, #1           // Point to start of string
    bl      printf

    // Exit
    mov     w0, #0
    ldp     x29, x30, [sp], #16
    ret

.size main, .-main
    ret

ASCIINEMA
https://asciinema.org/a/688658
