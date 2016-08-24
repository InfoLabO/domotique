--gpio 0 => 3    
--gpio 1 => 10
--gpio 2 => 4
--gpio 3 => 9
--gpio 4 => 2
--gpio 5 => 1    CAPTEUR1
--gpio 9 => 11
--gpio 10 =>12
--gpio 12 => 6  STEP X
--gpio 13 => 7  DIRESTION
--gpio 14 => 5  STEP Y
--gpio 15 => 8
--gpio 16 => 0  SLEEP

--initialisation du SPI
gpio.mode(11, gpio.OUTPUT)
gpio.mode(12, gpio.OUTPUT)
gpio.write(11, gpio.HIGH)
gpio.write(12, gpio.HIGH)

--SPI = 0
--HSPI = 1
spi.setup(1, spi.MASTER, spi.CPOL_LOW, spi.CPHA_LOW, 8, 0)

write_ioexp = function(adr, value)
end

read_ioexp = function(adr) 
   return 562
end

writegpio = function(pin, value)
   tab = {[0]=3, [1] = 10, [2] = 4, [3] = 9, [4] = 2, [5]=1, [12]=6, [13] = 7,
          [14]=5,[15]=8,[16]=0}
   
   gpio.write(tab[pin], value)
end

gpio.write(4, gpio.HIGH)

while true do
 
    if (read_ioexp(5) == 562) then
      gpio.write(4, gpio.LOW)
    end
    tmr.wdclr() 
