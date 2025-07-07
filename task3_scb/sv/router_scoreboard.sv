// import yapp_pkg::*;
import channel_pkg::*;
class router_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(router_scoreboard)
    `uvm_analysis_imp_decl(_yapp)
    `uvm_analysis_imp_decl(_chan0)
    `uvm_analysis_imp_decl(_chan1)
    `uvm_analysis_imp_decl(_chan2)
    uvm_analysis_imp_yapp #(yapp_packet, router_scoreboard) yapp_in;
    uvm_analysis_imp_chan0 #(channel_packet, router_scoreboard) chan0_in;
    uvm_analysis_imp_chan1 #(channel_packet, router_scoreboard) chan1_in;
    uvm_analysis_imp_chan2 #(channel_packet, router_scoreboard) chan2_in;
    // `uvm_analysis_imp_decl(_hbus)

    // Queues for holding packets
    yapp_packet yapp_queue0 [$];
    yapp_packet yapp_queue1 [$];
    yapp_packet yapp_queue2 [$];

    // counts
    int recieved_packets = 0;
    int correct_packets = 0;
    int incorrect_packets = 0;

    function new(string name = "router_scoreboard", uvm_component parent);
        super.new(name, parent);
        yapp_in = new("yapp_in", this);
        chan0_in = new("chan0_in", this);
        chan1_in = new("chan1_in", this);
        chan2_in = new("chan2_in", this);
    endfunction //new()

    // custom packet compare function using inequality operators
    function bit comp_equal (yapp_packet yp, channel_packet cp);
        // returns first mismatch only
        if (yp.addr != cp.addr) begin
            `uvm_error("PKT_COMPARE",$sformatf("Address mismatch YAPP %0d Chan %0d",yp.addr, cp.addr))
            return(0);
        end
        if (yp.length != cp.length) begin
            `uvm_error("PKT_COMPARE",$sformatf("Length mismatch YAPP %0d Chan %0d",yp.length, cp.length))
            return(0);
        end
        foreach (yp.payload [i])
            if (yp.payload[i] != cp.payload[i]) begin
                `uvm_error("PKT_COMPARE",$sformatf("Payload[%0d] mismatch YAPP %0d Chan %0d", i, yp.payload[i], cp.payload[i]))
                return(0);
            end
        if (yp.parity != cp.parity) begin
            `uvm_error("PKT_COMPARE",$sformatf("Parity mismatch YAPP %0d Chan %0d",yp.parity, cp.parity))
            return(0);
        end
        return(1);
    endfunction

    // custom packet compare function using inequality operators
    function bit comp_equal_uvm(yapp_packet yp, channel_packet cp);
        uvm_comparer cmp = new();
        bit result = 1;

        // Compare addr
        if (!cmp.compare_field_int("addr", yp.addr, cp.addr, $bits(yp.addr))) begin
            `uvm_error("PKT_COMPARE", $sformatf("Address mismatch YAPP %0d Chan %0d", yp.addr, cp.addr))
            result = 0;
        end

        // Compare length
        if (!cmp.compare_field_int("length", yp.length, cp.length, $bits(yp.length))) begin
            `uvm_error("PKT_COMPARE", $sformatf("Length mismatch YAPP %0d Chan %0d", yp.length, cp.length))
            result = 0;
        end

        // Compare payload
        foreach (yp.payload[i]) begin
            if (!cmp.compare_field_int($sformatf("payload[%0d]", i), yp.payload[i], cp.payload[i], $bits(yp.payload[i]))) begin
                `uvm_error("PKT_COMPARE", $sformatf("Payload[%0d] mismatch YAPP %0d Chan %0d", i, yp.payload[i], cp.payload[i]))
                result = 0;
            end
        end

        // Compare parity
        if (!cmp.compare_field_int("parity", yp.parity, cp.parity, $bits(yp.parity))) begin
            `uvm_error("PKT_COMPARE", $sformatf("Parity mismatch YAPP %0d Chan %0d", yp.parity, cp.parity))
            result = 0;
        end

        return result;
    endfunction

    function void write_yapp(input yapp_packet y_pkt);
        yapp_packet clone_pkt = yapp_packet::type_id::create("clone_pkt");
        // Clone the packet to avoid modifying the original
        // clone_pkt = $cast(clone_pkt, y_pkt.copy());
        clone_pkt.copy(y_pkt);
        // Add the cloned packet to the respective queue
        case (y_pkt.addr)
            0: yapp_queue0.push_back(clone_pkt);
            1: yapp_queue1.push_back(clone_pkt);
            2: yapp_queue2.push_back(clone_pkt);
        endcase
        recieved_packets++;
    endfunction

    function void write_chan0(channel_packet c_pkt);
        yapp_packet y_pkt;
        y_pkt = yapp_queue0.pop_front();
        if (comp_equal_uvm(y_pkt, c_pkt))
            correct_packets++;
        else
            incorrect_packets++;
    endfunction

    function void write_chan1(channel_packet c_pkt);
        yapp_packet y_pkt;
        y_pkt = yapp_queue1.pop_front();
        if (comp_equal_uvm(y_pkt, c_pkt))
            correct_packets++;
        else
            incorrect_packets++;
    endfunction

    function void write_chan2(channel_packet c_pkt);
        yapp_packet y_pkt;
        y_pkt = yapp_queue2.pop_front();
        if (comp_equal_uvm(y_pkt, c_pkt))
            correct_packets++;
        else
            incorrect_packets++;
    endfunction

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
            `uvm_info("SB_REPORT", $sformatf("Total Received: %0d", recieved_packets), UVM_LOW)
            `uvm_info("SB_REPORT", $sformatf("Matched Packets: %0d", correct_packets), UVM_LOW)
            `uvm_info("SB_REPORT", $sformatf("Wrong Packets: %0d", incorrect_packets), UVM_LOW)
            if (incorrect_packets > 0) begin
                `uvm_info("SB_REPORT", $sformatf("Unmatched in Queue 0: %0d", yapp_queue0.size()), UVM_LOW)
                `uvm_info("SB_REPORT", $sformatf("Unmatched in Queue 1: %0d", yapp_queue1.size()), UVM_LOW)
                `uvm_info("SB_REPORT", $sformatf("Unmatched in Queue 2: %0d", yapp_queue2.size()), UVM_LOW)
            end
    endfunction



endclass //router_scoreboard extends uvm_scoreboard;