onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib cc0518668657b3d3_opt

do {wave.do}

view wave
view structure
view signals

do {cc0518668657b3d3.udo}

run -all

quit -force
