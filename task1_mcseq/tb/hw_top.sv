/*-----------------------------------------------------------------
File name     : hw_top.sv
Developers    : Kathleen Meade, Brian Dickinson
Created       : 01/04/11
Description   : lab06_vif hardware top module for acceleration
              : Instantiates clock generator and YAPP interface only for testing - no DUT
Notes         : From the Cadence "SystemVerilog Accelerated Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

module hw_top;

  // Clock and reset signals
  logic [31:0]  clock_period;
  logic         run_clock;
  logic         clock;
  logic         reset;
  logic         error;

  // clock_and_reset interface
  clock_and_reset_if clk_if(.clock, .reset, .run_clock, .clock_period);

  // instantiate the clkgen module
  clkgen clk_inst(.clock, .run_clock, .clock_period);

  // YAPP Interface to the DUT
  yapp_if yapp_if_inst(.clock, .reset);

  // Instantiate the HBUS interface
  hbus_if hbus_if_inst(.clock, .reset);

  // Instantiate the channel interfaces
  channel_if channel_if_inst0(.clock, .reset);
  channel_if channel_if_inst1(.clock, .reset);
  channel_if channel_if_inst2(.clock, .reset);

  yapp_router dut(
    .reset,
    .clock,
    .error,

    // YAPP interface
    .in_data(yapp_if_inst.in_data),
    .in_data_vld(yapp_if_inst.in_data_vld),
    .in_suspend(yapp_if_inst.in_suspend),

    // Output Channels
    //Channel 0
    .data_0(channel_if_inst0.data),
    .data_vld_0(channel_if_inst0.data_vld),
    .suspend_0(channel_if_inst0.suspend),
    //Channel 1
    .data_1(channel_if_inst1.data),
    .data_vld_1(channel_if_inst1.data_vld),
    .suspend_1(channel_if_inst1.suspend),
    //Channel 2
    .data_2(channel_if_inst2.data),
    .data_vld_2(channel_if_inst2.data_vld),
    .suspend_2(channel_if_inst2.suspend),

    // HBUS Interface 
    .haddr(hbus_if_inst.haddr),
    .hdata(hbus_if_inst.hdata_w),
    .hen(hbus_if_inst.hen),
    .hwr_rd(hbus_if_inst.hwr_rd)
    );





endmodule
