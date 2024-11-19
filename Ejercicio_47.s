# Lenguajes de Interfaz - Actividad 47
# Encontrar prefijo común más largo en cadenas
# Alumno: Gómez Aguilar Jared Emmanuel  
# Número de Control: 22210309  
# Python y Ensamblador
# Comparación de cadenas

# -----------------------------------------------
/*
def longest_common_prefix(strs):
    if not strs:
        return ""
    prefix = strs[0]
    for s in strs[1:]:
        while not s.startswith(prefix):
            prefix = prefix[:-1]
    return prefix
*/
# -------------------------------------------------


.arch armv8-a
    .global _start

    .section ".data"
    msg_input:    .ascii "Cuantas cadenas va a ingresar?: "
    len_input    = . - msg_input
    
    msg_str:      .ascii "Ingrese cadena "
    len_msg_str  = . - msg_str
    
    msg_result:   .ascii "\nPrefijo comun mas largo: "
    len_result   = . - msg_result
    
    newline:      .ascii "\n"
    len_newline  = . - newline

    buffer:       .skip 100
    strings:      .skip 1000
    result:       .skip 100
    num_strings:  .quad 0

    .section ".text"
    .align 2
_start:
    // Pedir número de cadenas
    mov     x0, #1              // stdout
    ldr     x1, =msg_input
    mov     x2, #len_input
    mov     x8, #64            // syscall write
    svc     #0

    // Leer número
    mov     x0, #0              // stdin
    ldr     x1, =buffer
    mov     x2, #5
    mov     x8, #63            // syscall read
    svc     #0

    // Convertir a número
    ldr     x1, =buffer
    bl      atoi
    ldr     x1, =num_strings
    str     x0, [x1]           // Guardar número de cadenas
    mov     x19, x0            // Guardar en x19 también

    // Leer cadenas
    mov     x20, #0            // Contador de cadenas
    ldr     x21, =strings      // Base de strings

read_loop:
    // Imprimir prompt
    mov     x0, #1
    ldr     x1, =msg_str
    mov     x2, #len_msg_str
    mov     x8, #64
    svc     #0

    // Leer cadena
    mov     x0, #0
    mov     x1, x21
    mov     x2, #100
    mov     x8, #63
    svc     #0
    
    sub     x0, x0, #1         // Ajustar longitud (quitar \n)
    strb    wzr, [x21, x0]     // Poner null al final
    
    add     x21, x21, #100     // Siguiente posición de memoria
    add     x20, x20, #1       // Incrementar contador
    cmp     x20, x19
    b.lt    read_loop

    // Encontrar prefijo común
    bl      find_prefix

    // Imprimir mensaje resultado
    mov     x0, #1
    ldr     x1, =msg_result
    mov     x2, #len_result
    mov     x8, #64
    svc     #0

    // Imprimir prefijo
    mov     x0, #1
    ldr     x1, =result
    mov     x2, x23            // Longitud del prefijo
    mov     x8, #64
    svc     #0

    // Imprimir newline
    mov     x0, #1
    ldr     x1, =newline
    mov     x2, #1
    mov     x8, #64
    svc     #0

    // Exit
    mov     x8, #93
    mov     x0, #0
    svc     #0

// Función para encontrar prefijo común
find_prefix:
    ldr     x0, =strings       // Primera cadena
    ldr     x1, =result        // Buffer resultado
    mov     x23, #0            // Contador de caracteres del prefijo

next_char:
    // Cargar carácter de primera cadena
    ldrb    w2, [x0, x23]
    cbz     w2, done           // Si es null, terminamos

    // Comparar con resto de cadenas
    mov     x4, #1             // Índice de cadena actual
compare_loop:
    cmp     x4, x19            // Comparar con número total de cadenas
    b.ge    store_char         // Si terminamos comparación, guardar carácter

    // Calcular dirección de cadena actual
    mov     x5, #100
    mul     x5, x4, x5
    ldr     x6, =strings
    add     x6, x6, x5

    // Comparar carácter
    ldrb    w7, [x6, x23]
    cmp     w7, w2
    b.ne    done              // Si no coincide, terminamos

    add     x4, x4, #1
    b       compare_loop

store_char:
    // Guardar carácter en resultado
    strb    w2, [x1, x23]
    add     x23, x23, #1
    b       next_char

done:
    // Terminar string con null
    strb    wzr, [x1, x23]
    ret

// Convertir ASCII a número
atoi:
    mov     x0, #0              // Resultado
    mov     x2, #10             // Base 10
atoi_loop:
    ldrb    w3, [x1], #1        // Cargar siguiente byte
    cmp     w3, #'\n'           // Si es newline, terminar
    b.eq    atoi_done
    sub     w3, w3, #'0'        // Convertir a número
    mul     x0, x0, x2          // Multiplicar por 10
    add     x0, x0, x3          // Añadir dígito
    b       atoi_loop
atoi_done:
    ret
