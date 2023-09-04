vsim -voptargs=+acc -debugDB work.tb_master_injection_read

add wave -position insertpoint  \
sim:/tb_master_injection_read/t_ACLK \
sim:/tb_master_injection_read/t_ARADDR \
sim:/tb_master_injection_read/t_AR_ID \
sim:/tb_master_injection_read/t_ARLEN \
sim:/tb_master_injection_read/t_ARSIZE \
sim:/tb_master_injection_read/t_ARBURST \
sim:/tb_master_injection_read/t_ARVALID \
sim:/tb_master_injection_read/t_ARREADY

add wave -position insertpoint  \
sim:/tb_master_injection_read/t_RESET \
sim:/tb_master_injection_read/t_RESETn

add wave -position insertpoint  \
sim:/tb_master_injection_read/t_WDATA \
sim:/tb_master_injection_read/t_WLAST \
sim:/tb_master_injection_read/t_WREADY \
sim:/tb_master_injection_read/t_WVALID

add wave -position insertpoint  \
sim:/tb_master_injection_read/u_TOP_MASTER/u_FRONTEND_MASTER/u_FRONTEND_MASTER_SEND_CONTROL/r_CURRENT_STATE

add wave -position insertpoint  \
sim:/tb_master_injection_read/u_TOP_MASTER/u_BACKEND_MASTER/u_BACKEND_MASTER_PACKETIZER_CONTROL/r_CURRENT_STATE

add wave -position insertpoint  \
sim:/tb_master_injection_read/u_TOP_MASTER/u_BACKEND_MASTER/u_BACKEND_MASTER_SEND_CONTROL/r_CURRENT_STATE

add wave -position insertpoint  \
sim:/tb_master_injection_read/u_TOP_MASTER/w_BACKEND_DATA_IN \
sim:/tb_master_injection_read/u_TOP_MASTER/w_BACKEND_LAST_IN \
sim:/tb_master_injection_read/u_TOP_MASTER/w_BACKEND_READY_OUT \
sim:/tb_master_injection_read/u_TOP_MASTER/w_BACKEND_VALID_IN \
sim:/tb_master_injection_read/u_TOP_MASTER/w_BACKEND_ID_IN

add wave -position insertpoint  \
sim:/tb_master_injection_read/u_TOP_MASTER/u_BACKEND_MASTER/w_ARESET \
sim:/tb_master_injection_read/u_TOP_MASTER/u_BACKEND_MASTER/w_FLIT \
sim:/tb_master_injection_read/u_TOP_MASTER/u_BACKEND_MASTER/w_WRITE_BUFFER \
sim:/tb_master_injection_read/u_TOP_MASTER/u_BACKEND_MASTER/w_WRITE_OK_BUFFER \
sim:/tb_master_injection_read/u_TOP_MASTER/u_BACKEND_MASTER/w_READ_BUFFER \
sim:/tb_master_injection_read/u_TOP_MASTER/u_BACKEND_MASTER/w_READ_OK_BUFFER








add wave -position insertpoint  \
sim:/tb_master_injection_read/t_l_in_data_i \
sim:/tb_master_injection_read/t_l_in_val_i \
sim:/tb_master_injection_read/t_l_in_ack_o \
sim:/tb_master_injection_read/t_l_out_data_o \
sim:/tb_master_injection_read/t_l_out_val_o \
sim:/tb_master_injection_read/t_l_out_ack_i

add wave -position insertpoint  \
sim:/tb_master_injection_read/t_n_in_data_i \
sim:/tb_master_injection_read/t_n_in_val_i \
sim:/tb_master_injection_read/t_n_in_ack_o \
sim:/tb_master_injection_read/t_n_out_data_o \
sim:/tb_master_injection_read/t_n_out_val_o \
sim:/tb_master_injection_read/t_n_out_ack_i

add wave -position insertpoint  \
sim:/tb_master_injection_read/t_e_in_data_i \
sim:/tb_master_injection_read/t_e_in_val_i \
sim:/tb_master_injection_read/t_e_in_ack_o \
sim:/tb_master_injection_read/t_e_out_data_o \
sim:/tb_master_injection_read/t_e_out_val_o \
sim:/tb_master_injection_read/t_e_out_ack_i

add wave -position insertpoint  \
sim:/tb_master_injection_read/t_s_in_data_i \
sim:/tb_master_injection_read/t_s_in_val_i \
sim:/tb_master_injection_read/t_s_in_ack_o \
sim:/tb_master_injection_read/t_s_out_data_o \
sim:/tb_master_injection_read/t_s_out_val_o \
sim:/tb_master_injection_read/t_s_out_ack_i

add wave -position insertpoint  \
sim:/tb_master_injection_read/t_w_in_data_i \
sim:/tb_master_injection_read/t_w_in_val_i \
sim:/tb_master_injection_read/t_w_in_ack_o \
sim:/tb_master_injection_read/t_w_out_data_o \
sim:/tb_master_injection_read/t_w_out_val_o \
sim:/tb_master_injection_read/t_w_out_ack_i