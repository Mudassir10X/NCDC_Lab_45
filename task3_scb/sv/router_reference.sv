class router_reference extends uvm_component;
    `uvm_component_utils(router_reference)
    `uvm_analysis_imp_decl(_yapp)
    `uvm_analysis_imp_decl(_hbus)
    uvm_analysis_imp_yapp #(yapp_packet, router_reference)      yapp_in;
    uvm_analysis_imp_hbus #(hbus_transaction, router_reference) hbus_in;
    uvm_analysis_port #(yapp_packet) yapp_out;


    logic [5:0] max_pkt_size = 63;
    logic       router_en_reg;

    // Constructor 
    function new(string name = "router_reference", uvm_component parent);
        super.new(name, parent);
        yapp_in = new("yapp_in", this);
        hbus_in = new("hbus_in", this);
        yapp_out = new("yapp_out", this);
    endfunction 

    // function for writing hbus configuration 
    function void write_hbus(input hbus_transaction hbus_pkt);
        hbus_transaction clone_pkt = hbus_transaction::type_id::create("clone_pkt");
        clone_pkt.copy(hbus_pkt);
        if (clone_pkt.haddr == 16'h1000)
        this.max_pkt_size = clone_pkt.hdata;
        if (clone_pkt.haddr == 16'h1001)
        this.router_en_reg = clone_pkt.hdata;
    endfunction

    // function for writing yapp packets 
    function void write_yapp(input yapp_packet y_pkt);
        yapp_packet clone_pkt = yapp_packet::type_id::create("clone_pkt");
        clone_pkt.copy(y_pkt);
        
        // Check if the packet is valid?
        if ((clone_pkt.addr != 3) && (clone_pkt.payload.size() <= max_pkt_size)) begin
            yapp_out.write(clone_pkt);
        end else begin
            `uvm_error("ROUTER_REF", $sformatf("Invalid yapp packet: addr=%0d, size=%0d", clone_pkt.addr, clone_pkt.payload.size()));
        end
    endfunction


endclass