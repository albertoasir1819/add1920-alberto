#!/usr/bin/env ruby

require 'telegram/bot'

# token:
# 1. Write your TOKEN value into "token" variable or
# 2. Create a local file "hiden.token" with your TOKEN value inside
token = `cat hide.token`.strip
bot_username = '@alberto17_bot'

puts "[INFO] Running bot #{$0}..."

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    puts " => #{message.text}"
    if message.text == "/hello"
      bot.api.send_message(chat_id: message.chat.id, text: "Hello 
Word!")
    elsif message.text == "/byebye"
      bot.api.send_message(chat_id: message.chat.id, text: "Bye bye!")
    elsif message.text == "/whoami"
      whoami = `whoami`
      bot.api.send_message(chat_id: message.chat.id, text: whoami)
    elsif message.text == "/ip"
      ip = `ip a | grep inet | grep eth0`.split
      bot.api.send_message(chat_id: message.chat.id, text:"Tiene 
asignada la ip #{ip[1]}" )
    elsif message.text == "/apache_status"
      apache = `systemctl status apache2 | grep active`.split
      bot.api.send_message(chat_id: message.chat.id, text:"Estado 
Apache: #{apache[1]}" )
      #exit
    end
  end
end