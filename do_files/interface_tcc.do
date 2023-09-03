vlib work

vcom -2008 ../hdl/basic/mux4.vhd

vcom -2008 ../hdl/tcc_package.vhd

vcom -2008 ../hdl/master/frontend/tcc_frontend_master_data_multiplexer.vhd
vcom -2008 ../hdl/master/frontend/tcc_frontend_master_send_control.vhd
vcom -2008 ../hdl/master/frontend/tcc_frontend_master.vhd

vcom -2008 ../hdl/master/backend/tcc_backend_master_routing_table.vhd
vcom -2008 ../hdl/master/backend/tcc_backend_master_packetizer_control.vhd
vcom -2008 ../hdl/master/backend/tcc_backend_master_packetizer_datapath.vhd
vcom -2008 ../hdl/master/backend/tcc_backend_master_send_control.vhd
vcom -2008 ../hdl/master/backend/tcc_backend_master.vhd

vcom -2008 ../hdl/master/tcc_top_master.vhd

vcom -2008 ../hdl/master/test/tb_master_frontend.vhd
vcom -2008 ../hdl/master/test/tb_master_injection_read.vhd
vcom -2008 ../hdl/master/test/tb_master_injection_write.vhd

vcom -2008 ../hdl/master/test/test_tg/xina_tg_tm.vhd
vcom -2008 ../hdl/master/test/test_tg/tg_mo.vhd
vcom -2008 ../hdl/master/test/test_tg/tg_me.vhd
vcom -2008 ../hdl/master/test/test_tg/tm_me.vhd
vcom -2008 ../hdl/master/test/test_tg/tm_mo.vhd
vcom -2008 ../hdl/master/test/test_tg/tm_group.vhd
vcom -2008 ../hdl/master/test/test_tg/tg_group.vhd
vcom -2008 ../hdl/master/test/test_tg/tg_tb.vhd