# Vagrant con VirtualBox

## 3.3 MV: Levantar y entrar

Vamos a crear una MV nueva y la vamos a iniciar usando Vagrant:

  * Debemos estar dentro de vagrant17-proyecto1.

  * vagrant up, para iniciar una nueva instancia de la máquina.

    ![](img/1.1.png)

  * vagrant ssh: Conectar/entrar en nuestra máquina virtual usando SSH.

  ![](img/1.2.png)

## 5.2 Comprobamos proyecto 2

Para confirmar que hay un servicio a la escucha en 4567, desde la máquina real podemos ejecutar los siguientes comandos:

* En el HOST-CON-VAGRANT (Máquina real). Comprobaremos que el puerto 4567 está a la escucha.

  * vagrant port para ver la redirección de puertos de la máquina Vagrant.

    ![](img/2.1.png)

* En HOST-CON-VAGRANT, abrimos el navegador web con el URL http://127.0.0.1:4567. En realidad estamos accediendo al puerto 80 de nuestro sistema virtualizado.

  ![](img/2.3.png)


## 6.1 Proyecto 3 (Suministro mediante shell script)

Ahora vamos a suministrar a la MV un pequeño script para instalar Apache.
* Crear directorio `vagrant17-proyecto3` y dentro un proyecto Vagrant.

  ![](img/6.1.1.png)

* Crear fichero html/index.html con el siguiente contenido:

  ![](img/6.1.2.png)

* Crear el script `install_apache.sh`, dentro del proyecto con el siguiente
contenido:

```
#!/usr/bin/env bash

apt-get update
apt-get install -y apache2

```

  ![](img/6.1.3.png)

  ![](img/6.1.4.png)


Incluir en el fichero de configuración Vagrantfile lo siguiente:

  * config.vm.provision :shell, :path => "install_apache.sh", para indicar a Vagrant que debe ejecutar el script install_apache.sh dentro del entorno virtual.

  * config.vm.synced_folder "html", "/var/www/html", para sincronizar la carpeta exterior html con la carpeta interior. De esta forma el fichero "index.html" será visible dentro de la MV.

  ![](img/6.1.7.png)

  * vagrant up, para crear la MV.

    ![](img/6.1.8.png)

      * Podremos notar, al iniciar la máquina, que en los mensajes de salida se muestran mensajes que indican cómo se va instalando el paquete de Apache que indicamos.


  * Para verificar que efectivamente el servidor Apache ha sido instalado e iniciado, abrimos navegador en la máquina real con URL http://127.0.0.1:4567.

  ![](img/6.1.9.png)


## 6.2 Proyecto 4 (Suministro mediante Puppet)

Se pide hacer lo siguiente.

  * Crear directorio vagrant17-proyecto4 como nuevo proyecto Vagrant.

  * Modificar el archivo Vagrantfile de la siguiente forma:
```
Vagrant.configure(2) do |config|
  ...
  config.vm.provision "shell", inline: "sudo apt-get update && sudo apt-get install -y puppet"

  config.vm.provision "puppet" do |puppet|
    puppet.manifest_file = "alberto17.pp"
  end
 end
```
  ![](img/6.2.2.png)

  ![](img/6.2.1.png)

* Ahora hay que crear el fichero manifests/alberto17.pp, con las órdenes/instrucciones Puppet para instalar el programa PACKAGENAME. Ejemplo:

```
package { 'PACKAGENAME':
  ensure => 'present',
}
```

  ![](img/6.2.9.png)

Para que se apliquen los cambios de configuración:

Con la MV encendida

  * vagrant reload, recargar la configuración.

  ![](img/6.2.8.png)

  * vagrant provision, volver a ejecutar la provisión.

  ![](img/6.2.10.png)

## 7.2 Crear caja Vagrant

Una vez hemos preparado la máquina virtual ya podemos crear el box.

  * Vamos a crear una nueva carpeta vagrant17-bulls, para este nuevo proyecto vagrant.

    ![](img/7.2.1.png)

  * VBoxManage list vms, comando de VirtualBox que muestra los nombres de nuestras MVs. Elegiar una de las máquinas (VMNAME).

    ![](img/7.2.2.png)

  * Nos aseguramos que la MV de VirtualBox VMNAME está apagada.

  * vagrant package --base VMNAME package.box, parar crear nuestra propia caja.

    ![](img/7.2.3.png)

  * Comprobamos que se ha creado el fichero package.box en el directorio donde hemos ejecutado el comando.

    ![](img/7.2.4.png)

  * vagrant box add alberto17/bulls package.box, añadimos la nueva caja creada por nosotros, al repositorio local de cajas vagrant de nuestra máquina.

    ![](img/7.2.5.png)

  * vagrant box list, consultar ahora la lista de cajas Vagrant disponibles.

    ![](img/7.2.6.png)
