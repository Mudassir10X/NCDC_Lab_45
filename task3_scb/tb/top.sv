module tb_top;
    // import the UVM library
    // include the UVM macros
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    // import the YAPP package
    import yapp_pkg::*;
    import hbus_pkg::*;
    import channel_pkg::*;
    import clock_and_reset_pkg::*;
    `include "router_tb.sv"
    `include "router_test_lib.sv"
    // `include "router_module.sv"
    import router_module_pkg::*;

    hw_top hw_top_inst();
    // yapp_vif_config::get(this, "", "vif", vif)) begin

    initial begin
        yapp_vif_config::set(null, "uvm_test_top.tb.yapp_e.tx_agent.*", "vif", hw_top_inst.yapp_if_inst);
        clock_and_reset_vif_config::set(null, "uvm_test_top.tb.clock_and_reset_e.agent.*", "vif", hw_top_inst.clk_if);
        hbus_vif_config::set(null,"*.tb.hbus_e.*","vif", hw_top_inst.hbus_if_inst);
        channel_vif_config::set(null,"*.tb.channel_0.*","vif", hw_top_inst.channel_if_inst0);
        channel_vif_config::set(null,"*.tb.channel_1.*","vif", hw_top_inst.channel_if_inst1);
        channel_vif_config::set(null,"*.tb.channel_2.*","vif", hw_top_inst.channel_if_inst2);
        run_test();
    end

endmodule : tb_top
