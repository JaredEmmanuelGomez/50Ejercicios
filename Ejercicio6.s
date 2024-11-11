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
    // Mensajes y formatos
    prompt: .asciz "Ingrese un número: "
    result: .asciz "El número convertido es: %d\n"
    error_msg: .asciz "Error: Solo se permiten dígitos.\n"
    formato_scan: .asciz "%s"
    
    //Almacenar la entrada
    .align 4
    buffer: .skip 6     // 5 dígitos + null terminator
    
.text
.global main
.extern printf
.extern scanf

main:
    // Prólogo
    stp x29, x30, [sp, -16]!
    mov x29, sp
    
    // Mostrar prompt
    adrp x0, prompt
    add x0, x0, :lo12:prompt
    bl printf
    
    // Leer entrada
    adrp x0, formato_scan
    add x0, x0, :lo12:formato_scan
    adrp x1, buffer
    add x1, x1, :lo12:buffer
    bl scanf
    
    // Inicializar resultado
    mov x19, #0      // x19 será nuestro resultado
    
    // Preparar para procesar la cadena
    adrp x20, buffer
    add x20, x20, :lo12:buffer
    
proceso_loop:
    // Cargar byte actual
    ldrb w21, [x20]
    
    // Verificar si es fin de cadena
    cmp w21, #0
    beq fin_conversion
    
    // Verificar si es dígito (ASCII 48-57)
    cmp w21, #48
    blt error
    cmp w21, #57
    bgt error
    
    // Convertir ASCII a dígito
    sub w21, w21, #48
    
    // Multiplicar resultado actual por 10 y sumar nuevo dígito
    mov x22, #10
    mul x19, x19, x22
    add x19, x19, x21
    
    // Avanzar al siguiente carácter
    add x20, x20, #1
    b proceso_loop
    
error:
    
    adrp x0, error_msg
    add x0, x0, :lo12:error_msg
    bl printf
    mov w0, #1
    b fin
    
fin_conversion:
    
    adrp x0, result
    add x0, x0, :lo12:result
    mov x1, x19
    bl printf
    
    mov w0, #0
    
fin:
    ldp x29, x30, [sp], #16
    ret

ASCIINEMA 
https://asciinema.org/a/688672
