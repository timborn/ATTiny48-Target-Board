Wed Jun 14 15:49:03 MST 2023
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
_X_ panelize boards
_X_ fix installation of kikit that broke with upgrade of KiCad to 7.0.5
___ UNpanelize board


1.  Git Tag each version and make sure you push tags to origin
    https://git-scm.com/book/en/v2/Git-Basics-Tagging
2.  When I went to PCBWAY to place the order, I had panelized 2x4 which ended up
    being 110.5 x 104.7mm.  The price for the boards was $35.  
    When I dropped the size to fit inside 100x100mm the price dropped to $5.
3.  When generating the Gerber files I got a stern warning:
    "Global solder mask minimum width and/or margin are not set to 0.
    Most board manufacturers expect 0 and use their own constraints for
    solder mask minimum width."

    File / Board Setup / Board Stackup / Solder Mask/Paste
    set 'Solder mask expansion' to 0
    set 'Solder mask minimum web width' to 0

    I compared my settings to the requirements from PCBWAY:
    https://www.pcbway.com/pcb_prototype/Pinted_Circuit_Board_Prototype.html
    I didn't find anything about solder mask web width, so I set it at zero
    per KiCad recommendation.  I did change minimum clearance between traces
    to 3mil (0.076mm) per PCBWAY recommendation.  These changes went in post v1.0.

4.  Found a forked trace on pin 22 GND.  Cleaned that up.
5.  Having difficulty with paneling.  Crashes often, and rarely allows me to iterate
    without having to start over with a clean project.  I picked off the command
    line that it builds (uses kikit) but it throws some error when I run it from 
    the command line.  I think I could iterate faster over panels if I had
    the command line stuff working.
6.  ... to that end, I upgraded from KiCad 7.02 to 7.0.5.  I think kikit maybe brew.
    When I installed 7.0.5 over 7.0.2 it went through the motions, but silently failed.
    I had to move the old KiCad folder out of /Applications for installation to complete.
7.  After upgrading to KiCad 7.0.5 it complained about KiKit and sent me here to install it:
    https://github.com/yaqwsx/KiKit/blob/master/doc/installation.md

    Before:
    R2D2:ATTiny48-Target-Board timborn$ kikit --version
    python -m kikit.ui, version 1.3.0

    NB KiCad installed it's own version of Python and kikit, so when I queried pip3
    to see what's up with KiKit, the default version in my PATH didn't know anything
    (which is weird, since I am able to invoke kikit).

    Using the "other" version of Python & friends from KiCad:
    R2D2:test timborn$ /Applications/KiCad/KiCad.app/Contents/Frameworks/Python.framework/Versions/Current/bin/pip3 show kikit

    As I already had the certificate in place ...
    $ curl -O https://raw.githubusercontent.com/yaqwsx/KiKit/master/scripts/installMacOS.bash
    $ sudo bash installMacOS.bash
    
    OK, that got kikit installed (turned out to be the same version).  I just needed to 
    go into KiCad Tools / Plugin and Content Manager and (re-)install kikit.


8. Apparently I have kikit running inside Docker:
   R2D2:test timborn$ docker run  yaqwsx/kikit --version
   I wonder how to use this for panelization.

   $ docker run yaqwsx/kikit panelize     --layout 'hspace: 2mm; vspace: 2mm; cols: 3'\
   --framing 'type: frame' \
   /Volumes/BlueMountain/Users/timborn/kikad/ATTiny48-Target-Board/ATTiny48-Target-Board.kicad_pcb panel.kicad_pcb
   An error occurred: Unable to open /Volumes/BlueMountain/Users/timborn/kikad/ATTiny48-Target-Board/ATTiny48-Target-Board.kicad_pcb for reading.
   No output files produced

   Using bind mount helped!
   # using a bind mount for a local directory so I can pass in the PCB to be panelized
   # and get the results back (the directory on the host in this case is $PWD).
   docker run --mount type=bind,source="$(pwd)",destination=/app yaqwsx/kikit panelize     \
   --layout 'hspace: 2mm; vspace: 2mm; cols: 3'     \
   --framing 'type: frame'     \
   /app/ATTiny48-Target-Board.kicad_pcb \
   /app/panel.kicad_pcb

   KiCad was unable to open this file because it was created with a 
   more recent version than the one you are running.

   Looks like I have to figure out how to update KiCad inside this container.

   OK, I have a clone of yaqwsx/KiKit here:
   /Volumes/BlueMountain/Users/timborn/kikad/KiKit
   In my notes there I see a one-line change to Dockerfile to update to KiCad 7.0:
  
   # ARG KICAD_VERSION="6.0"
   ARG KICAD_VERSION="7.0"

   Build an image called kikit (NOT yaqwsx/kikit):
   Docker build -t kikit .

   Update script.sh to use the correct docker image and Bob's Your Uncle™️

9. 5-8 can be summed up as 1) I upgraded versions of KiCad and KiKit and 
   2) running kikit for paneling inside a Docker container is *way* more
   stable and faster for iterating until you get something you like.

10. When I submitted my 1x3 panelized version (well inside the 100x100mm) they
   changed the price from $5 to $33.  $15 for USPS, so $20/5 boards vs $48/15 boards.
