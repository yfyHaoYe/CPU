# 
# Synthesis run script generated by Vivado
# 

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
create_project -in_memory -part xc7a35tcsg324-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir {C:/Users/29266/Desktop/Homework/Computer Organization/CPU/CPU/CPU.cache/wt} [current_project]
set_property parent.project_path {C:/Users/29266/Desktop/Homework/Computer Organization/CPU/CPU/CPU.xpr} [current_project]
set_property XPM_LIBRARIES {XPM_CDC XPM_MEMORY} [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_output_repo {c:/Users/29266/Desktop/Homework/Computer Organization/CPU/CPU/CPU.cache/ip} [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_verilog -library xil_defaultlib {
  {C:/Users/29266/Desktop/Homework/Computer Organization/CPU/ALU.v}
  {C:/Users/29266/Desktop/Homework/Computer Organization/CPU/definitions.v}
  {C:/Users/29266/Desktop/Homework/Computer Organization/CPU/Controller.v}
  {C:/Users/29266/Desktop/Homework/Computer Organization/CPU/Data_Mem.v}
  {C:/Users/29266/Desktop/Homework/Computer Organization/CPU/Decoder.v}
  {C:/Users/29266/Desktop/Homework/Computer Organization/CPU/IFetch.v}
  {C:/Users/29266/Desktop/Homework/Computer Organization/CPU/MemOrIO.v}
  {C:/Users/29266/Desktop/Homework/Computer Organization/CPU/cpu_top.v}
}
read_ip -quiet {{c:/Users/29266/Desktop/Homework/Computer Organization/CPU/cpuclk/cpuclk.xci}}
set_property used_in_implementation false [get_files -all {{c:/Users/29266/Desktop/Homework/Computer Organization/CPU/cpuclk/cpuclk_board.xdc}}]
set_property used_in_implementation false [get_files -all {{c:/Users/29266/Desktop/Homework/Computer Organization/CPU/cpuclk/cpuclk.xdc}}]
set_property used_in_implementation false [get_files -all {{c:/Users/29266/Desktop/Homework/Computer Organization/CPU/cpuclk/cpuclk_ooc.xdc}}]

read_ip -quiet {{c:/Users/29266/Desktop/Homework/Computer Organization/CPU/RAM/RAM.xci}}
set_property used_in_implementation false [get_files -all {{c:/Users/29266/Desktop/Homework/Computer Organization/CPU/RAM/RAM_ooc.xdc}}]

# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc {{C:/Users/29266/Desktop/Homework/Computer Organization/CPU/constrains.xdc}}
set_property used_in_implementation false [get_files {{C:/Users/29266/Desktop/Homework/Computer Organization/CPU/constrains.xdc}}]

read_xdc dont_touch.xdc
set_property used_in_implementation false [get_files dont_touch.xdc]

synth_design -top cpu_top -part xc7a35tcsg324-1


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef cpu_top.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file cpu_top_utilization_synth.rpt -pb cpu_top_utilization_synth.pb"