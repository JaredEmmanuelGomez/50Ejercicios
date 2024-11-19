# Lenguajes de Interfaz - Actividad 41
# Encontrar el segundo elemento más grande
# Alumno: Gómez Aguilar Jared Emmanuel  
# Número de Control: 22210309  
# Python y Ensamblador
# Comparación en arreglos

# -----------------------------------------------------------
/*
def second_largest(arr):
    unique_arr = list(set(arr))
    unique_arr.sort()
    return unique_arr[-2] if len(unique_arr) >= 2 else None
*/
# -----------------------------------------------------------

.global _start

.section .data
msg1:    .ascii "Arreglo: "
len1 = . - msg1
msg2:    .ascii "\nEl segundo elemento mas grande es: "
len2 = . - msg2
array:   .quad 5, 8, 3, 9, 1, 7, 6, 4    // Arreglo de números
size:    .quad 8                          // Tamaño del arreglo
buffer:  .skip 32                         // Buffer para conversión
space:   .ascii " "
newline: .ascii "\n"
max1:    .quad 0                          // Primer máximo
max2:    .quad 0                          // Segundo máximo

.section .text
_start:
    // Mostrar mensaje inicial
    mov x0, #1
    ldr x1, =msg1
    mov x2, len1
    mov x8, #64
    svc #0

    // Mostrar arreglo
    bl mostrar_arreglo

    // Encontrar segundo máximo
    bl encontrar_segundo_max

    // Mostrar mensaje resultado
    mov x0, #1
    ldr x1, =msg2
    mov x2, len2
    mov x8, #64
    svc #0

    // Mostrar resultado
    ldr x21, =max2
    ldr x21, [x21]
    bl mostrar_numero

    // Nueva línea
    mov x0, #1
    ldr x1, =newline
    mov x2, #1
    mov x8, #64
    svc #0

    // Salir
    mov x0, #0
    mov x8, #93
    svc #0

encontrar_segundo_max:
    str x30, [sp, #-16]!           // Guardar enlace retorno

    // Inicializar max1 y max2 con primer elemento
    ldr x9, =array
    ldr x10, [x9]                  // Primer elemento
    ldr x11, =max1
    str x10, [x11]                 // max1 = primer elemento
    ldr x11, =max2
    str x10, [x11]                 // max2 = primer elemento

    // Inicializar índice
    mov x12, #1                    // Empezar desde segundo elemento
    ldr x13, =size
    ldr x13, [x13]                 // Cargar tamaño

buscar_loop:
    cmp x12, x13                   // Verificar si terminamos
    beq fin_buscar

    // Cargar elemento actual
    ldr x14, [x9, x12, lsl #3]     // Elemento actual
    ldr x15, =max1
    ldr x15, [x15]                 // Cargar max1

    // Comparar con max1
    cmp x14, x15
    ble comparar_max2              // Si es menor o igual, comparar con max2
    
    // Actualizar máximos
    ldr x16, =max2
    str x15, [x16]                 // max2 = antiguo max1
    ldr x16, =max1
    str x14, [x16]                 // max1 = elemento actual
    b siguiente

comparar_max2:
    ldr x15, =max2
    ldr x15, [x15]                 // Cargar max2
    cmp x14, x15
    ble siguiente                  // Si es menor o igual, siguiente
    
    // Actualizar max2
    ldr x16, =max2
    str x14, [x16]                 // max2 = elemento actual

siguiente:
    add x12, x12, #1              // Siguiente elemento
    b buscar_loop

fin_buscar:
    ldr x30, [sp], #16
    ret

mostrar_arreglo:
    str x30, [sp, #-16]!          // Guardar enlace retorno
    
    mov x9, #0                    // Índice
    ldr x10, =array              // Base del arreglo
    ldr x11, =size              // Tamaño
    ldr x11, [x11]

mostrar_loop:
    cmp x9, x11
    beq fin_mostrar
    
    ldr x21, [x10, x9, lsl #3]
    bl mostrar_numero
    
    // Mostrar espacio
    mov x0, #1
    ldr x1, =space
    mov x2, #1
    mov x8, #64
    svc #0
    
    add x9, x9, #1
    b mostrar_loop

fin_mostrar:
    ldr x30, [sp], #16
    ret

mostrar_numero:
    str x30, [sp, #-16]!          // Guardar enlace retorno
    
    // Preparar para conversión
    mov x22, x21                  // Copia del número
    ldr x23, =buffer             // Buffer
    mov x24, #0                  // Contador de dígitos

convertir_loop:
    mov x25, #10
    udiv x26, x22, x25           // Dividir por 10
    msub x27, x26, x25, x22      // Obtener resto
    add x27, x27, #'0'           // Convertir a ASCII
    strb w27, [x23, x24]         // Guardar dígito
    add x24, x24, #1             // Incrementar contador
    mov x22, x26                 // Actualizar número
    cbnz x22, convertir_loop
    
    // Invertir dígitos
    mov x25, #0                  // Inicio
    sub x26, x24, #1             // Fin

invertir_loop:
    cmp x25, x26
    bge mostrar_digitos
    
    ldrb w27, [x23, x25]         // Cargar byte inicio
    ldrb w28, [x23, x26]         // Cargar byte fin
    strb w28, [x23, x25]         // Guardar fin en inicio
    strb w27, [x23, x26]         // Guardar inicio en fin
    
    add x25, x25, #1
    sub x26, x26, #1
    b invertir_loop

mostrar_digitos:
    mov x0, #1                   // stdout
    mov x1, x23                  // buffer
    mov x2, x24                  // longitud
    mov x8, #64                  // syscall write
    svc #0
    
    ldr x30, [sp], #16
    ret


ASCIINEMA REC
https://asciinema.org/a/690866
