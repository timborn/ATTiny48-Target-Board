# To panelize your project, run this script in a folder with your *.kicad_pcb file.
# using a bind mount for a local directory so I can pass in the PCB to be panelized
# and get the results back (the directory on the host in this case is $PWD).
# NB run kikit, not yaqwsx/kikit as I hacked the image to use KiCad 7.0.x
# use offset negative to drill outside board footprint.
docker run --mount type=bind,source="$(pwd)",destination=/app kikit panelize     \
--layout 'grid; rows: 1; cols: 3; space: 2mm'     \
--tabs 'fixed; width: 3mm; hcount: 2' \
--cuts 'mousebites; drill: 0.5mm; spacing: 1mm; offset: -0.25mm; prolong: 0.5mm' \
--framing 'railslr; width: 5mm; space: 3mm;' \
--text 'simple; text: BBMC-T48/T88 V1.1; anchor: ml; orientation: 90deg; hoffset: 2mm;' \
--post 'millradius: 1mm' \
/app/ATTiny48-Target-Board.kicad_pcb \
/app/panel.kicad_pcb
