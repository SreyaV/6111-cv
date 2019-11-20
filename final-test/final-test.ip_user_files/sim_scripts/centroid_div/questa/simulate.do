onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib centroid_div_opt

do {wave.do}

view wave
view structure
view signals

do {centroid_div.udo}

run -all

quit -force
