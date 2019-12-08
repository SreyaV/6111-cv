# 
# Synthesis run script generated by Vivado
# 

set TIME_start [clock seconds] 
proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
create_project -in_memory -part xc7a200tsbg484-3

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir {C:/Users/Sreya Vangara/Documents/MIT/6.111/6.111/Final/final-test/final-test.cache/wt} [current_project]
set_property parent.project_path {C:/Users/Sreya Vangara/Documents/MIT/6.111/6.111/Final/final-test/final-test.xpr} [current_project]
set_property XPM_LIBRARIES {XPM_CDC XPM_MEMORY} [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_repo_paths {{c:/Users/Sreya Vangara/Documents/MIT/6.111/6.111/Final/vivado-library/ip}} [current_project]
update_ip_catalog
set_property ip_output_repo {c:/Users/Sreya Vangara/Documents/MIT/6.111/6.111/Final/final-test/final-test.cache/ip} [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_verilog -library xil_defaultlib -sv {
  {C:/Users/Sreya Vangara/Documents/MIT/6.111/6.111/Final/final-test/final-test.srcs/sources_1/imports/Final/camera_read.sv}
  {C:/Users/Sreya Vangara/Documents/MIT/6.111/6.111/Final/final-test/final-test.srcs/sources_1/new/centroid.sv}
  {C:/Users/Sreya Vangara/Documents/MIT/6.111/6.111/Final/final-test/final-test.srcs/sources_1/new/pipeline.sv}
  {C:/Users/Sreya Vangara/Documents/MIT/6.111/6.111/Final/final-test/final-test.srcs/sources_1/new/rgb2hsv.sv}
  {C:/Users/Sreya Vangara/Documents/MIT/6.111/6.111/Final/final-test/final-test.srcs/sources_1/imports/Final/top_level.sv}
}
read_verilog -library xil_defaultlib {{C:/Users/Sreya Vangara/Documents/MIT/6.111/6.111/Final/final-test/final-test.srcs/sources_1/imports/6.111/clk_wiz_lab3.v}}
read_ip -quiet {{C:/Users/Sreya Vangara/Documents/MIT/6.111/6.111/Final/final-test/final-test.srcs/sources_1/ip/blk_mem_gen_0/blk_mem_gen_0.xci}}
set_property used_in_implementation false [get_files -all {{c:/Users/Sreya Vangara/Documents/MIT/6.111/6.111/Final/final-test/final-test.srcs/sources_1/ip/blk_mem_gen_0/blk_mem_gen_0_ooc.xdc}}]

read_ip -quiet {{C:/Users/Sreya Vangara/Documents/MIT/6.111/6.111/Final/final-test/final-test.srcs/sources_1/ip/fifo_33/fifo_33.xci}}
set_property used_in_implementation false [get_files -all {{c:/Users/Sreya Vangara/Documents/MIT/6.111/6.111/Final/final-test/final-test.srcs/sources_1/ip/fifo_33/fifo_33.xdc}}]
set_property used_in_implementation false [get_files -all {{c:/Users/Sreya Vangara/Documents/MIT/6.111/6.111/Final/final-test/final-test.srcs/sources_1/ip/fifo_33/fifo_33_clocks.xdc}}]
set_property used_in_implementation false [get_files -all {{c:/Users/Sreya Vangara/Documents/MIT/6.111/6.111/Final/final-test/final-test.srcs/sources_1/ip/fifo_33/fifo_33_ooc.xdc}}]

read_ip -quiet {{C:/Users/Sreya Vangara/Documents/MIT/6.111/6.111/Final/final-test/final-test.srcs/sources_1/ip/hdmi/hdmi.xci}}
set_property used_in_implementation false [get_files -all {{c:/Users/Sreya Vangara/Documents/MIT/6.111/6.111/Final/final-test/final-test.srcs/sources_1/ip/hdmi/src/rgb2dvi.xdc}}]
set_property used_in_implementation false [get_files -all {{c:/Users/Sreya Vangara/Documents/MIT/6.111/6.111/Final/final-test/final-test.srcs/sources_1/ip/hdmi/src/rgb2dvi_ooc.xdc}}]
set_property used_in_implementation false [get_files -all {{c:/Users/Sreya Vangara/Documents/MIT/6.111/6.111/Final/final-test/final-test.srcs/sources_1/ip/hdmi/src/rgb2dvi_clocks.xdc}}]

read_ip -quiet {{C:/Users/Sreya Vangara/Documents/MIT/6.111/6.111/Final/final-test/final-test.srcs/sources_1/ip/vio/vio.xci}}
set_property used_in_implementation false [get_files -all {{c:/Users/Sreya Vangara/Documents/MIT/6.111/6.111/Final/final-test/final-test.srcs/sources_1/ip/vio/vio.xdc}}]
set_property used_in_implementation false [get_files -all {{c:/Users/Sreya Vangara/Documents/MIT/6.111/6.111/Final/final-test/final-test.srcs/sources_1/ip/vio/vio_ooc.xdc}}]

read_ip -quiet {{C:/Users/Sreya Vangara/Documents/MIT/6.111/6.111/Final/final-test/final-test.srcs/sources_1/ip/centroid_div/centroid_div.xci}}
set_property used_in_implementation false [get_files -all {{c:/Users/Sreya Vangara/Documents/MIT/6.111/6.111/Final/final-test/final-test.srcs/sources_1/ip/centroid_div/centroid_div_ooc.xdc}}]

read_ip -quiet {{C:/Users/Sreya Vangara/Documents/MIT/6.111/6.111/Final/final-test/final-test.srcs/sources_1/ip/div_16/div_16.xci}}
set_property used_in_implementation false [get_files -all {{c:/Users/Sreya Vangara/Documents/MIT/6.111/6.111/Final/final-test/final-test.srcs/sources_1/ip/div_16/div_16_ooc.xdc}}]

# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc {{C:/Users/Sreya Vangara/Documents/MIT/6.111/6.111/Final/final-test/final-test.srcs/constrs_1/imports/Final/nexys4ddr.xdc}}
set_property used_in_implementation false [get_files {{C:/Users/Sreya Vangara/Documents/MIT/6.111/6.111/Final/final-test/final-test.srcs/constrs_1/imports/Final/nexys4ddr.xdc}}]

set_param ips.enableIPCacheLiteLoad 1
close [open __synthesis_is_running__ w]

synth_design -top top_level -part xc7a200tsbg484-3


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef top_level.dcp
create_report "synth_2_synth_report_utilization_0" "report_utilization -file top_level_utilization_synth.rpt -pb top_level_utilization_synth.pb"
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]
