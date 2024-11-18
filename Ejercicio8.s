# Lenguajes de Interfaz - Actividad 8
# Calcular la longitud de una cadena
# Alumno: Gómez Aguilar Jared Emmanuel  
# Número de Control: 22210309  
# Python y Ensamblador

# -------------------------------------------------
/*
# Función para calcular la longitud de una cadena
def calcular_longitud(cadena):
    return len(cadena)

# Solicitar una cadena al usuario
cadena = input("Introduce una cadena de texto: ")

# Calcular la longitud de la cadena
longitud = calcular_longitud(cadena)

# Mostrar el resultado
print("La longitud de la cadena es:", longitud)
*/
# ------------------------------------------------



//Gómez Aguilar Jared Emmanuel
//22210309
.data
prompt:     .string "Introduce una cadena de texto: "
format_in:  .string "%255s"             // Límite de 255 caracteres
format_out: .string "La longitud de la cadena es: %d\n"
buffer:     .space 256                  // Buffer para la cadena

        .text
        .global main
        .type main, %function

main:
        stp     x29, x30, [sp, -16]!    // Guardar frame pointer y link register
        mov     x29, sp                  // Set up frame pointer

        // Imprimir prompt
        adr     x0, prompt
        bl      printf

        // Leer cadena
        adr     x1, buffer              // Dirección del buffer
        adr     x0, format_in
        bl      scanf

        // Calcular longitud
        adr     x0, buffer
        bl      strlen                   // Llamar a strlen de la librería C

        // Guardar resultado
        mov     x1, x0                  // Mover longitud a x1 para printf

        // Imprimir resultado
        adr     x0, format_out
        bl      printf

        mov     w0, #0                  // Return 0
        ldp     x29, x30, [sp], #16     // Restaurar frame pointer y link register
        ret

        .size main, (. - main)


ASCIINEMA
https://asciinema.org/a/690312
