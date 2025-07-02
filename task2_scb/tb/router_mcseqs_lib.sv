class router_simple_mcseq extends uvm_sequence #(yapp_packet);
    `uvm_object_utils(router_simple_mcseq)
    
    function new(string name = "router_simple_mcseq");
        super.new(name);
    endfunction //new()

    // p_sequencer_handle
    `uvm_declare_p_sequencer(router_mcsequencer)
    
    // HBUS sequences
    hbus_small_packet_seq hbus_small_seq;
    hbus_set_default_regs_seq hbus_long_seq;
    hbus_read_max_pkt_seq hbus_rd_maxpkt_seq;
    
    // YAPP sequences
    yapp_012_seq yapp_seq_012;
    six_yapp_seq six_yapp_seq;

    task pre_body();
        uvm_phase phase;
        `ifdef UVM_VERSION_1_2
        // in UVM1.2, get starting phase from method
        phase = get_starting_phase();
        `else
        phase = starting_phase;
        `endif
        if (phase != null) begin
        phase.raise_objection(this, get_type_name());
        `uvm_info(get_type_name(), "raise objection", UVM_MEDIUM)
        end
    endtask : pre_body

    task body();
        `uvm_do_on(hbus_small_seq, p_sequencer.hbus_seqr)
        `uvm_do_on(hbus_rd_maxpkt_seq, p_sequencer.hbus_seqr)
        repeat (6) begin
            `uvm_do_on(yapp_seq_012, p_sequencer.yapp_seqr)
        end
        `uvm_do_on(hbus_long_seq, p_sequencer.hbus_seqr)
        `uvm_do_on(hbus_rd_maxpkt_seq, p_sequencer.hbus_seqr)
        `uvm_do_on(six_yapp_seq, p_sequencer.yapp_seqr)
    endtask

    task post_body();
        uvm_phase phase;
        `ifdef UVM_VERSION_1_2
        // in UVM1.2, get starting phase from method
        phase = get_starting_phase();
        `else
        phase = starting_phase;
        `endif
        if (phase != null) begin
        phase.drop_objection(this, get_type_name());
        `uvm_info(get_type_name(), "drop objection", UVM_MEDIUM)
        end
    endtask : post_body
endclass //router_simple_mcseq extends uvm_sequence