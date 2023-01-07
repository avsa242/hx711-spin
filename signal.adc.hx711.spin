{
    --------------------------------------------
    Filename: signal.adc.hx711.spin
    Description: Driver for the HX711 24-bit ADC/load cell amplifier
    Author: Jesse Burt
    Copyright (c) 2023
    Started Jan 7, 2023
    Updated Jan 7, 2023
    See end of file for terms of use.
    --------------------------------------------
}

CON

    { set_adc_channel() symbols }
    CH_A    = 0
    CH_B    = 1

VAR

    long _PD_SCK, _DOUT
    byte _adc_chan, _adc_gain

PUB startx(PD_SCK, DOUT): status
' Start the driver using custom I/O settings
'   PD_SCK: PowerDown/Serial Clock
'   DOUT: Data Out
    if (lookdown(PD_SCK: 0..31) and lookdown(DOUT: 0..31))
        longmove(@_PD_SCK, @PD_SCK, 2)
        dira[_DOUT] := 0                        ' one-way serial interface
        outa[_PD_SCK] := 0
        dira[_PD_SCK] := 1
        set_gain(128)
        return (cogid() + 1)
    ' If this point is reached, something above failed.
    ' Double check I/O pin assignments, connections, power
    ' Lastly - make sure you have at least one free core/cog
    return FALSE

PUB defaults()
' Factory default settings
    set_gain(128)                               ' 128x gain (channel A)

pub adc_data(): adc_word | bit
' Read ADC measurement
'   Returns: signed 24-bit ADC word
'   NOTE: The first sample returned will reflect the gain that was set by the previous call
'       to this method.
    adc_word := 0

    repeat until adc_data_rdy()                 ' must wait, or clock pulses may be misinterpreted

    { clock in 24 bit word }
    repeat bit from 0 to 23
        outa[_PD_SCK] := 1
        adc_word := (adc_word << 1)
        outa[_PD_SCK] := 0
        if (ina[_DOUT])
            adc_word++

    repeat _adc_gain
        outa[_PD_SCK] := 1
        outa[_PD_SCK] := 0
    adc_word := (adc_word << 8) ~> 8            ' extend sign

PUB adc_data_rdy(): flag
' Flag indicating ADC data ready
'   Returns: TRUE (-1) or FALSE (0)
    return (ina[_DOUT] == 0)

PUB set_adc_channel(ch)
' Set ADC channel for subsequent measurements
'   Valid values:
'       CH_A (0): channel A (default)
'       CH_B (1): channel B
'   NOTE: Channel B is limited to gain factor 32 (hardware limitation)
    _adc_chan := CH_A #> ch <# CH_B

PUB set_gain(g)
' Set ADC gain factor
'   Valid values: 32, 64, 128 (default: 128)
'   NOTE: Gain factor 32 is only available on channel B.
'         Gain factors 64 and 128 are only available on channel A.
'         Gain selection therefore automatically selects the implied channel.
    _adc_gain := lookdown(g: 128, 32, 64)
    if (_adc_gain == 2)
        set_adc_channel(CH_B)

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

