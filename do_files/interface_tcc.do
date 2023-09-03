vlib work

vcom -2008 ../hdl/basic/mux4.vhd

vcom -2008 ../hdl/tcc_package.vhd

vcom -2008 ../hdl/frontend/tcc_frontend_master_data_multiplexer.vhd
vcom -2008 ../hdl/frontend/tcc_frontend_master_send_control.vhd
vcom -2008 ../hdl/frontend/tcc_frontend_master.vhd

vcom -2008 ../hdl/backend/tcc_backend_master_packetizer_control.vhd
vcom -2008 ../hdl/backend/tcc_backend_master_packetizer_datapath.vhd
vcom -2008 ../hdl/backend/tcc_backend_master_send_control.vhd
vcom -2008 ../hdl/backend/tcc_backend_master.vhd

vcom -2008 ../hdl/tcc_top_master.vhd

vcom -2008 ../hdl/test/tcc_frontend_master_tb.vhd
vcom -2008 ../hdl/test/tcc_tb.vhd

vcom -2008 ../hdl/test/test_tg/xina_tg_tm.vhd
vcom -2008 ../hdl/test/test_tg/tg_mo.vhd
vcom -2008 ../hdl/test/test_tg/tg_me.vhd
vcom -2008 ../hdl/test/test_tg/tm_me.vhd
vcom -2008 ../hdl/test/test_tg/tm_mo.vhd
vcom -2008 ../hdl/test/test_tg/tm_group.vhd
vcom -2008 ../hdl/test/test_tg/tg_group.vhd
vcom -2008 ../hdl/test/test_tg/tg_tb.vhd