# ACTIVIDAD 7

## UNIDAD ARITMÉTICA LÓGICA

### SANTILLAN, ATILIO EMANUEL

### INGENIERÍA ELECTRÓNICA

### 2025

---

## RESUMEN

En este informe se detalla el diseño, validación e implementación de una Unidad Aritmética Lógica (ALU) genérica en VHDL. Primero, la ALU se validó contra un "Golden Model" de referencia en C, superando exitosamente un banco de pruebas automático de más de 10,000 vectores. Posteriormente, esta ALU se instanció (W=4) como el núcleo de una calculadora de 4 bits para la placa edu-ciaa-fpga. El sistema completo, que incluye registros, detectores de flanco y un decodificador de 7 segmentos, fue sintetizado y probado en hardware, demostrando un funcionamiento correcto que cumple con todas las especificaciones.

---

## 1. INTRODUCCIÓN

Se desea diseñar una calculadora que cumpla con las siguientes especificaciones.

- Carga de los números de 4 bits A y B.
- Se debe poder seleccionar la función a realizar entre A y B.
- Al número A se le asigna el resultado de la operación.
- Las funciones que debe realizar son:
  - Suma
  - Resta
  - Desplazamiento lógico izquierda
  - Menor con signo
  - Menor sin signo
  - Desplazamiento aritmético derecha
  - Desplazamiento lógico derecha
  - OR exclusivo bit a bit
  - OR bit a bit
  - AND bit a bit
- Para las operaciones _suma, resta, desplazamiento lógico izquierda y menor con signo_ el código de entrada se interpreta como **complemento a 2**, mientras que para las demás funciones como **binario natural**.
- Los dispositivos de entrada a utilizar serán 8 interruptores.
- El dispositivo de salida será un display de 7 segmentos.
- El código de salida será **hexadecimal**.

---

## 2. DESARROLLO

Para el desarrollo de la calculadora, el diseño se dividió en los siguientes módulos:

### 2.1. Diseño de la ALU (`alu.vhd`)

La ALU se implementó como una entidad VHDL genérica (`generic (W : positive)`). Para la lógica principal, se usó un proceso combinacional (`process(all)`) con una sentencia `case` que se activa según la entrada `sel_fn` para elegir qué operación realizar. Los códigos de sel_fn para cada función a implementar se detallan en la Tabla 1.
![Funciones ALU](imagenes/funciones_alu.png "Funciones de la ALU")
\_Tabla 1: Funciones ALU\*

Para manejar correctamente las operaciones aritméticas, se crearon señales auxiliares: `SA` y `SB` (para signed) y `UA` y `UB` (para unsigned). Esto permite convertir las entradas A y B al tipo de dato correcto (con o sin signo) según la operación que se estuviera realizando. Por ejemplo, usé SA+SB para la suma, UA < UB para la comparación sin signo, y shift_right(SA,...) para el desplazamiento aritmético.

Finalmente, la salida Z se implementó para que reporte '1' cuando el resultado Y es completamente cero.

### 2.2. TestBench de la ALU (`alu_tb.vhd`)

Para validar la ALU, primero se desarrolló un "Golden Model" en lenguaje C. Este modelo replica el comportamiento exacto de la Tabla 1. Este programa se utilizó para generar un archivo de texto (`alu_tb_datos.txt`) con más de 10,000 vectores de prueba (A, B, sel_fn, esperado_Y, esperado_Z).

Se creó un banco de pruebas (`alu_tb.vhd`) que instancia la ALU con `W=32`. Este testbench utiliza las librerías `std.textio.all` para leer el archivo `alu_tb_datos.txt` línea por línea.
En cada ciclo, el testbench:

1.  Lee los estímulos (A, B, sel_fn) y los resultados esperados (esperado_Y, esperado_Z).
2.  Aplica los estímulos a la ALU.
3.  Compara las salidas `Y` y `Z` del DUT con los valores esperados usando `assert`, reportando un error en caso de que no sean iguales.

En la Imagen 1, se puede observar el procedimiento seguido para la detección de errores.

![Golden Model](imagenes/golden_model.png "Golden Model")
_Imagen 1: Golden Model_

### 2.3. Diseño de la Calculadora

La calculadora de 4 bits se implementó conectando varios módulos VHDL:

- `top.vhd`: Es el módulo que conecta todos los componentes a los pines de entrada (`clk`, `X(7..0)`) y salida (`display(7..0)`) de la FPGA.
- `calculadora.vhd`: Instancia la ALU (`W=4`), los detectores de flanco, y contiene los dos registros `a_act` y `b_act`. Un proceso combinacional (`LES`) implementa la lógica de estado siguiente (para `a_sig` y `b_sig`) y el multiplexor de salida (para `salida_sel`), basándose en las señales de los interruptores y los pulsos de los detectores de flanco.
- `rise_detect.vhd`: Módulo secuencial (con dos flip-flops) que recibe una entrada de interruptor y genera un pulso de un solo ciclo de reloj (`rise_sel`) al detectar un flanco ascendente. Esto sirve para que la carga de registros ocurra solo una vez por pulsación.
- `siete_seg.vhd`: Un decodificador combinacional que convierte un número de 4 bits (`0`-`F`) en los 7 bits necesarios para activar el display en hexadecimal.

---

## 3. RESULTADOS

### 3.1. Simulación de la ALU

La simulación de la ALU (alu*tb) contra el Golden Model de C fue exitosa. Como puede observarse en la **Imagen 2** banco de pruebas procesó 10,000 vectores de prueba sin reportar ningún severity error. Esto valida que el diseño VHDL de la ALU es lógicamente correcto y cumple con todas las especificaciones de la Tabla 1.
![LOG_ALU](imagenes/log_alu.png "LOG_ALU")
\_Imagen 2: Archivo LOG ALU*

### 3.2. Implementación en Hardware

Como no se realizó un banco de pruebas para calculadora, las pruebas de los resultados se hizo directamente sobre la FPGA. El diseño completo (ALU, calculadora, y periféricos) se implementó con éxito. El sistema es funcional y opera como se espera: los registros A y B se cargan correctamente al detectar el flanco ascendente de los interruptores, la ALU recibe los operandos y el `sel_fn`, y el resultado se visualiza correctamente en el display de 7 segmentos.

---

## 4. CONCLUSIONES

El desarrollo de esta actividad permitió adquirir un primer contacto con una ALU como componente central de un sistema de procesamiento. Por otro lado, el enfoque de diseño genérico, permitió que la misma entidad alu.vhd se probara en un entorno de simulación (con W=32) y luego se instanciara fácilmente en un diseño de hardware (con W=4).
El diseño jerárquico (separando la ALU, los detectores de flanco, los registros y el decodificador) simplificó la detección de errores: la ALU se validó de forma aislada antes de integrarla, y los problemas pudieron rastrearse a la lógica de control (calculadora.vhd) o a los módulos secundarios (siete_seg.vhd) de forma independiente.

---

## REFERENCIAS

_Syncad. (s.f.). Golden reference models. Recuperado el 5 de noviembre de 2025, de https://www.syncad.com/web_manual_testbencher/test_bench_generator_main_index.html?golden_reference_models.htm_
