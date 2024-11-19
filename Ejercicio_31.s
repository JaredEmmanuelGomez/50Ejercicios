# Lenguajes de Interfaz - Actividad 31
# Contar vocales y consonantes
# Alumno: Gómez Aguilar Jared Emmanuel  
# Número de Control: 22210309  
# Python y Ensamblador
# Análisis de cadenas

# ----------------------------------------------------------------------------------
/*
def count_vowels_consonants(string):
    vowels = 'aeiouAEIOU'
    v_count = sum(1 for char in string if char in vowels)
    c_count = sum(1 for char in string if char.isalpha() and char not in vowels)
    return v_count, c_count
*/
# -----------------------------------------------------------------------------------

// Gómez Aguilar Jared Emmanuel
// 22210309
// count_vowels_consonants.s
.data
    msg1:    .ascii "Texto: "
    len1 = . - msg1
    msg2:    .ascii "\nNúmero de vocales: "
    len2 = . - msg2
    msg3:    .ascii "\nNúmero de consonantes: "
    len3 = . - msg3
    texto:   .ascii "Hola Mundo!"    // Texto de ejemplo
    len_texto = . - texto
    buffer:  .skip 20                // Buffer para números
    newline: .ascii "\n"

.text
.global _start

_start:
    // Mostrar mensaje inicial
    mov x0, #1
    adr x1, msg1
    mov x2, len1
    mov x8, #64
    svc #0
    
    // Mostrar texto
    mov x0, #1
    adr x1, texto
    mov x2, len_texto
    mov x8, #64
    svc #0

    // Inicializar contadores
    mov x19, #0          // vocales
    mov x20, #0          // consonantes
    
    // Preparar para procesar el texto
    adr x21, texto       // dirección del texto
    mov x22, #0          // índice

procesar_texto:
    cmp x22, len_texto
    beq mostrar_resultados
    
    // Cargar carácter actual
    ldrb w23, [x21, x22]
    
    // Convertir mayúsculas a minúsculas
    mov w24, w23
    cmp w24, #'A'
    blt no_letra
    cmp w24, #'Z'
    bgt check_minuscula
    add w24, w24, #32    // Convertir a minúscula
    b check_vocal
    
check_minuscula:
    cmp w24, #'a'
    blt no_letra
    cmp w24, #'z'
    bgt no_letra
    
check_vocal:
    // Comprobar si es vocal
    cmp w24, #'a'
    beq es_vocal
    cmp w24, #'e'
    beq es_vocal
    cmp w24, #'i'
    beq es_vocal
    cmp w24, #'o'
    beq es_vocal
    cmp w24, #'u'
    beq es_vocal
    
    // Si llegamos aquí y es letra, es consonante
    cmp w24, #'a'
    blt no_letra
    cmp w24, #'z'
    bgt no_letra
    add x20, x20, #1     // Incrementar consonantes
    b siguiente_caracter
    
es_vocal:
    add x19, x19, #1     // Incrementar vocales
    b siguiente_caracter
    
no_letra:
    // No hacer nada, pasar al siguiente carácter
    
siguiente_caracter:
    add x22, x22, #1
    b procesar_texto

mostrar_resultados:
    // Mostrar mensaje vocales
    mov x0, #1
    adr x1, msg2
    mov x2, len2
    mov x8, #64
    svc #0
    
    // Mostrar número de vocales
    mov x0, x19
    bl imprimir_numero
    
    // Mostrar mensaje consonantes
    mov x0, #1
    adr x1, msg3
    mov x2, len3
    mov x8, #64
    svc #0
    
    // Mostrar número de consonantes
    mov x0, x20
    bl imprimir_numero
    
    // Mostrar nueva línea
    mov x0, #1
    adr x1, newline
    mov x2, #1
    mov x8, #64
    svc #0
    
    // Salir del programa
    mov x0, #0
    mov x8, #93
    svc #0

imprimir_numero:
    // x0 = número a imprimir
    stp x29, x30, [sp, #-16]!
    stp x19, x20, [sp, #-16]!
    
    mov x19, x0          // Guardar número original
    mov x20, #0          // Contador de dígitos
    mov x3, #10          // Para divisiones
    
    // Si es 0, imprimir 0 directamente
    cmp x19, #0
    bne contar_digitos
    
    mov w4, #'0'
    strb w4, [sp, #-1]!
    mov x1, sp
    mov x2, #1
    mov x0, #1
    mov x8, #64
    svc #0
    add sp, sp, #1
    b imprimir_fin
    
contar_digitos:
    mov x1, x19
count_loop:
    cbz x1, convertir_digitos
    udiv x1, x1, x3
    add x20, x20, #1
    b count_loop
    
convertir_digitos:
    // Reservar espacio en stack
    mov x1, x20
    sub sp, sp, x1
    mov x2, sp          // Guardar inicio del buffer
    
    mov x0, x19         // Restaurar número original
convertir_loop:
    udiv x4, x0, x3     // Dividir por 10
    msub x5, x4, x3, x0 // Obtener resto
    add w5, w5, #'0'    // Convertir a ASCII
    sub x1, x1, #1      // Decrementar posición
    strb w5, [x2, x1]   // Guardar dígito
    mov x0, x4          // Preparar siguiente iteración
    cbnz x0, convertir_loop
    
    // Imprimir número
    mov x0, #1          // stdout
    mov x1, sp          // buffer
    mov x2, x20         // longitud
    mov x8, #64         // write syscall
    svc #0
    
    // Restaurar stack
    add sp, sp, x20
    
imprimir_fin:
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret
