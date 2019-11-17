onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib hue_div1_opt

do {wave.do}

view wave
view structure
view signals

do {hue_div1.udo}

run -all

quit -force
