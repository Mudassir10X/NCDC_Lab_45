class yapp_base_seq extends uvm_sequence #(yapp_packet);
  
  // Required macro for sequences automation
  `uvm_object_utils(yapp_base_seq)

  // Constructor
  function new(string name="yapp_base_seq");
    super.new(name);
  endfunction

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

endclass : yapp_base_seq

//------------------------------------------------------------------------------
//
// SEQUENCE: yapp_5_packets
//
//  Configuration setting for this sequence
//    - update <path> to be hierarchial path to sequencer 
//
//  uvm_config_wrapper::set(this, "<path>.run_phase",
//                                 "default_sequence",
//                                 yapp_5_packets::get_type());
//
//------------------------------------------------------------------------------
class yapp_5_packets extends yapp_base_seq;
  
  // Required macro for sequences automation
  `uvm_object_utils(yapp_5_packets)

  // Constructor
  function new(string name="yapp_5_packets");
    super.new(name);
  endfunction

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "Executing yapp_5_packets sequence", UVM_LOW)
     repeat(5)
      `uvm_do(req)
  endtask
  
endclass : yapp_5_packets

class yapp_1_seq extends yapp_base_seq;
// Required macro for sequences automation
  `uvm_object_utils(yapp_1_seq)

  // Constructor
  function new(string name="yapp_1_seq");
    super.new(name);
  endfunction

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "Executing yapp_1_seq sequence", UVM_LOW)
    `uvm_do_with(req, {addr == 1;})
  endtask
endclass //yapp_1_seq extends yapp_base_seq

class yapp_012_seq extends yapp_base_seq;
// Required macro for sequences automation
  `uvm_object_utils(yapp_012_seq)

  // Constructor
  function new(string name="yapp_012_seq");
    super.new(name);
  endfunction

  // Sequence body definition
  virtual task body();
    short_yapp_packet s_packet;
    `uvm_info(get_type_name(), "Executing yapp_012_seq sequence", UVM_LOW)
    `uvm_do_with(req, {addr == 0;})
    `uvm_do_with(req, {addr == 1;})
    // `uvm_do_with(req, {addr == 2;})
    `uvm_create(s_packet)
    s_packet.invalid_addr_c.constraint_mode(0);
    `uvm_rand_send_with(s_packet, {addr == 2;});
  endtask
endclass //yapp_012_seq extends yapp_base_seq

class yapp_111_seq extends yapp_base_seq;
// Required macro for sequences automation
  `uvm_object_utils(yapp_111_seq)
  // yapp_1_seq seq1;

  // Constructor
  function new(string name="yapp_111_seq");
    super.new(name);
  endfunction

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "Executing yapp_111_seq sequence", UVM_LOW)
    repeat(3) begin
      yapp_1_seq seq1;
      seq1 = yapp_1_seq::type_id::create("seq1");
      `uvm_do(seq1)
    end
  endtask
endclass //yapp_111_seq extends yapp_base_seq

class yapp_repeat_addr_seq extends yapp_base_seq;
// Required macro for sequences automation
  `uvm_object_utils(yapp_repeat_addr_seq)
  bit [1:0] prev_addr;
  // Constructor
  function new(string name="yapp_repeat_addr_seq");
    super.new(name);
  endfunction

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "Executing yapp_repeat_addr_seq sequence", UVM_LOW)
    `uvm_do(req)
    prev_addr = req.addr;
    `uvm_do_with(req, {addr == prev_addr;})
  endtask
endclass //yapp_repeat_addr_seq extends yapp_base_seq

class yapp_incr_payload_seq extends yapp_base_seq;
// Required macro for sequences automation
  `uvm_object_utils(yapp_incr_payload_seq)
  yapp_packet yp;
  // Constructor
  function new(string name="yapp_incr_payload_seq");
    super.new(name);
  endfunction

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "Executing yapp_incr_payload_seq sequence", UVM_LOW)
    `uvm_create(req)
    assert(req.randomize());
    foreach (req.payload[i]) begin
      req.payload[i] = i; // Fill payload with incremental values
    end
    `uvm_send(req);
  endtask
endclass //yapp_incr_payload_seq extends yapp_base_seq

class yapp_rnd_seq extends yapp_base_seq;
// Required macro for sequences automation
  `uvm_object_utils(yapp_rnd_seq)
  rand int count;
  constraint count_c { count inside {[1:10]}; }

  // Constructor
  function new(string name="yapp_rnd_seq");
    super.new(name);
  endfunction

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "Executing yapp_rnd_seq sequence", UVM_LOW)
    repeat(count) begin
      `uvm_do(req)
      `uvm_info(get_type_name(), $sformatf("Sent packet #%d with addr %0d", count, req.addr), UVM_HIGH)
    end
  endtask
endclass //yapp_rnd_seq extends yapp_base_seq

class six_yapp_seq extends yapp_base_seq;
// Required macro for sequences automation
  `uvm_object_utils(six_yapp_seq)

  // Constructor
  function new(string name="six_yapp_seq");
    super.new(name);
  endfunction

  // Sequence body definition
  virtual task body();
    yapp_rnd_seq inst_yapp_rand_seq;
    `uvm_info(get_type_name(), "Executing six_yapp_seq sequence", UVM_LOW)
    `uvm_do_with(inst_yapp_rand_seq, {count == 6;})
  endtask
endclass //six_yapp_seq extends yapp_base_seq

class yapp_exhaustive_seq extends yapp_base_seq;
  `uvm_object_utils(yapp_exhaustive_seq)

  // This test will run all the above tests
  yapp_5_packets        inst_yapp_5_packets;
  yapp_1_seq            inst_yapp_1_seq;
  yapp_012_seq          inst_yapp_012_seq;
  yapp_111_seq          inst_yapp_111_seq;
  yapp_repeat_addr_seq  inst_yapp_repeat_addr_seq;
  yapp_incr_payload_seq inst_yapp_incr_payload_seq;
  yapp_rnd_seq          inst_yapp_rnd_seq;
  six_yapp_seq          inst_six_yapp_seq;


  function new(string name = "yapp_exhaustive_seq");
    super.new(name);
  endfunction

  // Sequence body definition
  virtual task body();
    inst_yapp_5_packets         = yapp_5_packets::type_id::create("inst_yapp_5_packets");
    inst_yapp_1_seq             = yapp_1_seq::type_id::create("inst_yapp_1_seq");
    inst_yapp_012_seq           = yapp_012_seq::type_id::create("inst_yapp_012_seq");
    inst_yapp_111_seq           = yapp_111_seq::type_id::create("inst_yapp_111_seq");
    inst_yapp_repeat_addr_seq   = yapp_repeat_addr_seq::type_id::create("inst_yapp_repeat_addr_seq");
    inst_yapp_incr_payload_seq  = yapp_incr_payload_seq::type_id::create("inst_yapp_incr_payload_seq");
    inst_yapp_rnd_seq           = yapp_rnd_seq::type_id::create("inst_yapp_rnd_seq");
    inst_six_yapp_seq           = six_yapp_seq::type_id::create("inst_six_yapp_seq");
    `uvm_do(inst_yapp_5_packets)
    `uvm_do(inst_yapp_1_seq)
    `uvm_do(inst_yapp_012_seq)
    `uvm_do(inst_yapp_111_seq)
    `uvm_do(inst_yapp_repeat_addr_seq)
    `uvm_do(inst_yapp_incr_payload_seq)
    `uvm_do(inst_yapp_rnd_seq)
    `uvm_do(inst_six_yapp_seq)
  endtask
endclass

class yapp_exhaustive_all_seq extends yapp_base_seq;
  `uvm_object_utils(yapp_exhaustive_all_seq)

  function new(string name = "yapp_exhaustive_all_seq");
    super.new(name);
  endfunction

  // Sequence body definition
  virtual task body();
    short_yapp_packet s_packet;
    int Length;
    `uvm_info(get_type_name(), "Executing yapp_exhaustive_all_seq sequence", UVM_LOW)
    
    for (Length = 1; Length < 23; Length++) begin
      `uvm_create(s_packet)
      s_packet.invalid_addr_c.constraint_mode(0);
      s_packet.addr_c.constraint_mode(0);
      s_packet.packet_length_c.constraint_mode(0);
      s_packet.parity_c.constraint_mode(0);
      if (s_packet.randomize() with {addr == 0; length == Length; parity_type dist {GOOD_PARITY :=80, BAD_PARITY := 20};})
        `uvm_send(s_packet)
      else 
        $fatal("Randomization failed for s_packet with addr 0 and length %0d", Length);
    end
    for (Length = 1; Length < 23; Length++) begin
      `uvm_create(s_packet)
      s_packet.invalid_addr_c.constraint_mode(0);
      s_packet.addr_c.constraint_mode(0);
      s_packet.packet_length_c.constraint_mode(0);
      s_packet.parity_c.constraint_mode(0);
      if (s_packet.randomize() with {addr == 1; length == Length; parity_type dist {GOOD_PARITY :=80, BAD_PARITY := 20};})
        `uvm_send(s_packet)
      else 
        $fatal("Randomization failed for s_packet with addr 0 and length %0d", Length);
    end
    for (Length = 1; Length < 23; Length++) begin
      `uvm_create(s_packet)
      s_packet.invalid_addr_c.constraint_mode(0);
      s_packet.addr_c.constraint_mode(0);
      s_packet.packet_length_c.constraint_mode(0);
      s_packet.parity_c.constraint_mode(0);
      if (s_packet.randomize() with {addr == 2; length == Length; parity_type dist {GOOD_PARITY :=80, BAD_PARITY := 20};})
        `uvm_send(s_packet)
      else 
        $fatal("Randomization failed for s_packet with addr 0 and length %0d", Length);
    end
    for (Length = 1; Length < 23; Length++) begin
      `uvm_create(s_packet)
      s_packet.invalid_addr_c.constraint_mode(0);
      s_packet.addr_c.constraint_mode(0);
      s_packet.packet_length_c.constraint_mode(0);
      s_packet.parity_c.constraint_mode(0);
      if (s_packet.randomize() with {addr == 3; length == Length; parity_type dist {GOOD_PARITY :=80, BAD_PARITY := 20};})
        `uvm_send(s_packet)
      else 
        $fatal("Randomization failed for s_packet with addr 0 and length %0d", Length);
    end
  endtask
endclass