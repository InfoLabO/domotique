gpio.mode(3, gpio.INPUT)
gpio.mode(4, gpio.OUTPUT)
gpio.write(4, gpio.HIGH)
tmr.delay(2000000)   -- wait 2,000,000 us = 2 second
gpio.write(4, gpio.LOW)
if(gpio.read(3)==0) then os.exit(nil) end

dofile("run.lua")
