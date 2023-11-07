vsim -voptargs=+acc -debugDB work.tb_master_injection_write

#---------------------------------------------------------------------------------------------
# AXI/interface signals.

add wave -position insertpoint  \
sim:/tb_master_injection_write/t_ACLK \
sim:/tb_master_injection_write/t_AWADDR \
sim:/tb_master_injection_write/t_AWID \
sim:/tb_master_injection_write/t_AWLEN \
sim:/tb_master_injection_write/t_AWSIZE \
sim:/tb_master_injection_write/t_AWBURST \
sim:/tb_master_injection_write/t_AWVALID \
sim:/tb_master_injection_write/t_AWREADY

add wave -position insertpoint  \
sim:/tb_master_injection_write/t_CORRUPT_PACKET

add wave -position insertpoint  \
sim:/tb_master_injection_write/t_RESET \
sim:/tb_master_injection_write/t_RESETn

add wave -position insertpoint  \
sim:/tb_master_injection_write/t_WDATA \
sim:/tb_master_injection_write/t_WLAST \
sim:/tb_master_injection_write/t_WREADY \
sim:/tb_master_injection_write/t_WVALID

add wave -position insertpoint  \
sim:/tb_master_injection_write/u_TOP_MASTER/u_BACKEND/u_INJECTION/u_PACKETIZER_CONTROL/u_PACKETIZER_CONTROL_NORMAL/r_STATE

add wave -position insertpoint  \
sim:/tb_master_injection_write/u_TOP_MASTER/w_DATA_SEND \
sim:/tb_master_injection_write/u_TOP_MASTER/w_LAST_SEND_DATA \
sim:/tb_master_injection_write/u_TOP_MASTER/w_READY_SEND_DATA \
sim:/tb_master_injection_write/u_TOP_MASTER/w_VALID_SEND_DATA \
sim:/tb_master_injection_write/u_TOP_MASTER/w_ID

add wave -position insertpoint  \
sim:/tb_master_injection_write/u_TOP_MASTER/u_BACKEND/u_INJECTION/w_ARESET \
sim:/tb_master_injection_write/u_TOP_MASTER/u_BACKEND/u_INJECTION/w_FLIT \
sim:/tb_master_injection_write/u_TOP_MASTER/u_BACKEND/u_INJECTION/w_WRITE_BUFFER \
sim:/tb_master_injection_write/u_TOP_MASTER/u_BACKEND/u_INJECTION/w_WRITE_OK_BUFFER \
sim:/tb_master_injection_write/u_TOP_MASTER/u_BACKEND/u_INJECTION/w_READ_BUFFER \
sim:/tb_master_injection_write/u_TOP_MASTER/u_BACKEND/u_INJECTION/w_READ_OK_BUFFER

add wave -position insertpoint  \
sim:/tb_master_injection_write/u_TOP_MASTER/u_BACKEND/u_INJECTION/u_BUFFER_FIFO/u_BUFFER_FIFO_NORMAL/w_FIFO

#---------------------------------------------------------------------------------------------
# Router signals.

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