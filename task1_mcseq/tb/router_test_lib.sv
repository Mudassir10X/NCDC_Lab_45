`include "uvm_macros.svh"
import uvm_pkg::*;

class base_test extends uvm_test;
    `uvm_component_utils(base_test)
    router_tb tb;
    // declare the objection object
    uvm_objection obj;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        tb = router_tb::type_id::create("tb", this);
        // uvm_config_wrapper::set(this, "tb.yapp_e.tx_agent.sequencer.run_phase",
        //                                 "default_sequence",
        //                                 yapp_5_packets::get_type());
        `uvm_info("BUILD_PHASE", "Executing build_phase of base_test", UVM_HIGH)
        uvm_config_int::set(this, "*", "recording_detail", 1);
    endfunction

    function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        uvm_top.print_topology();
    endfunction

    // run phase
    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info("RUN_PHASE", "Executing run_phase of base_test", UVM_HIGH)
        obj = phase.get_objection();
        obj.set_drain_time(this, 200ns);
    endtask

    function void check_phase(uvm_phase phase);
        super.check_phase(phase);
        `uvm_info("CHECK_PHASE", "Executing check_phase of base_test", UVM_HIGH)
        check_config_usage();
    endfunction

endclass

class simple_test extends base_test;
    `uvm_component_utils(simple_test)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction //new()

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("BUILD_PHASE", "Executing build_phase of simple_test", UVM_HIGH)
        uvm_factory::get().set_type_override_by_type(yapp_packet::get_type(), short_yapp_packet::get_type());
        uvm_config_wrapper::set(this, "tb.yapp_e.tx_agent.sequencer.run_phase",
                                        "default_sequence",
                                        yapp_012_seq::get_type());
        uvm_config_wrapper::set(this, "tb.channel_0.rx_agent.sequencer.run_phase",
                                        "default_sequence",
                                        channel_rx_resp_seq::get_type());
        uvm_config_wrapper::set(this, "tb.channel_1.rx_agent.sequencer.run_phase",
                                        "default_sequence",
                                        channel_rx_resp_seq::get_type());
        uvm_config_wrapper::set(this, "tb.channel_2.rx_agent.sequencer.run_phase",
                                        "default_sequence",
                                        channel_rx_resp_seq::get_type());
        uvm_config_wrapper::set(this, "tb.clock_and_reset_e.agent.sequencer.run_phase",
                                        "default_sequence",
                                        clk10_rst5_seq::get_type());
    endfunction //build_phase

endclass //simple_test extends base_test

class test_uvc_integration extends base_test;
    `uvm_component_utils(test_uvc_integration)

    function new(string name = "test_uvc_integration", uvm_component parent);
        super.new(name, parent);
    endfunction //new()

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("BUILD_PHASE", "Executing build_phase of test_uvc_integration", UVM_HIGH)
        uvm_factory::get().set_type_override_by_type(yapp_packet::get_type(), short_yapp_packet::get_type());
        uvm_config_wrapper::set(this, "tb.yapp_e.tx_agent.sequencer.run_phase",
                                        "default_sequence",
                                        yapp_exhaustive_all_seq::get_type());
        uvm_config_wrapper::set(this, "tb.channel_0.rx_agent.sequencer.run_phase",
                                        "default_sequence",
                                        channel_rx_resp_seq::get_type());
        uvm_config_wrapper::set(this, "tb.channel_1.rx_agent.sequencer.run_phase",
                                        "default_sequence",
                                        channel_rx_resp_seq::get_type());
        uvm_config_wrapper::set(this, "tb.channel_2.rx_agent.sequencer.run_phase",
                                        "default_sequence",
                                        channel_rx_resp_seq::get_type());
        uvm_config_wrapper::set(this, "tb.clock_and_reset_e.agent.sequencer.run_phase",
                                        "default_sequence",
                                        clk10_rst5_seq::get_type());
        uvm_config_wrapper::set(this, "tb.hbus_e.masters[0].sequencer.run_phase",
                                        "default_sequence",
                                        hbus_small_packet_seq::get_type());
    endfunction //build_phase

endclass //test_uvc_integration extends base_test

class test_mcseqr extends base_test;
    `uvm_component_utils(test_mcseqr)

    function new(string name = "test_mcseqr", uvm_component parent);
        super.new(name, parent);
    endfunction //new()

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("BUILD_PHASE", "Executing build_phase of test_mcseqr", UVM_HIGH)
        uvm_factory::get().set_type_override_by_type(yapp_packet::get_type(), short_yapp_packet::get_type());
        uvm_config_wrapper::set(this, "tb.mc_seqr.run_phase",
                                        "default_sequence",
                                        router_simple_mcseq::get_type());
        uvm_config_wrapper::set(this, "tb.channel_0.rx_agent.sequencer.run_phase",
                                        "default_sequence",
                                        channel_rx_resp_seq::get_type());
        uvm_config_wrapper::set(this, "tb.channel_1.rx_agent.sequencer.run_phase",
                                        "default_sequence",
                                        channel_rx_resp_seq::get_type());
        uvm_config_wrapper::set(this, "tb.channel_2.rx_agent.sequencer.run_phase",
                                        "default_sequence",
                                        channel_rx_resp_seq::get_type());
        uvm_config_wrapper::set(this, "tb.clock_and_reset_e.agent.sequencer.run_phase",
                                        "default_sequence",
                                        clk10_rst5_seq::get_type());
    endfunction //build_phase

endclass //test_mcseqr extends base_test