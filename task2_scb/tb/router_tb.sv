`include "router_mcsequencer.sv"
`include "router_mcseqs_lib.sv"

class router_tb extends uvm_env;
    `uvm_component_utils(router_tb)
    // Adding the yapp_env instance
    yapp_env yapp_e;
    
    // Adding the router mcsequencer instance
    router_mcsequencer mc_seqr;
    
    // Adding 3 instances of channel UVC's for the 3 channels of the YAPP router
    channel_env channel_0;
    channel_env channel_1;
    channel_env channel_2;

    // Adding the hbus_env instance
    hbus_env hbus_e;

    // Adding the clk and rst instance
    clock_and_reset_env clock_and_reset_e;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void start_of_simulation_phase(uvm_phase phase);
        `uvm_info(get_type_name(), "Now in the start of simulation phase for tb", UVM_HIGH)        
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        // Create the yapp_env instance
        yapp_e = yapp_env::type_id::create("yapp_e", this);

        // Create the mc_seqr instance
        mc_seqr = router_mcsequencer::type_id::create("mc_seqr", this);
        
        // Create the channel_env instances for the 3 channels
        channel_0 = channel_env::type_id::create("channel_0", this);
        channel_1 = channel_env::type_id::create("channel_1", this);
        channel_2 = channel_env::type_id::create("channel_2", this);
        
        // Create the hbus_env instance
        hbus_e = hbus_env::type_id::create("hbus_e", this);
        
        // Create the clock_and_reset_env instance
        clock_and_reset_e = clock_and_reset_env::type_id::create("clock_and_reset_e", this);
        
        // Set the channel_id configuration for each channel
        uvm_config_int::set(this, "channel_0", "channel_id", 0);
        uvm_config_int::set(this, "channel_1", "channel_id", 1);
        uvm_config_int::set(this, "channel_2", "channel_id", 2);
        
        // Setting the master and slave configuration for the hbus_env
        uvm_config_int::set(this, "hbus_e", "num_masters", 1);
        uvm_config_int::set(this, "hbus_e", "num_slaves", 0);
        
        `uvm_info("ROUTER_TB", "Build phase of router_tb is being executed", UVM_HIGH)
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        // Connect the mc_seqr to the yapp_e sequencer
        mc_seqr.yapp_seqr = yapp_e.tx_agent.sequencer;

        // Connect the mc_seqr to the hbus_e sequencer
        mc_seqr.hbus_seqr = hbus_e.masters[0].sequencer;
    endfunction
endclass //router_tb extends uvm_env