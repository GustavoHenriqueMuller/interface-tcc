vlib work

vcom -2008 ../hdl/tcc_package.vhd

vcom -2008 ../hdl/basic/mux4.vhd
vcom -2008 ../hdl/basic/mux5.vhd

vcom -2008 ../hdl/common/send_control.vhd
vcom -2008 ../hdl/common/receive_control.vhd








vcom -2008 ../hdl/master/frontend/frontend_master.vhd

vcom -2008 ../hdl/master/backend/injection/backend_master_routing_table.vhd
vcom -2008 ../hdl/master/backend/injection/backend_master_packetizer_control.vhd
vcom -2008 ../hdl/master/backend/injection/backend_master_packetizer_datapath.vhd
vcom -2008 ../hdl/master/backend/injection/backend_master_injection.vhd

vcom -2008 ../hdl/master/backend/reception/backend_master_depacketizer_control.vhd
vcom -2008 ../hdl/master/backend/reception/backend_master_reception.vhd

vcom -2008 ../hdl/master/backend/backend_master.vhd

vcom -2008 ../hdl/master/tcc_top_master.vhd

vcom -2008 ../hdl/master/test/injection/tb_master_injection_read.vhd
vcom -2008 ../hdl/master/test/injection/tb_master_injection_write.vhd

vcom -2008 ../hdl/master/test/reception/write_response_injector.vhd
vcom -2008 ../hdl/master/test/reception/tb_master_reception_write.vhd
vcom -2008 ../hdl/master/test/reception/read_response_injector.vhd
vcom -2008 ../hdl/master/test/reception/tb_master_reception_read.vhd








vcom -2008 ../hdl/slave/frontend/frontend_slave.vhd

vcom -2008 ../hdl/slave/backend/reception/backend_slave_depacketizer_control.vhd
vcom -2008 ../hdl/slave/backend/reception/backend_slave_reception.vhd

vcom -2008 ../hdl/slave/backend/injection/backend_slave_packetizer_control.vhd
vcom -2008 ../hdl/slave/backend/injection/backend_slave_packetizer_datapath.vhd
vcom -2008 ../hdl/slave/backend/injection/backend_slave_injection.vhd

vcom -2008 ../hdl/slave/backend/backend_slave.vhd

vcom -2008 ../hdl/slave/tcc_top_slave.vhd

vcom -2008 ../hdl/slave/test/read_request_injector.vhd
vcom -2008 ../hdl/slave/test/tb_slave_read.vhd
vcom -2008 ../hdl/slave/test/write_request_injector.vhd
vcom -2008 ../hdl/slave/test/tb_slave_write.vhd

