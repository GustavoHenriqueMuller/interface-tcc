vsim -voptargs=+acc work.tcc_tb

add wave -position insertpoint  \
sim:/tcc_tb/t_ACLK \
sim:/tcc_tb/t_AWADDR \
sim:/tcc_tb/t_AWREADY

add wave -position insertpoint  \
sim:/tcc_tb/t_RESET \
sim:/tcc_tb/t_RESETn

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
sim:/tcc_tb/u_TCC_TOP_MASTER/u_TCC_BACKEND_MASTER/u_TCC_BACKEND_MASTER_PACKETIZER_CONTROL/r_CURRENT_STATE

add wave -position insertpoint  \
sim:/tcc_tb/u_TCC_TOP_MASTER/w_BACKEND_DATA_IN \
sim:/tcc_tb/u_TCC_TOP_MASTER/w_BACKEND_LAST_IN \
sim:/tcc_tb/u_TCC_TOP_MASTER/w_BACKEND_READY_OUT \
sim:/tcc_tb/u_TCC_TOP_MASTER/w_BACKEND_VALID_IN

add wave -position insertpoint  \
sim:/tcc_tb/u_TCC_TOP_MASTER/u_TCC_BACKEND_MASTER/w_ARESET \
sim:/tcc_tb/u_TCC_TOP_MASTER/u_TCC_BACKEND_MASTER/w_FLIT \
sim:/tcc_tb/u_TCC_TOP_MASTER/u_TCC_BACKEND_MASTER/w_WRITE_BUFFER \
sim:/tcc_tb/u_TCC_TOP_MASTER/u_TCC_BACKEND_MASTER/w_WRITE_OK_BUFFER \
sim:/tcc_tb/u_TCC_TOP_MASTER/u_TCC_BACKEND_MASTER/w_READ_BUFFER \
sim:/tcc_tb/u_TCC_TOP_MASTER/u_TCC_BACKEND_MASTER/w_READ_OK_BUFFER

add wave -position insertpoint  \
sim:/tcc_tb/u_TCC_TOP_MASTER/u_TCC_BACKEND_MASTER/u_BUFFER_FIFO/data_o

add wave -position insertpoint  \
sim:/tcc_tb/u_TCC_TOP_MASTER/u_TCC_BACKEND_MASTER/u_BUFFER_FIFO/fifo/shift/fifo_r

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
sim:/tcc_tb/t_s_in_ack_o \
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