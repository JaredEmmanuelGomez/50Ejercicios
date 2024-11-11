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
prompt:     .string "Introduce un carácter: "
format_in:  .string "%c"
format_out: .string "El valor ASCII del carácter es: %d\n"
err_msg:    .string "Error: Debes ingresar solo un carácter.\n"

        .text
        .global main
        .type main, %function

main:
        stp     x29, x30, [sp, -16]!    // Guardar frame pointer y link register
        mov     x29, sp                  // Set up frame pointer

        // Imprimir prompt
        adr     x0, prompt
        bl      printf

        // Leer carácter
        sub     sp, sp, #4              // Espacio para el carácter
        mov     x1, sp                  // Dirección donde guardar input
        adr     x0, format_in
        bl      scanf

        // Cargar carácter y convertir a valor ASCII
        ldrb    w1, [sp]                // Cargar el carácter en w1

        // Imprimir resultado
        adr     x0, format_out
        bl      printf

        mov     w0, #0                  // Return 0
        ldp     x29, x30, [sp], #16     // Restaurar frame pointer y link register
        ret

        .size main, (. - main)
