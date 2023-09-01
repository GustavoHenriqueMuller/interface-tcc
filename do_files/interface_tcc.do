vlib work

vcom -2008 ../hdl/tcc_package.vhd

vcom -2008 ../hdl/frontend/tcc_frontend_master_send_control.vhd
vcom -2008 ../hdl/frontend/tcc_frontend_master.vhd

vcom -2008 ../hdl/backend/tcc_backend_master_packetizer.vhd
vcom -2008 ../hdl/backend/tcc_backend_master_send_control.vhd
vcom -2008 ../hdl/backend/tcc_backend_master.vhd

vcom -2008 ../hdl/tcc_top_master.vhd

vcom -2008 ../hdl/test/tcc_frontend_master_tb.vhd
vcom -2008 ../hdl/test/tcc_tb.vhd



vcom -2008 ../hdl/test_tg/tg_mo.vhd
vcom -2008 ../hdl/test_tg/tg_tb.vhd











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
sim:/tcc_tb/u_TCC_TOP_MASTER/u_TCC_FRONTEND_MASTER/u_tcc_FRONTEND_MASTER_SEND_CONTROL/r_CURRENT_STATE

add wave -position insertpoint  \
sim:/tcc_tb/u_TCC_TOP_MASTER/u_TCC_BACKEND_MASTER/u_TCC_BACKEND_MASTER_SEND_CONTROL/r_CURRENT_STATE

add wave -position insertpoint  \
sim:/tcc_tb/u_TCC_TOP_MASTER/u_TCC_BACKEND_MASTER/u_TCC_BACKEND_MASTER_PACKETIZER/r_CURRENT_STATE

add wave -position insertpoint  \
sim:/tcc_tb/u_TCC_TOP_MASTER/w_BACKEND_DATA_IN \
sim:/tcc_tb/u_TCC_TOP_MASTER/w_BACKEND_LAST_IN \
sim:/tcc_tb/u_TCC_TOP_MASTER/w_BACKEND_READY_OUT \
sim:/tcc_tb/u_TCC_TOP_MASTER/w_BACKEND_VALID_IN

add wave -position insertpoint  \
sim:/tcc_tb/u_TCC_TOP_MASTER/u_TCC_BACKEND_MASTER/u_BUFFER_FIFO/data_i

add wave -position insertpoint  \
sim:/tcc_tb/t_l_in_data_i \
sim:/tcc_tb/t_l_in_val_i \
sim:/tcc_tb/t_l_in_ack_o \
sim:/tcc_tb/t_l_out_data_o \
sim:/tcc_tb/t_l_out_val_o \
sim:/tcc_tb/t_l_out_ack_i

add wave -position insertpoint  \
sim:/tcc_tb/t_n_in_data_i \
sim:/tcc_tb/t_n_in_val_i \
sim:/tcc_tb/t_n_in_ack_o \
sim:/tcc_tb/t_n_out_data_o \
sim:/tcc_tb/t_n_out_val_o \
sim:/tcc_tb/t_n_out_ack_i

add wave -position insertpoint  \
sim:/tcc_tb/t_e_in_data_i \
sim:/tcc_tb/t_e_in_val_i \
sim:/tcc_tb/t_e_in_ack_o \
sim:/tcc_tb/t_e_out_data_o \
sim:/tcc_tb/t_e_out_val_o \
sim:/tcc_tb/t_e_out_ack_i

add wave -position insertpoint  \
sim:/tcc_tb/t_s_in_data_i \
sim:/tcc_tb/t_s_in_val_i \
sim:/tcc_tb/t_s_l_in_ack_o \
sim:/tcc_tb/t_s_out_data_o \
sim:/tcc_tb/t_s_out_val_o \
sim:/tcc_tb/t_s_out_ack_i

add wave -position insertpoint  \
sim:/tcc_tb/t_w_in_data_i \
sim:/tcc_tb/t_w_in_val_i \
sim:/tcc_tb/t_w_in_ack_o \
sim:/tcc_tb/t_w_out_data_o \
sim:/tcc_tb/t_w_out_val_o \
sim:/tcc_tb/t_w_out_ack_i