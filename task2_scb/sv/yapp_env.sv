class yapp_env extends uvm_env;
    `uvm_component_utils(yapp_env)

    // Declare the agent
    yapp_tx_agent tx_agent;
    function new(string name = "", uvm_component parent);
        super.new(name, parent);        
    endfunction //new()

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // Create the agent
        tx_agent = yapp_tx_agent::type_id::create("tx_agent", this);
    endfunction
    function void start_of_simulation_phase(uvm_phase phase);
        `uvm_info(get_type_name(), "Now in the start of simulation phase for env", UVM_HIGH)        
    endfunction
endclass //yapp_env extends uvm_env