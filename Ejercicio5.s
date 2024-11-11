# Lenguajes de Interfaz - Actividad 5
# División de dos números, Aritmética (UDIV, SDIV)
# Alumno: Gómez Aguilar Jared Emmanuel  
# Número de Control: 22210309  
# Python y Ensamblador

# -----------------------------------------------------------------
/*
# Función para dividir dos números
def dividir_numeros(num1, num2):
    try:
        resultado = num1 / num2
        return resultado
    except ZeroDivisionError:
        return "Error: No se puede dividir por cero."

# Solicitar los números al usuario
numero1 = float(input("Introduce el primer número: "))
numero2 = float(input("Introduce el segundo número: "))

# Llamar a la función y mostrar el resultado
resultado = dividir_numeros(numero1, numero2)
print("El resultado de la división es:", resultado)
*/
# -----------------------------------------------------------------


//Gómez Aguilar Jared Emmanuel
//22210309
.data
prompt1:    .string "Introduce el primer número: "
prompt2:    .string "Introduce el segundo número: "
format_in:  .string "%lf"
format_out: .string "El resultado de la división es: %f\n"
err_msg:    .string "Error: No se puede dividir por cero.\n"
zero:       .double 0.0

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

        // Verificar división por cero
        ldr     d0, [sp, #24]           // Cargar segundo número
        adr     x0, zero
        ldr     d1, [x0]                // Cargar 0.0
        fcmp    d0, d1                  // Comparar con cero
        beq     division_error          // Si es cero, saltar a error

        // Realizar división
        ldr     d0, [sp, #16]           // Cargar primer número
        ldr     d1, [sp, #24]           // Cargar segundo número
        fdiv    d0, d0, d1              // Dividir

        // Imprimir resultado
        adr     x0, format_out
        bl      printf
        b       end

division_error:
        // Imprimir mensaje de error
        adr     x0, err_msg
        bl      printf

end:
        mov     w0, #0                  // Return 0
        ldp     x29, x30, [sp], #32     // Restaurar frame pointer y link register
        ret

        .size main, (. - main)
