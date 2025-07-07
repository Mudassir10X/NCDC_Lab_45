class router_module_env extends uvm_component;
    `uvm_component_utils(router_module_env)
    router_reference router_ref;
    router_scoreboard router_sb;

    // Constructor
    function new(string name = "router_module_env", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        // Create the router reference instance
        router_ref = router_reference::type_id::create("router_ref", this);

        // Create the router scoreboard instance
        router_sb = router_scoreboard::type_id::create("router_sb", this);
        
        `uvm_info("ROUTER_Mod_env", "Build phase of router module env is being executed", UVM_HIGH)
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        // Connect the router reference to the router_sb through TLM analusis ports
        router_ref.yapp_out.connect(router_sb.yapp_in);
    endfunction
endclass