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

    gpio.write(4, gpio.HIGH)

    while gpio.read(1) == 1 do
        
        gpio.write(7, gpio.HIGH)
        gpio.write(6, gpio.HIGH)
        gpio.write(6, gpio.LOW)
        
        gpio.write(7, gpio.LOW)
        gpio.write(5, gpio.HIGH)
        gpio.write(5, gpio.LOW)
        tmr.delay(20000)
        tmr.wdclr()
    end

    gpio.write(4, gpio.LOW)
    for i=0,48,1 do        
        gpio.write(7, gpio.HIGH)
        gpio.write(6, gpio.HIGH)
        gpio.write(6, gpio.LOW)
        gpio.write(5, gpio.HIGH)
        gpio.write(5, gpio.LOW)
        tmr.delay(20000)
        tmr.wdclr()        
    end
  
  end