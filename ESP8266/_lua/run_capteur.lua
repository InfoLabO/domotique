--gpio 0 => 3    
--gpio 1 => 10
--gpio 2 => 4
--gpio 3 => 9
--gpio 4 => 2
--gpio 5 => 1    CAPTEUR1
--gpio 12 => 6  STEP X
--gpio 13 => 7  DIRESTION
--gpio 14 => 5  STEP Y
--gpio 15 => 8
--gpio 16 => 0  SLEEP


writegpio = function(pin, value)
   tab = {[0]=3, [1] = 10, [2] = 4, [3] = 9, [4] = 2, [5]=1, [12]=6, [13] = 7,
          [14]=5,[15]=8,[16]=0}
   
   gpio.write(tab[pin], value)
end


  gpio.mode(0, gpio.OUTPUT)
  gpio.write(0, gpio.HIGH)

  gpio.mode(6, gpio.OUTPUT)
  gpio.mode(7, gpio.OUTPUT)
  gpio.mode(5, gpio.OUTPUT)

  gpio.mode(1, gpio.INPUT, gpio.PULLUP)

  gpio.write(4, gpio.HIGH)


  while true do

    if gpio.read(1)==0 then gpio.write(4, gpio.HIGH)
    else gpio.write(4, gpio.LOW) end
    --gpio.write(4, gpio.HIGH)
    --tmr.delay(1000000)
    --tmr.wdclr()
    --gpio.write(4, gpio.LOW)
    --tmr.delay(1000000)
    tmr.wdclr()
  
  end

    