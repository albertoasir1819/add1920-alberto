# Servidor de Impresión GNU/Linux (CUPS)


## 2. Servidor de Impresión

* systemctl status cups, para verificar que el servicio está en ejecución.

![1](img/1.png)

* A continuación, conectamos a la interfaz web de CUPS.

![2](img/2.png)


* Accedemos a la sección de **Administración**, y dentro de ahí a la parte de **Ver archivo de registro de accesos**.

![3](img/3.png)

## 3. Imprimir de forma local

* Hacemos una impresión local con el nombre imprimir17g-local.

![4](img/5.png)

* Comprobar el resultado. Los trabajos de impresión de la impresora virtual PDF se guardan en el directorio **/var/spool/cups-pdf/alberto17g**:

![5](img/6.png)

## 4. Imprimir de forma remota

* En el servidor habilitamos la impresora como recurso de red compartido.

![6](img/14.png)

![7](img/15.png)

![8](img/13.png)
Comprobamos desde el cliente que el puerto de impresora  de red (631) este abierto en el servidor.

* En el cliente configuramos la impresora de red.

![9](img/10.png)

* Hacemos una impresión de prueba (imprimir17g-remoto).

![10](img/12.png)

* Comprobamos en el servidor que se ha realizado la impresión remota.

![11](img/11.png)
