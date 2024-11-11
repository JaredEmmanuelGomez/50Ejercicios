# Lenguajes de Interfaz - Actividad 10
# Verificar si un número es primo
# Alumno: Gómez Aguilar Jared Emmanuel  
# Número de Control: 22210309  
# Python y Ensamblador

#-------------------------------------------------
# Función para verificar si un número es primo
/*
def es_primo(numero):
    if numero <= 1:
        return False
    if numero == 2:
        return True  # El 2 es primo
    for i in range(2, int(numero ** 0.5) + 1):  # Verificamos hasta la raíz cuadrada del número
        if numero % i == 0:  # Si es divisible por cualquier número en ese rango, no es primo
            return False
    return True  # Si no encontramos divisores, es primo

# Solicitar un número al usuario
numero = int(input("Introduce un número: "))

# Verificar si es primo
if es_primo(numero):
    print(f"{numero} es un número primo.")
else:
    print(f"{numero} no es un número primo.")
*/
#--------------------------------------------------



//Gómez Aguilar Jared Emmanuel
//22210309
.data
prompt:     .string "Introduce un número: "
format_in:  .string "%d"
is_prime:   .string "%d es un número primo.\n"
not_prime:  .string "%d no es un número primo.\n"

        .text
        .global main
        .type main, %function

main:
        stp     x29, x30, [sp, -32]!    // Guardar frame pointer y link register
        mov     x29, sp                  // Set up frame pointer

        // Imprimir prompt
        adr     x0, prompt
        bl      printf

        // Leer número
        add     x1, sp, #16             // Espacio para el número
        adr     x0, format_in
        bl      scanf

        // Cargar número para verificar si es primo
        ldr     w0, [sp, #16]           // Cargar número en w0
        str     w0, [sp, #20]           // Guardar copia del número
        
        // Verificar si es menor o igual a 1
        cmp     w0, #1
        ble     not_prime_label
        
        // Verificar si es 2
        cmp     w0, #2
        beq     is_prime_label
        
        // Inicializar contador en 2
        mov     w1, #2
check_loop:
        // Verificar si llegamos a la raíz cuadrada
        mul     w2, w1, w1              // w2 = i * i
        ldr     w0, [sp, #20]           // Recargar número original
        cmp     w2, w0                  // Comparar i*i con n
        bgt     is_prime_label          // Si i*i > n, es primo
        
        // Verificar si es divisible
        sdiv    w3, w0, w1              // w3 = n / i
        msub    w3, w3, w1, w0          // w3 = n - (n/i)*i (resto)
        cbz     w3, not_prime_label     // Si resto es 0, no es primo
        
        // Incrementar contador y continuar
        add     w1, w1, #1
        b       check_loop

is_prime_label:
        adr     x0, is_prime
        ldr     w1, [sp, #20]           // Cargar número original
        bl      printf
        b       end

not_prime_label:
        adr     x0, not_prime
        ldr     w1, [sp, #20]           // Cargar número original
        bl      printf

end:
        mov     w0, #0                  // Return 0
        ldp     x29, x30, [sp], #32     // Restaurar frame pointer y link register
        ret

        .size main, (. - main)
