# Servicio de comunicaciones con Telegram (bot-service)

## 1.4 Entrega

 - Script del bot (/usr/local/bin/bot17d)

    ```
    #!/usr/bin/env ruby

    require 'telegram/bot'

    # token:
    # 1. Write your TOKEN value into "token" variable or
    # 2. Create a local file "hiden.token" with your TOKEN value inside
    token = `cat /usr/local/bin/hide.token`.strip
    bot_username = '@alberto17_bot'

    puts "[INFO] Running bot #{$0}..."

    Telegram::Bot::Client.run(token) do |bot|
      bot.listen do |message|
        puts " => #{message.text}"
        if message.text == "/hello"
          bot.api.send_message(chat_id: message.chat.id, text: "Hello Word!")
        elsif message.text == "/byebye"
          bot.api.send_message(chat_id: message.chat.id, text: "Bye bye!")
        elsif message.text == "/whoami"
          whoami = `whoami`
          bot.api.send_message(chat_id: message.chat.id, text: whoami)
        elsif message.text == "/ip"
          ip = `ip a | grep inet | grep eth0`.split
          bot.api.send_message(chat_id: message.chat.id, text:"Tiene asignada la ip #{ip[1]}" )
        elsif message.text == "/apache_status"
          apache = `systemctl status apache2 | grep active`.split
          bot.api.send_message(chat_id: message.chat.id, text:"Estado Apache: #{apache[1]}" )
        elsif message.text == "/disk"
          space = `df -hT`
          bot.api.send_message(chat_id: message.chat.id, text:"Estado espacio: #{space}" )
        end
      end
    end

    ```

 - Funcionamiento del Bot en video.

 [![](http://img.youtube.com/vi/nWos_zmSHvc/0.jpg)](http://www.youtube.com/watch?v=nWos_zmSHvc "Bot_Telegram")

## 2.4 Entrega

  - Fichero de configuración del servicio /etc/systemd/system/bot17.service.

      ```
      [Unit]
      Description=Servicio Bot del alumno17.
      After=network.service

      [Service]
      Type=simple
      ExecStart=/usr/bin/ruby /usr/local/bin/bot17d

      [Install]
      WantedBy=multi-user.target

      ```

  - Capturas de pantalla donde se muestra que podemos iniciar y parar el servicio bot17 con el comando systemctl.

  Paramos el servicio:

  ![](/img/5.png)

  Arrancamos el servicio:

  ![](/img/6.png)

## 3.2 Tareas programadas

  - ```crontab -l```, vemos que no hay ninguna configuración creada.

    ![](/img/1.png)


  - ```crontab -e```, se nos abre un editor.

    ![](/img/7.png)

  - Pulsamos i(insert) y añadimos una configuración programa una ejecución del script cada 5 minutos:

    ![](/img/2.png)  

  - ```crontab -l```, para consultar la tarea programada.

      ![](/img/8.png)

  - Paramos el servicio.

      ![](/img/3.png)

  - Esperamos 5 minutos y ahora debe haberse iniciado de forma automática (con crontab):

      ![](/img/4.png)
