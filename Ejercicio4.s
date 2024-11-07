# Lenguajes de Interfaz - Actividad 4
# Multiplicación de dos números, Aritmética básica (MUL)
# Alumno: Gómez Aguilar Jared Emmanuel  
# Número de Control: 22210309  
# Python y Ensamblador


/*
# Programa para multiplicar dos números en Python
# Solicita al usuario los dos números
try:
    num1 = float(input("Ingrese el primer número: "))
    num2 = float(input("Ingrese el segundo número: "))
    
    # Calcula la multiplicación
    multiplicacion = num1 * num2
    
    # Muestra el resultado
    print(f"La multiplicación de {num1} por {num2} es: {multiplicacion}")
except ValueError:
    print("Por favor, ingrese valores numéricos válidos.")

*/


//Gómez Aguilar Jared Emmanuel
//22210309
.data
prompt1:    .string "Ingrese el primer número: "
prompt2:    .string "Ingrese el segundo número: "
format_in:  .string "%lf"
format_out: .string "La multiplicación de %f por %f es: %f\n"

        .text
        .global main
        .type main, %function

main:
        stp     x29, x30, [sp, -32]!    // Guardar frame pointer y link register
        mov     x29, sp                  // Set up frame pointer

        // Imprimir primer prompt
        adr     x0, prompt1
        bl      printf

        // Leer primer número
        add     x1, sp, #16             // Dirección para primer número
        adr     x0, format_in
        bl      scanf

        // Imprimir segundo prompt
        adr     x0, prompt2
        bl      printf

        // Leer segundo número
        add     x1, sp, #24             // Dirección para segundo número
        adr     x0, format_in
        bl      scanf

        // Cargar números y multiplicar
        ldr     d0, [sp, #16]           // Cargar primer número
        ldr     d1, [sp, #24]           // Cargar segundo número
        fmul    d2, d0, d1              // Multiplicar

        // Imprimir resultado
        adr     x0, format_out
        fmov    d0, d0                  // Primer número para printf
        fmov    d1, d1                  // Segundo número para printf
        fmov    d2, d2                  // Resultado para printf
        bl      printf

        mov     w0, #0                  // Return 0
        ldp     x29, x30, [sp], #32     // Restaurar frame pointer y link register
        ret

        .size main, (. - main)


ASCIINEMA 
https://asciinema.org/a/687662
