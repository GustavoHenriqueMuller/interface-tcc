vlib work

vcom -2008 ../hdl/tcc_package.vhd

vcom -2008 ../hdl/frontend/tcc_frontend_master_send_control.vhd
vcom -2008 ../hdl/frontend/tcc_frontend_master.vhd

vcom -2008 ../hdl/backend/tcc_backend_master_send_control.vhd
vcom -2008 ../hdl/backend/tcc_backend_master.vhd

vcom -2008 ../hdl/tcc_top_master.vhd

vcom -2008 ../hdl/test/tcc_frontend_master_tb.vhd
vcom -2008 ../hdl/test/tcc_tb.vhd

vsim work.tcc_tb

add wave -position insertpoint  \
sim:/tcc_tb/t_ACLK \
sim:/tcc_tb/t_ARADDR \
sim:/tcc_tb/t_ARREADY \
sim:/tcc_tb/t_ARVALID \
sim:/tcc_tb/t_AWREADY \
sim:/tcc_tb/t_AWVALID \
sim:/tcc_tb/t_BVALID

add wave -position insertpoint  \
sim:/tcc_tb/t_RESET \
sim:/tcc_tb/t_RESETn \
sim:/tcc_tb/t_RLAST \
sim:/tcc_tb/t_RVALID

add wave -position insertpoint  \
sim:/tcc_tb/t_WDATA \
sim:/tcc_tb/t_WLAST \
sim:/tcc_tb/t_WREADY \
sim:/tcc_tb/t_WVALID

add wave -position insertpoint  \
sim:/tcc_tb/t_l_ack_in \
sim:/tcc_tb/t_l_ack_out \
sim:/tcc_tb/t_l_data_in \
sim:/tcc_tb/t_l_data_out \
sim:/tcc_tb/t_l_val_in \
sim:/tcc_tb/t_l_val_out

add wave -position insertpoint  \
sim:/tcc_tb/t_e_ack_in \
sim:/tcc_tb/t_e_ack_out \
sim:/tcc_tb/t_e_data_in \
sim:/tcc_tb/t_e_data_out \
sim:/tcc_tb/t_e_val_in \
sim:/tcc_tb/t_e_val_out