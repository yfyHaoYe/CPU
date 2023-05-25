onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+cc0518668657b3d3 -L xil_defaultlib -L xpm -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.cc0518668657b3d3 xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {cc0518668657b3d3.udo}

run -all

endsim

quit -force
