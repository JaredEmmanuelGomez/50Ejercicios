# Lenguajes de Interfaz - Actividad 50
# Escribir en un archivo
# Alumno: Gómez Aguilar Jared Emmanuel  
# Número de Control: 22210309  
# Python y Ensamblador
# Manejo de archivos y llamadas al sistema

# ---------------------------------------
/*
def write_to_file(filename, content):
    with open(filename, 'w') as f:
        f.write(content)
*/
# ---------------------------------------------


.data
    filename:    .ascii "archivo.txt\0"    // Nombre del archivo a crear
    message:     .ascii "Hola, este es un texto de prueba!\n\0"  // Mensaje a escribir
    msg_len = . - message
    
    success_msg: .ascii "Archivo creado exitosamente!\n"
    success_len = . - success_msg
    
    write_msg:   .ascii "Escribiendo en el archivo...\n"
    write_len = . - write_msg
    
    close_msg:   .ascii "Cerrando archivo...\n"
    close_len = . - close_msg
    
    error_msg:   .ascii "Error al abrir/escribir el archivo\n"
    error_len = . - error_msg

.text
.global _start

_start:
    // Mostrar mensaje de inicio
    mov x0, #1              // stdout
    adr x1, write_msg      // mensaje
    mov x2, write_len      // longitud
    mov x8, #64            // write syscall
    svc #0

    // Abrir (crear) el archivo
    mov x0, #-100          // AT_FDCWD (directorio actual)
    adr x1, filename       // nombre del archivo
    mov x2, #0x241        // Flags: O_CREAT|O_WRONLY|O_TRUNC
    mov x3, #0666         // Permisos: rw-rw-rw-
    mov x8, #56           // openat syscall
    svc #0
    
    // Verificar si hubo error al abrir
    cmp x0, #0
    blt error_handler
    
    // Guardar el file descriptor
    mov x19, x0
    
    // Escribir en el archivo
    mov x0, x19           // file descriptor
    adr x1, message       // mensaje a escribir
    mov x2, msg_len      // longitud del mensaje
    mov x8, #64          // write syscall
    svc #0
    
    // Verificar si hubo error al escribir
    cmp x0, #0
    blt error_handler
    
    // Mostrar mensaje de éxito
    mov x0, #1           // stdout
    adr x1, success_msg  // mensaje
    mov x2, success_len  // longitud
    mov x8, #64         // write syscall
    svc #0
    
    // Mostrar mensaje de cierre
    mov x0, #1           // stdout
    adr x1, close_msg    // mensaje
    mov x2, close_len    // longitud
    mov x8, #64         // write syscall
    svc #0

    // Cerrar el archivo
    mov x0, x19          // file descriptor
    mov x8, #57          // close syscall
    svc #0
    
    // Salir normalmente
    mov x0, #0
    b exit_program

error_handler:
    // Mostrar mensaje de error
    mov x0, #1           // stdout
    adr x1, error_msg    // mensaje de error
    mov x2, error_len    // longitud del mensaje
    mov x8, #64         // write syscall
    svc #0
    
    mov x0, #1           // código de error para salida

exit_program:
    // Salir del programa
    mov x8, #93          // exit syscall
    svc #0
