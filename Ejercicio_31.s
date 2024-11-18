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
.global _start

.data
    text:       .ascii  "Hello World"     // Texto de ejemplo
    text_len:   .quad   11               // Longitud del texto
    vowels:     .ascii  "aeiouAEIOU"     // Lista de vocales
    vowels_len: .quad   10               // Longitud de la lista de vocales
    v_count:    .quad   0                // Contador de vocales
    c_count:    .quad   0                // Contador de consonantes
    
.text
_start:
    ldr x0, =text
    ldr x1, =text_len
    ldr x1, [x1]
    bl count_vowels_consonants
    
    mov x8, #93            // exit syscall
    mov x0, #0
    svc #0

count_vowels_consonants:
    // x0: dirección del texto
    // x1: longitud del texto
    stp x29, x30, [sp, #-32]!
    stp x19, x20, [sp, #16]
    mov x29, sp
    
    mov x19, #0            // vowel_count = 0
    mov x20, #0            // consonant_count = 0
    mov x2, #0             // i = 0
    
char_loop:
    cmp x2, x1
    b.ge count_end
    
    // Cargar carácter actual
    ldrb w3, [x0, x2]
    
    // Verificar si es letra
    bl is_letter
    cbz x0, next_char
    
    // Verificar si es vocal
    mov x0, x3
    bl is_vowel
    cbnz x0, increment_vowel
    
    // Si no es vocal pero es letra, es consonante
    add x20, x20, #1
    b next_char
    
increment_vowel:
    add x19, x19, #1
    
next_char:
    add x2, x2, #1
    b char_loop
    
count_end:
    // Guardar resultados
    ldr x0, =v_count
    str x19, [x0]
    ldr x0, =c_count
    str x20, [x0]
    
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #32
    ret

is_letter:
    // x3: carácter a verificar
    // Retorna: x0 = 1 si es letra, 0 si no
    
    // Verificar si está en el rango 'A'-'Z'
    cmp w3, #'A'
    b.lt not_letter
    cmp w3, #'Z'
    b.le is_letter_true
    
    // Verificar si está en el rango 'a'-'z'
    cmp w3, #'a'
    b.lt not_letter
    cmp w3, #'z'
    b.le is_letter_true
    
not_letter:
    mov x0, #0
    ret
    
is_letter_true:
    mov x0, #1
    ret

is_vowel:
    // x0: carácter a verificar
    // Retorna: x0 = 1 si es vocal, 0 si no
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    
    ldr x1, =vowels
    ldr x2, =vowels_len
    ldr x2, [x2]
    mov x3, #0             // i = 0
    
vowel_loop:
    cmp x3, x2
    b.ge not_vowel
    
    ldrb w4, [x1, x3]
    cmp w0, w4
    b.eq is_vowel_true
    
    add x3, x3, #1
    b vowel_loop
    
not_vowel:
    mov x0, #0
    ldp x29, x30, [sp], #16
    ret
    
is_vowel_true:
    mov x0, #1
    ldp x29, x30, [sp], #16
    ret
