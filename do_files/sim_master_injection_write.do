vsim -voptargs=+acc work.tb_master_injection_write

add wave -position insertpoint  \
sim:/tb_master_injection_write/t_ACLK \
sim:/tb_master_injection_write/t_AWADDR \
sim:/tb_master_injection_write/t_AW_ID \
sim:/tb_master_injection_write/t_AWLEN \
sim:/tb_master_injection_write/t_AWSIZE \
sim:/tb_master_injection_write/t_AWBURST \
sim:/tb_master_injection_write/t_AWVALID \
sim:/tb_master_injection_write/t_AWREADY

add wave -position insertpoint  \
sim:/tb_master_injection_write/t_RESET \
sim:/tb_master_injection_write/t_RESETn

add wave -position insertpoint  \
sim:/tb_master_injection_write/t_WDATA \
sim:/tb_master_injection_write/t_WLAST \
sim:/tb_master_injection_write/t_WREADY \
sim:/tb_master_injection_write/t_WVALID

add wave -position insertpoint  \
sim:/tb_master_injection_write/u_TCC_TOP_MASTER/u_TCC_FRONTEND_MASTER/u_tcc_FRONTEND_MASTER_SEND_CONTROL/r_CURRENT_STATE

add wave -position insertpoint  \
sim:/tb_master_injection_write/u_TCC_TOP_MASTER/u_TCC_BACKEND_MASTER/u_TCC_BACKEND_MASTER_PACKETIZER_CONTROL/r_CURRENT_STATE

add wave -position insertpoint  \
sim:/tb_master_injection_write/u_TCC_TOP_MASTER/u_TCC_BACKEND_MASTER/u_TCC_BACKEND_MASTER_SEND_CONTROL/r_CURRENT_STATE

add wave -position insertpoint  \
sim:/tb_master_injection_write/u_TCC_TOP_MASTER/w_BACKEND_DATA_IN \
sim:/tb_master_injection_write/u_TCC_TOP_MASTER/w_BACKEND_LAST_IN \
sim:/tb_master_injection_write/u_TCC_TOP_MASTER/w_BACKEND_READY_OUT \
sim:/tb_master_injection_write/u_TCC_TOP_MASTER/w_BACKEND_VALID_IN \
sim:/tb_master_injection_write/u_TCC_TOP_MASTER/w_BACKEND_ID_IN

add wave -position insertpoint  \
sim:/tb_master_injection_write/u_TCC_TOP_MASTER/u_TCC_BACKEND_MASTER/w_ARESET \
sim:/tb_master_injection_write/u_TCC_TOP_MASTER/u_TCC_BACKEND_MASTER/w_FLIT \
sim:/tb_master_injection_write/u_TCC_TOP_MASTER/u_TCC_BACKEND_MASTER/w_WRITE_BUFFER \
sim:/tb_master_injection_write/u_TCC_TOP_MASTER/u_TCC_BACKEND_MASTER/w_WRITE_OK_BUFFER \
sim:/tb_master_injection_write/u_TCC_TOP_MASTER/u_TCC_BACKEND_MASTER/w_READ_BUFFER \
sim:/tb_master_injection_write/u_TCC_TOP_MASTER/u_TCC_BACKEND_MASTER/w_READ_OK_BUFFER








add wave -position insertpoint  \
sim:/tb_master_injection_write/t_l_in_data_i \
sim:/tb_master_injection_write/t_l_in_val_i \
sim:/tb_master_injection_write/t_l_in_ack_o \
sim:/tb_master_injection_write/t_l_out_data_o \
sim:/tb_master_injection_write/t_l_out_val_o \
sim:/tb_master_injection_write/t_l_out_ack_i

add wave -position insertpoint  \
sim:/tb_master_injection_write/t_n_in_data_i \
sim:/tb_master_injection_write/t_n_in_val_i \
sim:/tb_master_injection_write/t_n_in_ack_o \
sim:/tb_master_injection_write/t_n_out_data_o \
sim:/tb_master_injection_write/t_n_out_val_o \
sim:/tb_master_injection_write/t_n_out_ack_i

add wave -position insertpoint  \
sim:/tb_master_injection_write/t_e_in_data_i \
sim:/tb_master_injection_write/t_e_in_val_i \
sim:/tb_master_injection_write/t_e_in_ack_o \
sim:/tb_master_injection_write/t_e_out_data_o \
sim:/tb_master_injection_write/t_e_out_val_o \
sim:/tb_master_injection_write/t_e_out_ack_i

add wave -position insertpoint  \
sim:/tb_master_injection_write/t_s_in_data_i \
sim:/tb_master_injection_write/t_s_in_val_i \
sim:/tb_master_injection_write/t_s_in_ack_o \
sim:/tb_master_injection_write/t_s_out_data_o \
sim:/tb_master_injection_write/t_s_out_val_o \
sim:/tb_master_injection_write/t_s_out_ack_i

add wave -position insertpoint  \
sim:/tb_master_injection_write/t_w_in_data_i \
sim:/tb_master_injection_write/t_w_in_val_i \
sim:/tb_master_injection_write/t_w_in_ack_o \
sim:/tb_master_injection_write/t_w_out_data_o \
sim:/tb_master_injection_write/t_w_out_val_o \
sim:/tb_master_injection_write/t_w_out_ack_i