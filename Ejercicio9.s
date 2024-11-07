# Leer una entrada desde el teclado
entrada = input("Introduce algo: ")

# Mostrar lo que el usuario ha introducido
print("Has introducido:", entrada)



//Gómez Aguilar Jared Emmanuel
//22210309
.data
prompt:     .string "Introduce algo: "
format_in:  .string "%255s"             // Límite de 255 caracteres
format_out: .string "Has introducido: %s\n"
buffer:     .space 256                  // Buffer para la entrada

        .text
        .global main
        .type main, %function

main:
        stp     x29, x30, [sp, -16]!    // Guardar frame pointer y link register
        mov     x29, sp                  // Set up frame pointer

        // Imprimir prompt
        adr     x0, prompt
        bl      printf

        // Leer entrada
        adr     x1, buffer              // Dirección del buffer
        adr     x0, format_in
        bl      scanf

        // Imprimir resultado
        adr     x0, format_out
        adr     x1, buffer              // Cargar dirección de la cadena
        bl      printf

        mov     w0, #0                  // Return 0
        ldp     x29, x30, [sp], #16     // Restaurar frame pointer y link register
        ret

        .size main, (. - main)
