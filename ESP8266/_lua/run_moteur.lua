--gpio 0 => 3    
--gpio 1 => 10
--gpio 2 => 4 DIRESTION
--gpio 3 => 9
--gpio 4 => 2 STEP R
--gpio 5 => 1 STEP L
--gpio 12 => 6
--gpio 13 => 7 
--gpio 14 => 5 
--gpio 15 => 8
--gpio 16 => 0  SLEEP

MDIR = 4 --gpio 2
MSTR = 2 --gpio 4
MSTL = 1 --gpio 5

--writegpio = function(pin, value)
--   tab = {[0]=3, [1] = 10, [2] = 4, [3] = 9, [4] = 2, [5]=1, [12]=6, [13] = 7,
--          [14]=5,[15]=8,[16]=0}
--   gpio.write(tab[pin], value)
--end

--tmr.delay(us)
--tmr.wdclr()

--tourner = function()

  gpio.mode(0, gpio.OUTPUT)
  gpio.write(0, gpio.HIGH)

  gpio.mode(MDIR, gpio.OUTPUT)
  gpio.mode(MSTR, gpio.OUTPUT)
  gpio.mode(MSTL, gpio.OUTPUT)

  gpio.write(6, gpio.LOW)
  gpio.write(6, gpio.HIGH)

  while true do
	gpio.write(MDIR, gpio.HIGH)
    gpio.write(MSTR, gpio.HIGH)
    gpio.write(MSTR, gpio.LOW)
	
	gpio.write(MDIR, gpio.LOW)
    gpio.write(MSTL, gpio.HIGH)
    gpio.write(MSTL, gpio.LOW)
    tmr.delay(20000)
    tmr.wdclr()
  end

  gpio.write(0, gpio.LOW)
