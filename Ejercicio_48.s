# Lenguajes de Interfaz - Actividad 48
# Detección de desbordamiento en suma
# Alumno: Gómez Aguilar Jared Emmanuel  
# Número de Control: 22210309  
# Python y Ensamblador
# Detección de desbordamiento

# ----------------------------------------------
/*
def check_overflow_addition(a, b):
    try:
        result = a + b
        return result
    except OverflowError:
        return "Overflow detected"
*/
# --------------------------------------------


.arch armv8-a
    .global _start

    .section ".data"
    msg_num1:     .ascii "Ingrese primer numero: "
    len_num1     = . - msg_num1
    
    msg_num2:     .ascii "Ingrese segundo numero: "
    len_num2     = . - msg_num2
    
    msg_suma:     .ascii "Resultado de la suma: "
    len_suma     = . - msg_suma
    
    msg_overflow: .ascii "\nHay desbordamiento!\n"
    len_overflow = . - msg_overflow
    
    msg_nooverflow: .ascii "\nNo hay desbordamiento\n"
    len_nooverflow = . - msg_nooverflow
    
    newline:      .ascii "\n"
    len_newline  = . - newline

    buffer:       .skip 20
    num1:         .quad 0
    num2:         .quad 0
    resultado:    .quad 0

    .section ".text"
    .align 2
_start:
    // Pedir primer número
    mov     x0, #1              
    ldr     x1, =msg_num1
    mov     x2, #len_num1
    mov     x8, #64            
    svc     #0

    // Leer primer número
    mov     x0, #0              
    ldr     x1, =buffer
    mov     x2, #20
    mov     x8, #63            
    svc     #0

    // Convertir a número
    ldr     x1, =buffer
    bl      atoi
    ldr     x1, =num1
    str     x0, [x1]           

    // Pedir segundo número
    mov     x0, #1
    ldr     x1, =msg_num2
    mov     x2, #len_num2
    mov     x8, #64
    svc     #0

    // Leer segundo número
    mov     x0, #0
    ldr     x1, =buffer
    mov     x2, #20
    mov     x8, #63
    svc     #0

    // Convertir a número
    ldr     x1, =buffer
    bl      atoi
    ldr     x1, =num2
    str     x0, [x1]           

    // Cargar números y verificar desbordamiento
    ldr     x0, =num1
    ldr     x1, [x0]           // x1 = primer número
    ldr     x0, =num2
    ldr     x2, [x0]           // x2 = segundo número

    // Verificar desbordamiento positivo
    adds    x3, x1, x2         // Realizar suma
    
    // Verificar si ambos números son positivos y el resultado es negativo
    tst     x1, #(1<<63)       // Verificar signo de x1
    b.ne    check_negative
    tst     x2, #(1<<63)       // Verificar signo de x2
    b.ne    check_negative
    tst     x3, #(1<<63)       // Verificar signo del resultado
    b.ne    overflow           // Si resultado es negativo, hay overflow

check_negative:
    // Verificar si ambos números son negativos y el resultado es positivo
    tst     x1, #(1<<63)       // Verificar signo de x1
    b.eq    no_overflow
    tst     x2, #(1<<63)       // Verificar signo de x2
    b.eq    no_overflow
    tst     x3, #(1<<63)       // Verificar signo del resultado
    b.eq    overflow           // Si resultado es positivo, hay overflow

    // Guardar y mostrar resultado
    ldr     x0, =resultado
    str     x3, [x0]

    // Mostrar mensaje de suma
    mov     x0, #1
    ldr     x1, =msg_suma
    mov     x2, #len_suma
    mov     x8, #64
    svc     #0

    // Convertir resultado a string y mostrar
    mov     x0, x3
    ldr     x1, =buffer
    bl      num_to_str
    
    // Imprimir resultado
    mov     x0, #1
    ldr     x1, =buffer
    mov     x2, #20
    mov     x8, #64
    svc     #0

    b       no_overflow        // Continuar con mensaje de no overflow

overflow:
    mov     x0, #1
    ldr     x1, =msg_overflow
    mov     x2, #len_overflow
    mov     x8, #64
    svc     #0
    b       exit

no_overflow:
    mov     x0, #1
    ldr     x1, =msg_nooverflow
    mov     x2, #len_nooverflow
    mov     x8, #64
    svc     #0

exit:
    mov     x8, #93            
    mov     x0, #0
    svc     #0

// Función para convertir ASCII a número
atoi:
    mov     x0, #0              
    mov     x2, #10             
    mov     x4, #0              

    // Verificar si es negativo
    ldrb    w3, [x1]
    cmp     w3, #'-'
    b.ne    atoi_loop
    mov     x4, #1              
    add     x1, x1, #1          

atoi_loop:
    ldrb    w3, [x1], #1        
    cmp     w3, #'\n'           
    b.eq    atoi_done
    sub     w3, w3, #'0'        
    mul     x0, x0, x2          
    add     x0, x0, x3          
    b       atoi_loop

atoi_done:
    cmp     x4, #1
    b.ne    atoi_return
    neg     x0, x0
atoi_return:
    ret

// Función para convertir número a string
num_to_str:
    mov     x2, #0              
    mov     x4, #0              
    
    cmp     x0, #0
    b.ge    num_convert
    neg     x0, x0              
    mov     x4, #1              

num_convert:
    mov     x3, #10             

convert_loop:
    udiv    x5, x0, x3          
    msub    x6, x5, x3, x0      
    add     x6, x6, #'0'        
    strb    w6, [x1, x2]        
    add     x2, x2, #1          
    mov     x0, x5              
    cbnz    x0, convert_loop    

    cmp     x4, #1
    b.ne    reverse_string
    mov     w6, #'-'
    strb    w6, [x1, x2]
    add     x2, x2, #1

reverse_string:
    mov     w6, #0
    strb    w6, [x1, x2]
    
    sub     x2, x2, #1          
    mov     x3, #0              

reverse_loop:
    cmp     x3, x2
    b.ge    num_to_str_done
    ldrb    w4, [x1, x3]        
    ldrb    w5, [x1, x2]        
    strb    w5, [x1, x3]        
    strb    w4, [x1, x2]
    add     x3, x3, #1
    sub     x2, x2, #1
    b       reverse_loop

num_to_str_done:
    ret

https://asciinema.org/a/690891
