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
.global main
.data
    // Mensajes y buffers
    msg_input: .string "Ingrese el número entero: "
    msg_output: .string "El número en el sistema ASCII es: "
    input_format: .string "%ld"
    newline: .string "\n"
    buffer: .skip 20    // Buffer para almacenar los dígitos ASCII

.text
main:
    // Prólogo
    stp     x29, x30, [sp, -32]!
    mov     x29, sp

    // Imprimir mensaje de entrada
    adr     x0, msg_input
    bl      printf

    // Leer número entero
    sub     sp, sp, 16          // Espacio para variable local
    mov     x2, sp              // Dirección para almacenar el número
    adr     x0, input_format
    mov     x1, x2
    bl      scanf

    // Cargar el número ingresado
    ldr     x19, [sp]           // x19 = número ingresado
    
    // Preparar para la conversión
    adr     x20, buffer         // x20 = dirección del buffer
    mov     x21, 10             // x21 = divisor (10)
    mov     x22, 0              // x22 = contador de dígitos

convert_loop:
    // Dividir el número por 10
    udiv    x23, x19, x21       // x23 = cociente
    msub    x24, x23, x21, x19  // x24 = residuo
    
    // Convertir dígito a ASCII
    add     x24, x24, '0'       // Convertir a ASCII
    strb    w24, [x20, x22]     // Almacenar en buffer
    add     x22, x22, 1         // Incrementar contador
    
    // Actualizar número para siguiente iteración
    mov     x19, x23            // Número = cociente
    
    // Continuar si el número no es cero
    cbnz    x19, convert_loop

    // Imprimir mensaje de salida
    adr     x0, msg_output
    bl      printf

    // Imprimir dígitos en orden inverso
print_loop:
    sub     x22, x22, 1         // Decrementar contador
    ldrb    w0, [x20, x22]      // Cargar dígito
    bl      putchar             // Imprimir dígito
    cbnz    x22, print_loop     // Continuar si no hemos terminado

    // Imprimir nueva línea
    adr     x0, newline
    bl      printf

    // Epílogo y retorno
    mov     w0, 0
    ldp     x29, x30, [sp], 32
    ret
