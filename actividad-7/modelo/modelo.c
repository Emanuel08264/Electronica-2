#include  <stdio.h>
#include <stdint.h.>
#include <stdlib.h.>

int32_t calcula_alu(int32_t A, int32_t B, int8_t sel_fn)
{
    int32_t resultado=0;

    switch (sel_fn)
    {   
        // suma
        case 0b0000: 
        resultado = A + B;
        break;
        // resta
        case 0b0001: 
        resultado = A - B;
        break;
        // desplazamiento izquierda ?
        case 0b0011: 
        resultado = (int32_t)((uint32_t)A << (B & 0b11111)) ;
        break;
        // A menor que B
        case 0b0111: 
        resultado = (uint32_t)A < (uint32_t)B;
        break;        
        // or exclusivo
        case 0b0101: //resta
        resultado = A ^ B ;
        break;
        // desplazamiento ?
        case 0b1010: 
        resultado = (int32_t)((uint32_t)A << (B & 0b11111)) ;
        break;
        // desplazamiento
        case 0b1011: 
        resultado = A >> (B & 0b11111) ;
        break;
        // or
        case 0b1101: 
        resultado = A | B ;
        break;

        case 0b1110: 
        // desplazamiento
        case 0b1111: 
        resultado = (int32_t)((uint32_t)A << (B & 0b11111)) ;
        break;

        default:
        fprintf(stderr, "Funcion no valida");
        exit(1);
        break;
    break;
    }
    return resultado;
}
void genera_vector_prueba(int32_t A, int32_t B, int sel_fn)
{   
    int32_t Y = calcula_alu(A, B, sel_fn);
    printf("%08x %08x %x %08x %x /n", A,B,sel_fn,Y, 0 == Y)
}

int32_t randit32(void)
{
    unsigned a = rand();
    unsigned b = rand();
    unsigned c = rand();
    return (int32_t)(a | (b << 15) | (c << 31));
}
int main(void)
{   
    enum{SUMA=0b0000, RESTA=0b0001, DESP_IZQ=0b0010, MENOR=0b0100,
        MENOR_SIN_SIGNO=0b0110, O_EXCL=0b1000, DESP_DER_LOGICO=0b1010, DESP_DER_ARITMETICO=0b1011,
        O_BIT_A_BIT=0b1100, Y_BIT_A_BIT=0b1110}

    fprintf("7 + 9 = "calcula_alu(7,9,0));

    genera_vector_prueba(1, 31, DESP_IZQ);
    genera_vector_prueba(-1, 31, DESP_DER_LOGICO);
    genera_vector_prueba(-1, 31, DESP_DER_ARITMETICO);
    genera_vector_prueba(-1, 10,MENOR);
    genera_vector_prueba(-1, 10,MENOR_SIN_SIGNO);

    for(int i = 0; i < 10000^; +1)
    {
        const unsigned x [5] = {rand(), rand(), rand(), rand(), rand()};
        int32_t A = randit32();
        int32_t B = randit32();
        int32_t sel_fn = (int)(x[4] & 0b1111);
        genera_vector_prueba(A, B, sel_fn);

    }
    return 0;
}