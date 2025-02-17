#include <stdio.h>
#include <math.h>

double raiz_n(double numero, int exponente, double precision) {
    if (exponente == 0) {
        printf("El exponente no puede ser cero.\n");
        return -1; 
    }
    
    double approx = numero / 2.0;
    double error = 1.0;
    
    while (error > precision) {
        double potencia = 1.0;
        for (int i = 0; i < exponente; i++) {
            potencia *= approx;
        }
        
        double derivada = exponente;
        for (int i = 1; i < exponente; i++) {
            derivada *= approx;
        }
        
        error = fabs(potencia - numero);
        approx = approx - (potencia - numero) / derivada;
    }
    
    return approx;
}

int main() {
    double numero;
    int exponente;
    double precision = 1e-6;
    
    printf("Ingrese el número: ");
    scanf("%lf", &numero);
    printf("Ingrese el exponente: ");
    scanf("%d", &exponente);
    
    double resultado = raiz_n(numero, exponente, precision);
    
    if (resultado != -1) {
        printf("El resultado es: %lf\n", resultado);
    }
    
    return 0;
}