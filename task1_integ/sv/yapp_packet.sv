// Define your enumerated type(s) here
typedef enum bit { 
  GOOD_PARITY, 
  BAD_PARITY 
  } parity_type_e;

class yapp_packet extends uvm_sequence_item;

  // Follow the lab instructions to create the packet.
  // Place the packet declarations in the following order:

  // Define protocol data
  rand  bit   [1:0]   addr;         // Address field
  rand  bit   [5:0]   length;       // Packet length
  rand  bit   [7:0]   payload[];    // Data field
  rand  parity_type_e parity_type;  // Parity type (GOOD_PARITY or BAD_PARITY)
        byte          parity;       // Parity field

  // Registering in the factory
  `uvm_object_utils_begin(yapp_packet)
  `uvm_field_int      (addr,    UVM_ALL_ON)
  `uvm_field_int      (length,  UVM_ALL_ON)
  `uvm_field_array_int(payload, UVM_ALL_ON)
  `uvm_field_int      (parity,  UVM_ALL_ON)
  `uvm_field_enum     (parity_type_e, parity_type, UVM_ALL_ON)
  `uvm_object_utils_end
  
  // Define control knobs
  rand bit [4:0] packet_delay; // Random delay for the packet between 1 && 20
  constraint packet_delay_c {
    packet_delay >= 1 && packet_delay <= 20; // Delay must be between 1 and 20
  }
  // Enable automation of the packet's fields

  // Define packet constraints
  constraint addr_c {
    addr inside {2'b00, 2'b01, 2'b10}; // Address can be 00, 01, or 10
  } 

  constraint length_c {
    length >= 1 && length < 64; // Length must be between 1 and 64
  }

  constraint payload_c {
    // Payload must be of length equal to 'length' and contain valid data
    payload.size() == length;
  }
  constraint parity_c {
    // Parity should be distributed with ratio of 5:1 for good and bad parity
    parity_type dist { 
      GOOD_PARITY := 5, 
      BAD_PARITY  := 1 
    };
  }

  function new(string name = "yapp_packet");
    super.new(name);    
  endfunction

  // Add methods for parity calculation and class construction
  function byte calc_parity();
    byte p = 0;
    foreach (payload[i]) begin
      p ^= payload[i]; // XOR each byte in the payload
    end

    p ^= {length, addr}; // XOR Header fields (length and addr) with payload parity
    return p;
  endfunction

  function void set_parity();
    if (parity_type == GOOD_PARITY) begin
      parity = calc_parity(); // Calculate parity for good parity
    end else begin
      parity = calc_parity() ^ 8'hFF; // Invert parity for bad parity
    end
  endfunction

  function post_randomize();
    set_parity();
  endfunction

endclass: yapp_packet

class short_yapp_packet extends yapp_packet;
    `uvm_object_utils_begin(short_yapp_packet)
    `uvm_object_utils_end

    constraint packet_length_c { length inside {[1:15]};}
    constraint invalid_addr_c { addr != 2'd2;}
    

    function new(string name = "short_yapp_packet");
        super.new(name);
    endfunction //new()
endclass //short_yapp_packet extends yapp_packet