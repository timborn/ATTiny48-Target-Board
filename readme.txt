Tue Jun 13 17:01:21 MST 2023
----------------------------
_X_ add pads for ISP connector
_X_ gotta have an LED to we can detect life
_X_ decoupling caps between VCC and GND
_na pull-up resistor on VCC
    Data sheet section 22, Electrical Characteristics shows the reset pin
    has a built-in pull-up resistor of between 30 and 60 Ohms, so we shouldn't 
    need an external pull-up, especially for a bare bones system.
_X_ noise filtering ckt between VCC and AVCC (so ADC works better)
_X_ pin headers to fit std breadboard
_X_ reset button


1.  Git Tag each version and make sure you push tags to origin
    https://git-scm.com/book/en/v2/Git-Basics-Tagging
