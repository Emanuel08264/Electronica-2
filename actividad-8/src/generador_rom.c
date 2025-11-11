#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Definimos los nombres de los archivos. Asumimos que están en la misma carpeta.
#define ARCHIVO_MAESTRO "rom_32bit_maestro.txt"
#define ARCHIVO_B0      "rom_b0.txt"
#define ARCHIVO_B1      "rom_b1.txt"
#define ARCHIVO_B2      "rom_b2.txt"
#define ARCHIVO_B3      "rom_b3.txt"

int main() {
    FILE *f_maestro, *f_b0, *f_b1, *f_b2, *f_b3;
    char line_buffer[32]; // Un buffer para leer cada línea (32 es más que suficiente)

    // 1. Abrir todos los archivos
    f_maestro = fopen(ARCHIVO_MAESTRO, "r");
    f_b0 = fopen(ARCHIVO_B0, "w");
    f_b1 = fopen(ARCHIVO_B1, "w");
    f_b2 = fopen(ARCHIVO_B2, "w");
    f_b3 = fopen(ARCHIVO_B3, "w");

    // 2. Verificar que todos los archivos se abrieron correctamente
    if (f_maestro == NULL || f_b0 == NULL || f_b1 == NULL || f_b2 == NULL || f_b3 == NULL) {
        perror("Error: No se pudo abrir uno o más archivos");
        // Cerrar los que sí se hayan abierto
        if (f_maestro) fclose(f_maestro);
        if (f_b0) fclose(f_b0);
        if (f_b1) fclose(f_b1);
        if (f_b2) fclose(f_b2);
        if (f_b3) fclose(f_b3);
        return 1; // Salir con código de error
    }

    // 3. Procesar el archivo maestro línea por línea
    while (fgets(line_buffer, sizeof(line_buffer), f_maestro) != NULL) {
        
        // Limpiar el salto de línea ('\n') que lee fgets
        line_buffer[strcspn(line_buffer, "\n")] = 0;

        // Validar que la línea tenga 8 caracteres (ej. AABBCCDD)
        if (strlen(line_buffer) == 8) {
            // Escribir los bytes en sus respectivos archivos
            // %.2s significa "imprime exactamente 2 caracteres de este string"
            
            // Byte 3 (bits 31-24) -> AABBCCDD
            fprintf(f_b3, "%.2s\n", &line_buffer[0]); // "AA"
            
            // Byte 2 (bits 23-16) -> AABBCCDD
            fprintf(f_b2, "%.2s\n", &line_buffer[2]); // "BB"
            
            // Byte 1 (bits 15-8)  -> AABBCCDD
            fprintf(f_b1, "%.2s\n", &line_buffer[4]); // "CC"
            
            // Byte 0 (bits 7-0)   -> AABBCCDD
            fprintf(f_b0, "%.2s\n", &line_buffer[6]); // "DD"
            
        } else if (strlen(line_buffer) > 0) {
            // Si la línea no está vacía pero no mide 8, avisar.
            fprintf(stderr, "Advertencia: Linea ignorada (longitud incorrecta): %s\n", line_buffer);
        }
    }

    // 4. Cerrar todos los archivos
    fclose(f_maestro);
    fclose(f_b0);
    fclose(f_b1);
    fclose(f_b2);
    fclose(f_b3);

    printf("Archivos ROM de 8 bits generados exitosamente desde %s.\n", ARCHIVO_MAESTRO);
    return 0;
}