
--MOTEURS INIT
MSLP = 0 --gpio 16
MDIR = 4 --gpio 2
MSTR = 2 --gpio 4
MSTL = 1 --gpio 5

gpio.mode(MSLP, gpio.OUTPUT)
gpio.mode(MDIR, gpio.OUTPUT)
gpio.mode(MSTR, gpio.OUTPUT)
gpio.mode(MSTL, gpio.OUTPUT)
gpio.write(MSLP, gpio.LOW)

--SPI INIT
SPI_XP1 = 12
gpio.mode(SPI_XP1, gpio.OUTPUT)
gpio.write(SPI_XP1, gpio.HIGH)
spi.setup(1, spi.MASTER, spi.CPOL_LOW, spi.CPHA_LOW, spi.DATABITS_8, 32, spi.HALFDUPLEX)


write_ioexp = function(adr, value)
    gpio.write(SPI_XP1, gpio.LOW)
    spi.send(1,0x40)
    spi.send(1,adr)
    spi.send(1,value)
    gpio.write(SPI_XP1, gpio.HIGH)
end

read_ioexp = function(adr)
   gpio.write(SPI_XP1, gpio.LOW)
   spi.send(1,0x41)
   spi.send(1,adr)
   local res = string.byte(spi.recv(1,1),1)
   gpio.write(SPI_XP1, gpio.HIGH)
   return res
end

expCapvOut = 0x00
init_ioCapt = function()
    --sens io FC
    write_ioexp(0x00,0xFC)
    --pullup FC
    write_ioexp(0x06,0xFC)
    expCapvOut = read_ioexp(0x09)
end

select_ioCapt = function(code)
    --IO output cap
    write_ioexp(0x0A,code)
end

read_ioCapt = function()
    --IO input cap
    return read_ioexp(0x09)
end

init_ioCapt()
write_ioexp(0x0A,0x03)
gpio.write(MSLP, gpio.HIGH)
obs=0

while true do

    while read_ioCapt()==expCapvOut do
        gpio.write(MDIR, gpio.HIGH)
        gpio.write(MSTR, gpio.HIGH)
        gpio.write(MSTR, gpio.LOW)
        
        gpio.write(MDIR, gpio.LOW)
        gpio.write(MSTL, gpio.HIGH)
        gpio.write(MSTL, gpio.LOW)
        tmr.delay(40000)
        tmr.wdclr()
    end

    obs = read_ioCapt()
    gpio.write(MDIR, gpio.HIGH)
    for i=0,48,1 do
        gpio.write(MSTR, gpio.HIGH)
        gpio.write(MSTR, gpio.LOW)
        
        gpio.write(MSTL, gpio.HIGH)
        gpio.write(MSTL, gpio.LOW)
        tmr.delay(80000)
        tmr.wdclr()
        if obs~=read_ioCapt() then break end
    end
    expCapvOut = read_ioCapt()

    while read_ioCapt()==expCapvOut do
        gpio.write(MDIR, gpio.HIGH)
        gpio.write(MSTR, gpio.HIGH)
        gpio.write(MSTR, gpio.LOW)
        
        gpio.write(MDIR, gpio.LOW)
        gpio.write(MSTL, gpio.HIGH)
        gpio.write(MSTL, gpio.LOW)
        tmr.delay(40000)
        tmr.wdclr()
    end

    local obs = read_ioCapt()
    gpio.write(MDIR, gpio.LOW)
    for i=0,48,1 do
        gpio.write(MSTR, gpio.HIGH)
        gpio.write(MSTR, gpio.LOW)
        
        gpio.write(MSTL, gpio.HIGH)
        gpio.write(MSTL, gpio.LOW)
        tmr.delay(80000)
        tmr.wdclr()
        if obs~=read_ioCapt() then break end
    end
    expCapvOut = read_ioCapt()
    
end

