# 1. Salt-stack

Hay varias herramientas conocidas del tipo gestor de infrastructura como Puppet, Chef y Ansible. En esta actividad vamos a practicar Salt-stack con OpenSUSE.

# 2. Preparativos

![](img/2.png)

# 3. Master: instalar y configurar.

* Vamos a la MV1

* `zypper install salt-master`, instalar el software del master.

![](img/3.1.png)

* Modificar `/etc/salt/master` para configurar nuestro master con:
```
interface: 172.19.17.31
file_roots:
  base:
    - /srv/salt
```

![](img/3.2.png)

* `systemctl enable salt-master.service`, activiar servicio en el arranque del sistema.

![](img/3.3.png)

* `systemctl start salt-master.service`, iniciar servicio.

![](img/3.4.png)

* `salt-key -L`, para consultar Minions aceptados por nuestro Máster. Vemos que no hay ninguno todavía.
```
Accepted Keys:
Denied Keys:
Unaccepted Keys:
Rejected Keys:
```
![](img/3.5.png)

# 4. Minion

Los Minios son los equipos que van a estar bajo el control del Máster.

## 4.1 Instalación y configuración

* `zypper install salt-minion`, instalar el software del agente (minion).

![](img/4.1.1.png)

* Modificar `/etc/salt/minion` para definir quien será nuestro Máster:
```
master: 172.19.17.31
```

![](img/4.1.2.png)


* `systemctl enable salt-minion.service`, activar Minion en el arranque del sistema.

![](img/4.1.3.png)

* `systemctl start salt-minion.service`, iniciar el servico del Minion.

![](img/4.1.4.png)

* Comprobar que  que no tenemos instalado `apache2` en el Minion.

![](img/4.1.5.png)

## 4.2 Aceptación desde el Master

* Ir a la MV1 Máster.

* Hay que asegurarse de que el cortafuegos permite las conexiones al servicio Salt.


![](img/4.2.1.png)


## 4.3 Aceptación desde el Master

Ir a MV1:
* `salt-key -L`, vemos que el Máster recibe petición del Minion.
```
Accepted Keys:
Denied Keys:
Unaccepted Keys:
minionXXg
Rejected Keys:
```
![](img/4.3.1.png)

* `salt-key -a minionXXg`, para que el Máster acepte a dicho Minion.

![](img/4.3.2.png)

* `salt-key -L`, comprobamos.

![](img/4.3.3.png)

## 4.3 Comprobamos conectividad

Comprobamos la conectividad desde el Máster a los Minions.
```
# salt '*' test.version
minionXXg:
    2019.2.0
# salt '*' test.ping
minionXXg:
    True
```

![](img/4.3.4.png)

![](img/4.3.5.png)

> El símbolo `'*'` representa a todos los minions aceptados. Se puede especificar un minion o conjunto de minios concretos.


# 5. Salt States

## 5.1 Preparar el directorio para los estados

Vamos a crear directorios para guardar lo estados de Salt. Los estados de Salt son definiciones de cómo queremos que estén nuestras máquinas.

Ir al Máster:
* Crear directorios `/srv/salt/base` y `/srv/salt/dev`.

![](img/5.1.1.png)


* Crear archivo `/etc/salt/master.d/roots.conf` con el siguiente contenido:
```
file_roots:
  base:
    - /srv/salt/base
  devel:
    - /srv/salt/devel
```
![](img/5.1.2.png)

![](img/5.1.3.png)

* Reiniciar el servicio del Máster.

![](img/5.1.4.png)

Hemos creado dos directorios:
* base = para guardar nuestros estados.
* devel = para desarrollo o para hacer pruebas.

## 5.2 Crear un nuevo estado

Los estados de Salt se definen en ficheros SLS.
* Crear fichero `/srv/salt/base/apache/init.sls`:

```
install_apache:
  pkg.installed:
    - pkgs:
      - apache2

apache_service:
  service.running:
    - name: apache2
    - enable: True
```
![](img/5.2.1.png)

![](img/5.2.2.png)

Entendamos las definiciones:
* La primera línea es un identificador (ID) del estado.
* `pkg.installed`: se asegura que el paquete esté instalado.
* `service.running`: se asegura de que el servicio esté iniciado.
* `require`: Establece como requisito de que el servicio se inicia después de la instalación del paquete "apache2".

## 5.3 Asociar Minions a estados

Ir al Master:
* Crear `/srv/salt/base/top.sls`, donde asociamos a todos los Minions con el estado que acabamos de definir.

```
base:       
  '*':
    - ap
```

![](img/5.3.1.png)

![](img/5.3.2.png)

* `salt '*' state.show_states`, consultar los estados que tenemos:
```
minionXXg:
    - apache
```
![](img/5.3.3.png)


## 5.4 Aplicar el nuevo estado

Ir al Master:
* Consultar los estados en detalle y verificar que no hay errores en las definiciones.
    * `salt '*' state.show_lowstate`

![](img/5.4.1.png)

    * `salt '*' state.show_highstate`,

![](img/5.4.2.png)

* `salt '*' state.apply apache`, para aplicar el nuevo estado en todos los minions. OJO: Esta acción puede tardar un tiempo.

```
minionXXg:
----------
          ID: install_apache
    Function: pkg.installed
      Result: True
     Comment: The following packages were installed/updated: apache2
              ...
----------
          ID: apache_service
    Function: service.running
        Name: apache2
      Result: True
     Comment: Service apache2 has been enabled, and is running
              ...

Summary for minionXXg
------------
Succeeded: 2 (changed=2)
Failed:    0
------------
Total states run:     2
Total run time: 105.971 s
```

![](img/5.4.3.png)

![](img/5.4.4.png)

> NOTA: Con este comando `salt '*' state.highstate`, también se pueden invocar todos los estados.

# 6. Crear más estados

## 6.1 Crear estado "users"

Vamos a crear un estado llamado `users` que nos servirá para crear un grupo y usuarios en las máquinas Minions.

* Crear directorio `/srv/salt/base/users`.

![](img/6.1.1.png)

* Crear fichero `/srv/salt/base/users/init.sls` con las definiones para crear los siguiente:
    * Grupo `mazingerz`
    * Usuarios `kojiXX`, `drinfiernoXX` dentro de dicho grupo.

![](img/6.1.3.png)

![](img/6.1.2.png)
    
* Aplicar el estado.

![](img/6.1.4.png)

## 6.2 Crear estado "directories"

* Crear estado `drectories` para crear las carpetas `private` (700), `public` (755) y `group` (750) en el home del usuario `koji`.

![](img/6.2.1.png)

![](img/6.2.2.png)

* Aplicar el estado.

![](img/6.2.3.png)

Comprobamos con el usuario koji17 que se han creado las carpetas:

![](img/6.1.5.png)

![](img/6.2.4.png)

# 7. Añadir Minion de otro SO

* Crear MV3 con SO Windows (minion17w)

![](img/7.7.png)

* Instalar `salt-minion`.

Añadimos al archivo de hosts de windows el master17g:

![](img/7.4.png)

Instalamos el servicio:

![](img/7.1.png)

![](img/7.2.png)


 * Agregamos al máster el minion17w.

![](img/7.5.png)

![](img/7.6.png)

