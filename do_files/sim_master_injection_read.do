vsim -voptargs=+acc -debugDB work.tb_master_injection_read

#---------------------------------------------------------------------------------------------
# AXI/interface signals.

add wave -position insertpoint  \
sim:/tb_master_injection_read/t_ACLK \
sim:/tb_master_injection_read/t_ARADDR \
sim:/tb_master_injection_read/t_ARID \
sim:/tb_master_injection_read/t_ARLEN \
sim:/tb_master_injection_read/t_ARSIZE \
sim:/tb_master_injection_read/t_ARBURST \
sim:/tb_master_injection_read/t_ARVALID \
sim:/tb_master_injection_read/t_ARREADY

add wave -position insertpoint  \
sim:/tb_master_injection_read/t_CORRUPT_PACKET

add wave -position insertpoint  \
sim:/tb_master_injection_read/t_RESET \
sim:/tb_master_injection_read/t_RESETn

add wave -position insertpoint  \
sim:/tb_master_injection_read/u_TOP_MASTER/u_BACKEND/u_INJECTION/u_PACKETIZER_CONTROL/r_STATE

add wave -position insertpoint  \
sim:/tb_master_injection_read/u_TOP_MASTER/w_DATA_SEND \
sim:/tb_master_injection_read/u_TOP_MASTER/w_LAST_SEND_DATA \
sim:/tb_master_injection_read/u_TOP_MASTER/w_READY_SEND_DATA \
sim:/tb_master_injection_read/u_TOP_MASTER/w_VALID_SEND_DATA \
sim:/tb_master_injection_read/u_TOP_MASTER/w_ID

add wave -position insertpoint  \
sim:/tb_master_injection_read/u_TOP_MASTER/u_BACKEND/u_INJECTION/w_ARESET \
sim:/tb_master_injection_read/u_TOP_MASTER/u_BACKEND/u_INJECTION/w_FLIT \
sim:/tb_master_injection_read/u_TOP_MASTER/u_BACKEND/u_INJECTION/w_WRITE_BUFFER \
sim:/tb_master_injection_read/u_TOP_MASTER/u_BACKEND/u_INJECTION/w_WRITE_OK_BUFFER \
sim:/tb_master_injection_read/u_TOP_MASTER/u_BACKEND/u_INJECTION/w_READ_BUFFER \
sim:/tb_master_injection_read/u_TOP_MASTER/u_BACKEND/u_INJECTION/w_READ_OK_BUFFER

add wave -position insertpoint  \
sim:/tb_master_injection_read/u_TOP_MASTER/u_BACKEND/u_INJECTION/u_BUFFER_FIFO/fifo/shift/fifo_r

#---------------------------------------------------------------------------------------------
# Router signals.

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