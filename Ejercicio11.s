# Lenguajes de Interfaz - Actividad 11
# Invertir una cadena
# Alumno: Gómez Aguilar Jared Emmanuel  
# Número de Control: 22210309  
# Python y Ensamblador

# ------------------------
/*
def invertir_cadena(cadena):
    return cadena[::-1]
*/
# --------------------------




//Alumno: Gómez Aguilar Jared Emmanuel 
//Número de Control: 22210309 
.data
    cadena: .skip 256

.text
.global _start

invertir_cadena:
    // x0 = dirección de la cadena
    stp x29, x30, [sp, #-16]!    // Guardar registros
    mov x29, sp
    
    // Calcular longitud de la cadena
    mov x2, x0                    // Copiar dirección original
    mov x3, #0                    // Contador de longitud
    
longitud_loop:
    ldrb w4, [x2], #1            // Cargar byte y avanzar puntero
    cbz w4, fin_longitud         // Si es 0, fin de cadena
    add x3, x3, #1               // Incrementar contador
    b longitud_loop
    
fin_longitud:
    sub x3, x3, #1               // Ajustar para índice base 0
    mov x4, #0                   // Índice inicial

invertir_loop:
    cmp x4, x3                   // Comparar índices
    bge fin_inversion            // Si inicial >= final, terminar
    
    // Intercambiar caracteres
    ldrb w5, [x0, x4]           // Cargar caracter inicial
    ldrb w6, [x0, x3]           // Cargar caracter final
    strb w6, [x0, x4]           // Guardar final en posición inicial
    strb w5, [x0, x3]           // Guardar inicial en posición final
    
    add x4, x4, #1              // Incrementar índice inicial
    sub x3, x3, #1              // Decrementar índice final
    b invertir_loop

fin_inversion:
    ldp x29, x30, [sp], #16     // Restaurar registros
    ret

_start:
    // Código para probar la función
    adr x0, cadena              // Cargar dirección de la cadena
    bl invertir_cadena          // Llamar a la función
    
    // Salir del programa
    mov x0, #0
    mov x8, #93                 // Syscall exit
    svc #0
