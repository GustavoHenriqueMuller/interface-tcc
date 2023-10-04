vsim -voptargs=+acc -debugDB work.tb_slave_read

#---------------------------------------------------------------------------------------------
# AXI/interface signals.

add wave -position insertpoint  \
sim:/tb_slave_read/t_ACLK \
sim:/tb_slave_read/t_RESETn

add wave -position insertpoint  \
sim:/tb_slave_read/t_ARVALID \
sim:/tb_slave_read/t_ARREADY \
sim:/tb_slave_read/t_ARID \
sim:/tb_slave_read/t_ARADDR \
sim:/tb_slave_read/t_ARLEN \
sim:/tb_slave_read/t_ARSIZE \
sim:/tb_slave_read/t_ARBURST \
sim:/tb_slave_read/t_RVALID \
sim:/tb_slave_read/t_RREADY \
sim:/tb_slave_read/t_RDATA \
sim:/tb_slave_read/t_RLAST \
sim:/tb_slave_read/t_RRESP

add wave -position insertpoint  \
sim:/tb_slave_read/u_TOP_SLAVE/u_BACKEND/u_INJECTION/u_PACKETIZER_CONTROL/r_STATE

add wave -position insertpoint  \
sim:/tb_slave_read/u_TOP_SLAVE/u_BACKEND/u_RECEPTION/u_DEPACKETIZER_CONTROL/r_STATE

add wave -position insertpoint  \
sim:/tb_slave_read/u_TOP_SLAVE/u_BACKEND/u_RECEPTION/w_H_SRC \
sim:/tb_slave_read/u_TOP_SLAVE/u_BACKEND/u_RECEPTION/w_H_INTERFACE \
sim:/tb_slave_read/u_TOP_SLAVE/u_BACKEND/u_RECEPTION/w_HEADER_ADDRESS

add wave -position insertpoint  \
sim:/tb_slave_read/u_TOP_SLAVE/u_BACKEND/u_INJECTION/w_WRITE_BUFFER \
sim:/tb_slave_read/u_TOP_SLAVE/u_BACKEND/u_INJECTION/w_WRITE_OK_BUFFER \
sim:/tb_slave_read/u_TOP_SLAVE/u_BACKEND/u_INJECTION/w_READ_BUFFER \
sim:/tb_slave_read/u_TOP_SLAVE/u_BACKEND/u_INJECTION/w_READ_OK_BUFFER

add wave -position insertpoint  \
sim:/tb_slave_read/u_TOP_SLAVE/u_BACKEND/u_INJECTION/u_BUFFER_FIFO/fifo/shift/fifo_r

add wave -position insertpoint  \
sim:/tb_slave_read/u_TOP_SLAVE/u_BACKEND/u_RECEPTION/u_BUFFER_FIFO/fifo/shift/fifo_r

#---------------------------------------------------------------------------------------------
# Network signals.

add wave -position insertpoint  \
sim:/tb_slave_read/t_l_in_data_i \
sim:/tb_slave_read/t_l_in_val_i \
sim:/tb_slave_read/t_l_in_ack_o \
sim:/tb_slave_read/t_l_out_data_o \
sim:/tb_slave_read/t_l_out_val_o \
sim:/tb_slave_read/t_l_out_ack_i

add wave -position insertpoint  \
sim:/tb_slave_read/t2_l_in_data_i \
sim:/tb_slave_read/t2_l_in_val_i \
sim:/tb_slave_read/t2_l_in_ack_o \
sim:/tb_slave_read/t2_l_out_data_o \
sim:/tb_slave_read/t2_l_out_val_o \
sim:/tb_slave_read/t2_l_out_ack_i