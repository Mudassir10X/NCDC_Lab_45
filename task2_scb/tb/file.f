// 64 bit option for AWS labs
-64bit

-uvmhome /home/cc/mnt/XCELIUM2309/tools/methodology/UVM/CDNS-1.2

// include directories
//*** add incdir include directories here
-incdir ../router_rtl
// -incdir ../task1_integ/sv/
// -incdir ../task1_integ/tb/
-incdir ../task2_scb/sv/
-incdir ../task2_scb/tb/
-incdir ../channel/sv
-incdir ../clock_and_reset/sv
-incdir ../hbus/sv

// compile files
//*** add compile files here
../channel/sv/channel_pkg.sv
../channel/sv/channel_if.sv
../clock_and_reset/sv/clock_and_reset_pkg.sv
../clock_and_reset/sv/clock_and_reset_if.sv
../hbus/sv/hbus_pkg.sv
../hbus/sv/hbus_if.sv
../task2_scb/sv/yapp_pkg.sv
../task2_scb/sv/yapp_if.sv
../task2_scb/tb/clkgen.sv
../task2_scb/tb/top.sv
../router_rtl/yapp_router.sv
../task2_scb/tb/hw_top.sv

