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
prompt:     .string "Introduce un número entero: "
format_in:  .string "%d"
format_out: .string "El carácter ASCII correspondiente es: %c\n"
err_msg:    .string "Error: El número debe estar en el rango de 0 a 127.\n"

        .text
        .global main
        .type main, %function

main:
        stp     x29, x30, [sp, -16]!    // Guardar frame pointer y link register
        mov     x29, sp                  // Set up frame pointer

        // Imprimir prompt
        adr     x0, prompt
        bl      printf

        // Leer número
        sub     sp, sp, #4              // Espacio para el número
        mov     x1, sp                  // Dirección donde guardar input
        adr     x0, format_in
        bl      scanf

        // Verificar rango
        ldr     w1, [sp]                // Cargar número
        cmp     w1, #0                  // Comparar con 0
        blt     range_error
        cmp     w1, #127                // Comparar con 127
        bgt     range_error

        // Imprimir resultado
        adr     x0, format_out
        bl      printf
        b       end

range_error:
        adr     x0, err_msg
        bl      printf

end:
        mov     w0, #0                  // Return 0
        ldp     x29, x30, [sp], #16     // Restaurar frame pointer y link register
        ret

        .size main, (. - main)
