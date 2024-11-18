# Lenguajes de Interfaz - Actividad 6
# Conversión de ASCII a entero
# Alumno: Gómez Aguilar Jared Emmanuel  
# Número de Control: 22210309  
# Python y Ensamblador

# ------------------------------------------------------------------------
/*
# Función para convertir un carácter a su valor ASCII
def ascii_a_entero(caracter):
    if len(caracter) == 1:  # Asegurarse de que sea un solo carácter
        return ord(caracter)
    else:
        return "Error: Debes ingresar solo un carácter."

# Solicitar un carácter al usuario
caracter = input("Introduce un carácter: ")

# Llamar a la función y mostrar el valor ASCII
resultado = ascii_a_entero(caracter)
print("El valor ASCII del carácter es:", resultado)
*/
# --------------------------------------------------------------------------



//Gómez Aguilar Jared Emmanuel
//22210309
.data
    prompt:     .asciz "Enter a number as string: "
    scanfmt:    .asciz "%s"
    outfmt:     .asciz "Result: %d\n"
    buffer:     .skip 100       // Buffer for input

.text
    .global main
    .align 2

main:
    stp     x29, x30, [sp, -16]!    // Save frame pointer and link register
    mov     x29, sp                  // Set up frame pointer

    // Print prompt
    adrp    x0, prompt
    add     x0, x0, :lo12:prompt
    bl      printf

    // Read input
    adrp    x0, scanfmt
    add     x0, x0, :lo12:scanfmt
    adrp    x1, buffer
    add     x1, x1, :lo12:buffer
    bl      scanf

    // Initialize registers
    mov     x19, #0                  // Result
    adrp    x20, buffer             // Load input string address
    add     x20, x20, :lo12:buffer
    
convert_loop:
    ldrb    w21, [x20], #1          // Load byte and increment pointer
    cbz     w21, done               // If null terminator, exit loop
    
    sub     w21, w21, #'0'          // Convert ASCII to number
    cmp     w21, #9                 // Check if valid digit
    b.hi    done
    
    mov     x22, #10
    mul     x19, x19, x22           // result = result * 10
    add     x19, x19, x21           // result = result + digit
    b       convert_loop

done:
    // Print result
    adrp    x0, outfmt
    add     x0, x0, :lo12:outfmt
    mov     x1, x19
    bl      printf

    // Exit
    mov     w0, #0
    ldp     x29, x30, [sp], #16
    ret

.size main, .-main


ASCIINEMA 
https://asciinema.org/a/690320
