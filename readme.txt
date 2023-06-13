Tue May 23 11:24:11 MST 2023
----------------------------
The SWR Protector needs a display for SWR readings.
Since we have both Vfwd and Vref, we should be able to figure this out.

VSWR=(𝑉fwd+𝑉ref) / (𝑉fwd−𝑉ref)

- https://www.electronics-notes.com/articles/antennas-propagation/vswr-return-loss/vswr-calculations-formulas-equations.php

___ Use ADC to read both Vfwd and Vref
___ figure out how to drive ~1" OLED via I2C
___ small enough to fit in the box?
    ___ how to physically attach display to inside of box?
___ apply power saving measures
    ___ sleep often
    ___ turn off all parts of the chip not being used
    ___ how do I measure current consumption?
___ Do we need/want BOD?
___ If you design a PCB at least add pads for ISP connector
