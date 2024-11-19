# Lenguajes de Interfaz - Actividad 43
# Implementar una cola usando un arreglo
# Alumno: Gómez Aguilar Jared Emmanuel  
# Número de Control: 22210309  
# Python y Ensamblador
# Estructuras de datos

# -------------------------------------
/*
class Queue:
    def __init__(self):
        self.queue = []

    def enqueue(self, item):
        self.queue.append(item)

    def dequeue(self):
        return self.queue.pop(0) if self.queue else None

*/
# -------------------------------------

.global _start

.section .data
msg1:       .ascii "Operaciones con la cola:\n"
len1 = . - msg1
msg_enq:    .ascii "\nEnqueue: "
len_enq = . - msg_enq
msg_deq:    .ascii "\nDequeue: "
len_deq = . - msg_deq
msg_front:  .ascii "\nFrente: "
len_front = . - msg_front
msg_empty:  .ascii "\nLa cola está vacía"
len_empty = . - msg_empty
msg_full:   .ascii "\nLa cola está llena"
len_full = . - msg_full
msg_show:   .ascii "\nElementos en la cola: "
len_show = . - msg_show

queue:      .skip 80            // Espacio para 10 números de 64 bits
q_size:     .quad 10            // Tamaño máximo de la cola
front:      .quad 0             // Índice del frente
rear:       .quad 0             // Índice del final
count:      .quad 0             // Contador de elementos

buffer:     .skip 32            // Buffer para conversión
newline:    .ascii "\n"
space:      .ascii " "

.section .text
_start:
    // Mostrar mensaje inicial
    mov x0, #1
    ldr x1, =msg1
    mov x2, len1
    mov x8, #64
    svc #0

    // Enqueue varios elementos
    mov x0, #5
    bl enqueue
    
    mov x0, #10
    bl enqueue
    
    mov x0, #15
    bl enqueue

    // Mostrar elementos
    bl show_queue

    // Dequeue un elemento
    bl dequeue

    // Mostrar frente
    bl front_element

    // Mostrar elementos actualizados
    bl show_queue

exit:
    mov x0, #0
    mov x8, #93
    svc #0

// Función enqueue: añade un elemento al final de la cola
enqueue:
    stp x29, x30, [sp, #-16]!   // Guardar registros
    
    // Verificar si la cola está llena
    ldr x9, =count
    ldr x10, [x9]
    ldr x11, =q_size
    ldr x11, [x11]
    cmp x10, x11
    bge queue_full

    // Mostrar mensaje enqueue
    mov x19, x0                  // Guardar valor a insertar
    mov x0, #1
    ldr x1, =msg_enq
    mov x2, len_enq
    mov x8, #64
    svc #0

    mov x21, x19
    bl print_number

    // Insertar elemento
    ldr x12, =queue             // Dirección base
    ldr x13, =rear
    ldr x14, [x13]              // Índice rear
    str x19, [x12, x14, lsl #3] // Guardar elemento
    
    // Actualizar rear
    add x14, x14, #1
    ldr x15, =q_size
    ldr x15, [x15]
    udiv x16, x14, x15          // División para obtener el módulo
    msub x14, x16, x15, x14     // rear = (rear + 1) % size
    str x14, [x13]
    
    // Incrementar count
    ldr x9, =count
    ldr x10, [x9]
    add x10, x10, #1
    str x10, [x9]
    
    ldp x29, x30, [sp], #16
    ret

queue_full:
    mov x0, #1
    ldr x1, =msg_full
    mov x2, len_full
    mov x8, #64
    svc #0
    ldp x29, x30, [sp], #16
    ret

// Función dequeue: elimina y retorna el elemento del frente
dequeue:
    stp x29, x30, [sp, #-16]!

    // Verificar si la cola está vacía
    ldr x9, =count
    ldr x10, [x9]
    cbz x10, queue_empty

    // Mostrar mensaje dequeue
    mov x0, #1
    ldr x1, =msg_deq
    mov x2, len_deq
    mov x8, #64
    svc #0

    // Obtener elemento del frente
    ldr x12, =queue
    ldr x13, =front
    ldr x14, [x13]
    ldr x21, [x12, x14, lsl #3]
    bl print_number

    // Actualizar front
    add x14, x14, #1
    ldr x15, =q_size
    ldr x15, [x15]
    udiv x16, x14, x15
    msub x14, x16, x15, x14
    str x14, [x13]

    // Decrementar count
    sub x10, x10, #1
    str x10, [x9]

    ldp x29, x30, [sp], #16
    ret

queue_empty:
    mov x0, #1
    ldr x1, =msg_empty
    mov x2, len_empty
    mov x8, #64
    svc #0
    ldp x29, x30, [sp], #16
    ret

// Función front_element: muestra el elemento del frente
front_element:
    stp x29, x30, [sp, #-16]!

    // Verificar si la cola está vacía
    ldr x9, =count
    ldr x10, [x9]
    cbz x10, queue_empty

    // Mostrar mensaje
    mov x0, #1
    ldr x1, =msg_front
    mov x2, len_front
    mov x8, #64
    svc #0

    // Mostrar elemento del frente
    ldr x12, =queue
    ldr x13, =front
    ldr x14, [x13]
    ldr x21, [x12, x14, lsl #3]
    bl print_number

    ldp x29, x30, [sp], #16
    ret

// Función show_queue: muestra todos los elementos
show_queue:
    stp x29, x30, [sp, #-16]!

    // Verificar si está vacía
    ldr x9, =count
    ldr x10, [x9]
    cbz x10, queue_empty

    // Mostrar mensaje
    mov x0, #1
    ldr x1, =msg_show
    mov x2, len_show
    mov x8, #64
    svc #0

    // Inicializar variables
    ldr x11, =front
    ldr x11, [x11]              // Índice actual
    mov x12, #0                 // Contador
    ldr x13, =queue            // Dirección base

show_loop:
    cmp x12, x10                // Comparar con count
    beq end_show

    // Mostrar elemento
    ldr x21, [x13, x11, lsl #3]
    bl print_number

    // Mostrar espacio
    mov x0, #1
    ldr x1, =space
    mov x2, #1
    mov x8, #64
    svc #0

    // Siguiente elemento
    add x11, x11, #1
    ldr x14, =q_size
    ldr x14, [x14]
    udiv x15, x11, x14
    msub x11, x15, x14, x11     // índice = (índice + 1) % size
    add x12, x12, #1
    b show_loop

end_show:
    mov x0, #1
    ldr x1, =newline
    mov x2, #1
    mov x8, #64
    svc #0

    ldp x29, x30, [sp], #16
    ret

// Función auxiliar para imprimir números
print_number:
    stp x29, x30, [sp, #-16]!

    mov x22, x21                // Copia del número
    ldr x23, =buffer           // Buffer para dígitos
    mov x24, #0                // Contador de dígitos

convert_loop:
    mov x25, #10
    udiv x26, x22, x25         // Dividir por 10
    msub x27, x26, x25, x22    // Obtener resto
    add x27, x27, #'0'         // Convertir a ASCII
    strb w27, [x23, x24]       // Guardar dígito
    add x24, x24, #1           // Incrementar contador
    mov x22, x26               // Actualizar número
    cbnz x22, convert_loop

    // Invertir dígitos
    mov x25, #0                // Inicio
    sub x26, x24, #1           // Fin

reverse_loop:
    cmp x25, x26
    bge print_digits
    ldrb w27, [x23, x25]       // Cargar byte inicio
    ldrb w28, [x23, x26]       // Cargar byte fin
    strb w28, [x23, x25]       // Guardar fin en inicio
    strb w27, [x23, x26]       // Guardar inicio en fin
    add x25, x25, #1
    sub x26, x26, #1
    b reverse_loop

print_digits:
    mov x0, #1
    mov x1, x23                // Buffer
    mov x2, x24                // Longitud
    mov x8, #64
    svc #0

    ldp x29, x30, [sp], #16
    ret


ASCIINEMA REC
https://asciinema.org/a/690875
