#!/bin/csh

source ~/cshrc

xrun -access +rwc -uvm -f ../task2_scb/tb/file.f \
    +UVM_TESTNAME=test_uvc_integration \
    -top tb_top \
    -log_xmelab xmelab.log \
    -log_xmsim xmsim.log \
    -timescale 1ns/1ns \
    +SVSEED=random \
    +UVM_VERBOSITY=UVM_HIGH #-gui