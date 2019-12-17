#!/usr/bin/env ruby

puts "
-------------------------------------------------------
       1. Aula 109 estática
       2. Resetear
       3. Casa estática
       4. DHCP
-------------------------------------------------------
      "
option = gets.chop
if option == "1"
  system("sudo cp ip-aula109 /etc/sysconfig/network/ifcfg-eth0")  
  system("sudo ifdown eth0")
  system("sudo ifup eth0") 	
elsif option == "2"
  system("sudo ifdown eth0")
  system("sudo ifup eth0") 
elsif option == "3"
  system("sudo cp ip-casa /etc/sysconfig/network/ifcfg-eth0")
  system("sudo ifdown eth0")
  system("sudo ifup eth0")
elsif option == "4"
  system("sudo cp dhcp /etc/sysconfig/network/ifcfg-eth0")
  system("sudo ifdown eth0")
  system("sudo ifup eth0")
end
