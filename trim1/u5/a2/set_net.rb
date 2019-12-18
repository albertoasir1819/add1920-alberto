#!/usr/bin/env ruby

require 'colorize'

puts "
-------------------------------------------------------
       1. Aula 109 estática
       2. Resetear
       3. Casa estática
       4. DHCP
       5. Refresh DHCP
-------------------------------------------------------
Press Enter to exit
      "

def reset
  system("sudo ifdown eth0")
  system("sudo ifup eth0")
end

option = gets.chop
if option == "1"
  system("sudo cp ip-aula109 /etc/sysconfig/network/ifcfg-eth0")
  puts "Configurando...".colorize(:green)
  reset
elsif option == "2"
  reset
elsif option == "3"
  system("sudo cp ip-casa /etc/sysconfig/network/ifcfg-eth0")
  puts "Configurando...".colorize(:green)
  reset
elsif option == "4"
  system("sudo cp dhcp /etc/sysconfig/network/ifcfg-eth0")
  puts "Configurando...".colorize(:green)
  reset
elsif option == "5"
  system("sudo dhclient -r eth0")
  puts "Configurando...".colorize(:green)
end
