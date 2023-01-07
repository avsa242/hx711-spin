{
    --------------------------------------------
    Filename: HX711-Demo.spin
    Description: Demo of the HX711 driver
        * Measured weight output
    Author: Jesse Burt
    Copyright (c) 2023
    Started Jan 7, 2023
    Updated Jan 7, 2023
    See end of file for terms of use.
    --------------------------------------------
}

CON

    _clkmode    = cfg#_clkmode
    _xinfreq    = cfg#_xinfreq

' -- User-defined constants
    SER_BAUD    = 115_200

    PD_SCK      = 8
    DOUT        = 9
' --

OBJ

    cfg   : "boardcfg.flip"
    ser   : "com.serial.terminal.ansi"
    time  : "time"
    adc   : "signal.adc.hx711"

PUB main{} | adc_word

    setup{}

    { check your load cell's specifications to set these }
    adc.set_loadcell_max_weight(1000)           ' grams
    adc.set_loadcell_output(1_200)              ' load cell rated output in microvolts per Volt

    repeat
        ser.pos_xy(0, 3)
        ser.printf1(@"Weight: %9.9dg\n\r", adc.grams{})

PUB setup{}

    ser.start(SER_BAUD)
    time.msleep(30)
    ser.clear{}
    ser.strln(string("Serial terminal started"))

    if (adc.startx(PD_SCK, DOUT))
        ser.strln(@"HX711 driver started")
    else
        ser.strln(@"HX711 driver failed to start - halting")
        repeat

DAT
{
Copyright 2022 Jesse Burt

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
associated documentation files (the "Software"), to deal in the Software without restriction,
including without limitation the rights to use, copy, modify, merge, publish, distribute,
sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or
substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT
OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
}

