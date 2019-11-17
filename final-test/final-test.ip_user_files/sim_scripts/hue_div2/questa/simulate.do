onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib hue_div2_opt

do {wave.do}

view wave
view structure
view signals

do {hue_div2.udo}

run -all

quit -force
