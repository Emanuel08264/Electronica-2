# ACTIVIDAD 8

## MEMORIAS

### SANTILLÁN ATILIO EMANUEL

### INGENIERÍA ELECTRÓNICA

### 2025

---

## RESUMEN

---

## INTRODUCCIÓN

### Memorias

Una memoria es una parte del sistema que almacena grandes cantidades de datos binarios. Se conforman de matrices de celdas de almacenamiento (latches o capacitores). En esta matriz, cada celda almacena 1 bit, y se organiza de la siguiente manera:

- Columna: el número de columnas nos indica el ancho de **palabra** (unidad completa de información). En la mayoría de aplicaciones trabajamos con palabras de 8 bits (1 byte), o múltiplos de la misma.
- Fila: Indican la **dirección** (_address_ en inglés) de cada palabra almacenada por la memoria.

A la cantidad de bits que puede almacenar una memoria la llamamos capacidad, y esta puede dividirse en distintos arreglos de filas y columnas. En la **Imagen 1** vemos un ejemplo de esto.

![Matriz de memoria](imagenes/matriz.png "Matriz de memoria")

**_Imagen 1_**

Las operaciones básicas que se pueden realizar en una memoria son la **lectura** y **escritura**.

### Operación de escritura:

Consiste en ingresar una cantidad de datos en una posición específica de la memoria. Para ello, se introduce en el **bus de direcciones** un código almacenado en el **registro de direcciones**, este se decodifica, y selecciona la posición de memoria. La memoria recibe entonces una orden de escritura y los datos almacenados en el **registro de datos** se introducen en el **bus de datos**, y se almacenan en la dirección de memoria especificada. En la **Imagen 2** se ilustra este proceso. Si se repite la operación, el nuevo byte de datos se sobre escribe sobre el anterior, y lo destruye.

![Operación de escritura](imagenes/escritura.png "Operación de escritura")

**_Imagen 2_**

### Operación de lectura:

Consiste en extraer una cantidad de datos de una posición específica de la memoria. Para ello, se introduce en el **bus de direcciones** un código almacenado en el **registro de direcciones**, este se decodifica, y selecciona la posición de memoria. La memoria recibe un orden de lectura y una copia del byte de datos almacenado en la dirección de memoria seleccionada se introduce en el **bus de datos** y se carga en el **registro de datos**.En la **Imagen 3** se ilustra este proceso. Si se repite la operación se conservan el byte almacenado, por lo que la operación de lectura es no destructiva.

![Operación de lectura](imagenes/lectura.png "Operación de lectura")

**_Imagen 3_**

### 1. Clasificación de memorias

Una memoria **RAM**, (_Random Access Memory_), se caracteriza por por demorar el mismo tiempo en acceder a cualquier dirección de memoria, y poder elegirla en cualquier orden, ya sea para lectura o escritura. Una particularidad que tienen, es que pierden la información al desconectar la fuente de alimentación, por lo que se las categoriza como volátiles. Estas se dividen en SRAM (_Static RAM_) y DRAM (_Dynamic RAM_)
Por otro lado, en las memorias **ROM**, (_Read Only Memory_), los datos se almacenan de forma permanente o semi permanente. Estas también son de acceso aleatorio, pero se solo se realizan operaciones de lectura. Además, estas mantienen los datos aun si se desconecta la alimentación por lo que se categorizan como no volátiles.

### 1.1 RAM Estática

Las memorias RAM estáticas se caracterizan por utilizar un latch como celda de memoria. Se llaman estáticas, pues cuando se aplica alimentación continua, la celda almacena el bit indefinidamente. En la **Figura 4** , vemos un circuito que simula el comportamiento de la celda de memoria (en la realidad se trata de un arreglo de 6 transistores). Este se constituye por un latch D, cuya habilitación de escritura (C) depende de las señales de control (SEL y WR). Por otro lado, a la salida del latch se conecta a un buffer tri-estado. Este buffer es el que pone el bit almacenado a la salida de la celda, y "abre el circuito" (se pone en Alta Impedancia o Hi-Z) si la celda no está seleccionada.

![SRAM_CELL](imagenes/sram_cell.png "SRAM_CELL")

**_Imagen 4_**

#### Arquitectura de la Matriz SRAM

Para organizar estas celdas individuales en un bloque de memoria funcional, se utiliza una arquitectura matricial como la que se ve en la **Imagen 5**.

![SRAM_MATRIX](imagenes/sram_matrix.png "SRAM_MATRIX")

**_Imagen 5_**

Esta estructura funciona de la siguiente manera:

<u>Decodificador de Direcciones:</u> El bloque de la izquierda (3-to-8 decoder) recibe las líneas de dirección (A0-A2). Su función es activar una sola línea de selección horizontal (word line o SEL) correspondiente a la dirección elegida.

<u>Matriz de Celdas:</u> Todas las celdas de la fila seleccionada (cuya entrada SEL está activa) se conectan a las líneas de datos verticales (bit lines). Las celdas de las filas no seleccionadas mantienen sus salidas en alta impedancia (Hi-Z), sin interferir.

<u>Lógica de Control:</u> Las compuertas NAND (abajo a la izquierda) combinan las señales maestras del chip (CS_L, WE_L, OE_L) para generar las señales internas que habilitan la escritura (WR_L) o la lectura (IOE_L).

<u>Buffers de Salida Tri-Estado:</u> Los buffers de la parte inferior (DOUT0-DOUT3) son controlados por la señal IOE_L (habilitación de salida). Solo si el chip está seleccionado (CS_L) y se está realizando una lectura (OE_L), estos buffers se activan y sacan el dato al bus externo. En cualquier otro caso, permanecen en Hi-Z, para que otros dispositivos puedan usarlo.

Las SRAM también se dividen en:

- Asíncronas: Las operaciones de lectura/escritura no están sincronizadas con el reloj.
- Síncronas de ráfaga: Utiliza registros con señal de reloj para sincronizar todas las entradas con el reloj del sistema.

### 1.2 RAM Dinámica

Una RAM dinámica se caracteriza por utilizar un capacitor y un MOSFET como celda de memoria. La simplicidad de su estructura permite fabricar memorias con una alta densidad de celdas en comparación a las SRAM. La desventaja que presenta es que no puede permanecer cargado un tiempo ilimitado, por la descarga del capacitor. Para solucionar esto, la memoria debe ser "_refrescada_" periódicamente. Como se debe pasar por este proceso, son más lentas que las SRAM.

![DRAM_CELL](imagenes/dram_cell.png "DRAM_CELL")

**_Imagen 6_**

En la **Imagen 6** podemos ver la estructura simplificada de la celda. El MOSFET actúa como un interruptor que, al activarse (controlado por word line), conecta el condensador a la bit line. En la operación de escritura un circuito de entrada pone el dato deseado en la línea: un nivel ALTO para un '1' carga el condensador, mientras que un nivel BAJO para un '0' lo descarga. Al desactivar la línea de fila, el transistor se "abre" y la carga (el '1' o '0') queda "atrapada" en el condensador.
La operación de lectura es más compleja y es destructiva: primero, la línea de bit se precarga a un voltaje intermedio; luego, al activar la word line, el condensador conectado "tira" (pulls) ligeramente de ese voltaje hacia arriba o abajo. Un Amplificador de Sentido (Sense Amplifier) detecta este minúsculo cambio, recupera el '1' o '0', e inmediatamente debe reescribir el valor sólido de nuevo en la celda, ya que la lectura vació la carga original. Este mismo mecanismo de leer y reescribir es el que se utiliza para el refresco: se lee el contenido (ya degradado) en un latch, y luego se reescribe un valor sólido desde ese latch de vuelta a la celda para restaurar su carga.

### 1.3 ROM de máscara

También denominadas simplemente ROM. La principal diferencia con las memorias antes descritas, es que en estas solo se realizan operaciones de lectura. Las celdas de estas memorias son básicamente un transistor. En la **Imagen 7** podemos ver el esquema de la celda. Estos almacenan un 1 si se conectan a la bit linea, o un 0 si están desconectados. Por ello, una vez que se programa la memoria esta no puede cambiarse. Las ROM puede utilizar tablas de búsqueda (LUT, Look-Up Table) para realizar conversiones de códigos y generación de función lógicas.

![ROM_CELL](imagenes/rom_cell.png "ROM_CELL")

**_Imagen 7_**

### 1.4 Memorias PROM

Las PROM funcionan de manera similar a las ROM, pero su contenido no es definido por el usuario, no en el proceso de fabricación. Las celdas que utiliza son hilos de memoria que se funde o queda intacto para representar un 0 o un 1. El proceso de fundición es irreversible; una vez que una PROM ha sido programada no puede cambiarse. En la **Imagen 8** podemos ver un arreglo de celdas para una memoria PROM.

![PROM_MATRIX](imagenes/prom_matrix.png "PROM_MATRIX")

**_Imagen 8_**

### 1.5 Memorias EPROM

Una memoria EPROM es básicamente una memoria PROM re programable. Una EPROM utiliza una matriz NMOSFET con una estructura de puerta aislada. La puerta del transistor aislada no tiene ninguna conexión eléctrica y puede almacenar una carga eléctrica durante un período de tiempo indefinido. Los bits de datos en este tipo de matriz se representan mediante la presencia o ausencia de una carga almacenada en la puerta. El borrado de un bit de datos es un proceso que elimina la carga de la puerta. De acuerdo a la manera en que realizan el borrado de datos se dividen en:

- UV EPROM: Se borran los bits almacenados exponiéndolos a luz ultra violeta.
- EEPROM: Se pueden borrar y programar mediante impulsos eléctricos.
  Ya que se pueden grabar y borrar eléctricamente, las EEPROM se pueden programar y borrar rápidamente
  dentro del propio circuito final con fines de reprogramación.

### 1.6 Memorias FLASH

Las memorias flash son memorias de lectura/escritura de alta densidad y no volátiles. Esta alta densidad se consigue en las memorias flash con una célula de almacenamiento compuesta por un único transistor MOS de puerta flotante.
Una memoria flash opera mediante tres acciones principales: programación, lectura y borrado.

<u>Programación:</u> Programar una celda es almacenar un '0'. Esto se hace aplicando un voltaje que atrae electrones en la "puerta flotante" de la celda. Las celdas que quedan sin carga representan un '1'.

<u>Lectura:</u> Se aplica un voltaje de prueba a la puerta de control.

- '1' (sin carga): El transistor se activa y la corriente fluye.

- '0' (con carga): La carga negativa bloquea el voltaje, el transistor no se activa y no hay corriente. Un comparador detecta esta presencia o ausencia de corriente.

<u>Borrado:</u> Es el proceso de eliminar la carga de todas las celdas para devolverlas al estado '1'. Se aplica un voltaje opuesto al de programación que "repele" y expulsa los electrones de la puerta flotante.

![FLASH_MATRIX](imagenes/flash_matrix.png "FLASH_MATRIX")

**_Imagen 9_**

La **Imagen 9** muestra una matriz simplificada de células de memoria flash. Cuando una celda de una línea de bit dada se activa (un 1 almacenado) durante una operación de lectura, existirá corriente a través de la línea de bit, lo que producirá una caída de tensión a través de la carga activa. Esta caída de tensión se compara con una tensión de referencia mediante un circuito comparador, generándose un nivel de salida que indica que hay un 1. Si hay un 0 almacenado, no hay corriente en la línea de bit o ésta es muy pequeña, generándose un nivel opuesto a la salida del comparador.

### 2. Aplicaciones de los arreglos de memoria en los sistemas de cómputo

En los sistemas de computo, no se utiliza un solo tipo de memoria, cada una es ideal para un trabajo específico basado en su velocidad, costo y densidad (tamaño).

### 2.1 Conjunto de registros

Un conjunto de registros (register file) es un pequeño grupo de registros de alta velocidad que el procesador usa para almacenar las variables temporales con las que está trabajando activamente.

En lugar de usar flip-flops individuales, se construye como un pequeño arreglo de memoria SRAM porque es una solución más compacta.

Su característica más importante es que es "multiportado", lo que significa que tiene varias "puertas" de acceso que funcionan a la vez. Un diseño típico, como el de 32 registros de 32 bits, tiene tres puertos:

- Dos puertos independientes para Lectura (con sus propias direcciones, A1 y A2).

- Un puerto independiente para Escritura (con su propia dirección, A3).

![REGISTER FILE](imagenes/register_file.png "REGISTER FILE")

**_Imagen 10_**

La ventaja de esta estructura es que el procesador puede, por ejemplo, leer dos registros (como 'A' y 'B') y escribir el resultado de una operación (como 'A+B') en un tercer registro, todo simultáneamente en el mismo ciclo de reloj.

### 2.2 Memoria Cache

Una de las principales aplicaciones de las memorias SRAM es la implementación de memorias caché en computadoras. La memoria caché es una memoria de alta velocidad y relativamente pequeña que almacena los datos o instrucciones más recientemente utilizados de la memoria principal. Permite que el procesador pueda acceder a la información almacenada, mucho mas rápido que si recurriese a la memoria principal.
Funciona de la siguiente manera: Una unidad lógica de la computadora llamado "Controlador de cache", realiza una estimación de que direcciones de la memoria principal solicitará el procesador, y mueve el contenido de dichas direcciones a la memoria cache. Si la estimación fue correcta, el procesador tendrá los datos instantáneamente, sino, demorará un tiempo mas hasta rescatarlos de la memoria principal. La **Imagen 11** es un esquema de como se comunican estas memorias. L1 y L2 son ambas memorias caché, pero la diferencia es el orden de prioridad o urgencia de los datos almacenados.

![CACHE](imagenes/cache.png "CACHE")

**_Imagen 11_**

### 2.3 Memoria principal

Esta es la memoria de trabajo principal del sistema (por ejemplo, los 8 GB o 16 GB de RAM en una computadora). La tecnología utilizada casi exclusivamente para esta aplicación es la DRAM. Esto permite una alta densidad de almacenamiento, logrando grandes capacidades a un bajo costo por bit. Aunque la DRAM es más lenta que la SRAM (lo que justifica la existencia de la caché) y es volátil (requiere refresco y pierde datos sin energía), su alta capacidad y bajo costo la hacen la opción ideal para la memoria principal del sistema.

### 2.4 Memoria de almacenamiento

La memoria de almacenamiento se utiliza para guardar datos a largo plazo. La tecnología principal para esta aplicación es la Memoria FLASH. La característica fundamental que la hace ideal para el almacenamiento es su no volatilidad: a diferencia de SRAM y DRAM, la memoria FLASH retiene los datos permanentemente, incluso cuando se desconecta la fuente de alimentación. Aquí se guardan el sistema operativo, las aplicaciones y los archivos del usuario.

### 3. Memorias en FPGAs Lattice iCE40

Para este trabajo práctico, se utilizará la FPGA Lattice iCE40. El trabajo exige específicamente usar "elementos BRAM".

Según la guía de uso de memoria para estos dispositivos (Memory Usage Guide for iCE40 Devices), estos bloques de memoria dedicados se llaman sysMEM™ Embedded Block RAM (EBR).Las características clave de estos bloques BRAM son:

**Capacidad:** Cada bloque BRAM individual tiene una capacidad total de 4k bits (4096 bits).

**Puertos y Sincronismo:** Son memorias síncronas y pueden configurarse con dos puertos de acceso independientes. Esta es la configuración "True Dual-Port" (TDP), que permite dos operaciones (lectura o escritura) simultáneas e independientes.

**Organización:** Cada bloque de 4k puede organizarse en diferentes configuraciones de ancho y profundidad, como $4096 \times 1$, $2048 \times 2$, $1024 \times 4$, $512 \times 8$, o $256 \times 16$.

Esta información es crucial, ya que define cómo se deben implementar los componentes solicitados en el práctico:

**Memorias de $512 \times 32$ (Objetivos 6 y 7):** Dado que un BRAM solo puede configurarse como $512 \times 8$ como máximo, para lograr la memoria de $512 \times 32$ bits será necesario instanciar cuatro bloques BRAM en paralelo.

**Conjunto de Registros de $32 \times 32$ (Objetivo 8):** El práctico solicita un conjunto de registros con tres puertos (dos de lectura y uno de escritura). Sin embargo, los bloques BRAM de la iCE40 solo soportan un máximo de dos puertos (True Dual-Port). Por lo tanto, este componente no podrá ser implementado en los bloques BRAM, sino que deberá ser descrito en VHDL de forma que el sintetizador lo construya usando la lógica distribuida de la FPGA (es decir, con flip-flops).

---

## MATERIALES Y MÉTODOS

---

## RESULTADOS

---

## CONCLUSIÓN

---

## REFERENCIAS

---
