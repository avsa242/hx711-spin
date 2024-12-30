{
----------------------------------------------------------------------------------------------------
    Filename:       HX711-Demo.spin
    Description:    Demo of the HX711 driver
        * Measured weight output
    Author:         Jesse Burt
    Started:        Jan 7, 2023
    Updated:        Dec 30, 2024
    Copyright (c) 2024 - See end of file for terms of use.
----------------------------------------------------------------------------------------------------
}

CON

    _clkmode    = xtal1+pll16x
    _xinfreq    = 5_000_000


OBJ

    time:   "time"
    ser:    "com.serial.terminal.ansi" | SER_BAUD=115_200
    adc:    "signal.adc.hx711" | SCK=0, MISO=1


PUB main()

    setup()

    { check your load cell's specifications to set these }
    adc.set_loadcell_max_weight(1000)           ' grams
    adc.set_loadcell_output(1_200)              ' load cell rated output in microvolts per Volt
    adc.set_adc_channel(0)

    ser.pos_xy(0, 3)
    ser.strln(@"Press 'z' to zero the scale")
    repeat
        ser.pos_xy(0, 4)
        ser.printf(@"Weight: %9.9dg\n\r", adc.grams())
        if ( ser.getchar_noblock() == "z" )
            adc.calibrate_adc()


PUB setup()

    ser.start()
    time.msleep(30)
    ser.clear()
    ser.strln(@"Serial terminal started")

    if ( adc.start() )
        ser.strln(@"HX711 driver started")
    else
        ser.strln(@"HX711 driver failed to start - halting")
        repeat


DAT
{
Copyright 2024 Jesse Burt

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

