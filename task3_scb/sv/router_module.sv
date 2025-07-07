`timescale 1ns/1ns
package router_module_pkg;
    `include "uvm_macros.svh"
    import uvm_pkg::*;
    import yapp_pkg::*;
    import hbus_pkg::*;
    `include "router_scoreboard.sv"
    `include "router_reference.sv"
    `include "router_module_env.sv"
endpackage