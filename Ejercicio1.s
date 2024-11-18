# Lenguajes de Interfaz - Actividad 1
# Convertir temperatura de Celsius a Fahrenheit
# Alumno: Gómez Aguilar Jared Emmanuel  
# Número de Control: 22210309  
# Python y Ensamblador
# Conversión de unidades, I/O

# ----------------------------------------------
/*
# python programa 
# Programa para convertir temperatura de Celsius a Fahrenheit

# Solicita al usuario la temperatura en Celsius
try:
    celsius = float(input("Ingrese la temperatura en Celsius: "))
    fahrenheit = (celsius * 9 / 5) + 32
    print(f"La temperatura en Fahrenheit es: {fahrenheit:.2f}°F")
except ValueError:
    print("Por favor, ingrese un valor numérico válido.")
*/
# -----------------------------------------------

//Gómez Aguilar Jared Emmanuel
//22210309
.data
prompt1:    .string "Ingrese la temperatura en Celsius: "
format_in:  .string "%lf"
format_out: .string "La temperatura en Fahrenheit es: %.2f°F\n"
nine:       .double 9.0
five:       .double 5.0
thirty_two: .double 32.0

        .text
        .global main
        .type main, %function

main:
        stp     x29, x30, [sp, -16]!    // Guardar frame pointer y link register
        mov     x29, sp                  // Set up frame pointer

        // Imprimir prompt
        adr     x0, prompt1
        bl      printf

        // Leer temperatura en Celsius
        sub     sp, sp, #16             // Espacio para el double
        mov     x1, sp                  // Dirección donde guardar input
        adr     x0, format_in
        bl      scanf

        // Cargar valores para el cálculo
        ldr     d0, [sp]                // Cargar Celsius
        adr     x0, nine
        ldr     d1, [x0]                // Cargar 9.0
        fmul    d0, d0, d1              // Celsius * 9
        
        adr     x0, five
        ldr     d1, [x0]                // Cargar 5.0
        fdiv    d0, d0, d1              // (Celsius * 9) / 5
        
        adr     x0, thirty_two
        ldr     d1, [x0]                // Cargar 32.0
        fadd    d0, d0, d1              // ((Celsius * 9) / 5) + 32

        // Imprimir resultado
        adr     x0, format_out
        bl      printf

        mov     w0, #0                  // Return 0
        ldp     x29, x30, [sp], #16     // Restaurar frame pointer y link register
        ret

        .size main, (. - main)



ASCIINEMA
https://asciinema.org/a/690304
