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
--gpio.mode(11, gpio.OUTPUT)
gpio.mode(12, gpio.OUTPUT)
--gpio.write(11, gpio.HIGH)
gpio.write(12, gpio.HIGH)

--SPI = 0
--HSPI = 1
--gpio.mode(5, gpio.OUTPUT)
spi.setup(1, spi.MASTER, spi.CPOL_LOW, spi.CPHA_LOW, spi.DATABITS_8, 32, spi.HALFDUPLEX)

uart.setup(0, 9600, 8, 0, 0, 0)

write_ioexp = function(adr, value)
    gpio.write(12, gpio.LOW)
    spi.send(1,0x40)
    spi.send(1,adr)
    spi.send(1,value)
    gpio.write(12, gpio.HIGH)
end

read_ioexp = function(adr)
   gpio.write(12, gpio.LOW)
   spi.send(1,0x41)
   spi.send(1,adr)
   local res = string.byte(spi.recv(1,1),1)
   gpio.write(12, gpio.HIGH)
   return res
end

expCapvOut = 0x00
init_ioCapt = function()
    --sens io FC
    write_ioexp(0x00,0xFC)
    --pullup FC
    write_ioexp(0x06,0xFC)
    --expCapvOut = 0x00
end

select_ioCapt = function(code)
    expCapvOut = (expCapvOut and 0xFC) or code
    --IO output cap
    write_ioexp(0x0A,expCapvOut)
end

read_ioCapt = function()
    --IO input cap
    return (read_ioexp(0x09) and 0x1C)
end


gpio.write(4, gpio.HIGH)

init_ioCapt()
write_ioexp(0x0A,0x03)
--select_ioCapt(3) --active tout les capteurs

while true do
    --local v = 0x55
    --if (read_ioexp(5) == 562) then
    --  gpio.write(4, gpio.LOW)
    --end
    --spi.send(1,0x10)
    --spi.set_mosi(1, 0, 16, v)
    --spi.send(1,0x55)
    --local res = 0
    res = read_ioexp(0x09)
    if(res==0xFF)then gpio.write(4, gpio.LOW) else  gpio.write(4, gpio.HIGH)  end
    print("receive from uart:", res)
    --uart.write(0,"HELLO")

    --local res = read_ioCapt()
    --if(res ~= 0x1C)then gpio.write(4, gpio.LOW) else gpio.write(4, gpio.HIGH) end

    --gpio.write(11, gpio.LOW)
    --gpio.write(11, gpio.HIGH)
    
    tmr.wdclr()
    tmr.delay(500000) --500ms
end
