vsim -voptargs=+acc -debugDB work.tb_master_reception_read

#---------------------------------------------------------------------------------------------
# AXI/interface signals.

add wave -position insertpoint  \
sim:/tb_master_reception_read/t_ACLK \
sim:/tb_master_reception_read/t_RESETn

add wave -position insertpoint  \
sim:/tb_master_reception_read/t_RVALID \
sim:/tb_master_reception_read/t_RREADY \
sim:/tb_master_reception_read/t_RDATA \
sim:/tb_master_reception_read/t_RLAST \
sim:/tb_master_reception_read/t_RRESP

add wave -position insertpoint  \
sim:/tb_master_reception_read/t_CORRUPT_PACKET

add wave -position insertpoint  \
sim:/tb_master_reception_read/u_TOP_MASTER/u_FRONTEND/i_VALID_RECEIVE_DATA \
sim:/tb_master_reception_read/u_TOP_MASTER/u_FRONTEND/i_LAST_RECEIVE_DATA \
sim:/tb_master_reception_read/u_TOP_MASTER/u_FRONTEND/i_DATA_RECEIVE \
sim:/tb_master_reception_read/u_TOP_MASTER/u_FRONTEND/o_READY_RECEIVE_PACKET \
sim:/tb_master_reception_read/u_TOP_MASTER/u_FRONTEND/o_READY_RECEIVE_DATA

add wave -position insertpoint  \
sim:/tb_master_reception_read/u_TOP_MASTER/u_BACKEND/u_RECEPTION/u_DEPACKETIZER_CONTROL/u_DEPACKETIZER_CONTROL_NORMAL/r_STATE

add wave -position insertpoint  \
sim:/tb_master_reception_read/u_TOP_MASTER/u_BACKEND/u_RECEPTION/u_DEPACKETIZER_CONTROL/u_DEPACKETIZER_CONTROL_NORMAL/r_PAYLOAD_COUNTER \
sim:/tb_master_reception_read/u_TOP_MASTER/u_BACKEND/u_RECEPTION/u_DEPACKETIZER_CONTROL/u_DEPACKETIZER_CONTROL_NORMAL/r_SET_PAYLOAD_COUNTER \
sim:/tb_master_reception_read/u_TOP_MASTER/u_BACKEND/u_RECEPTION/u_DEPACKETIZER_CONTROL/u_DEPACKETIZER_CONTROL_NORMAL/r_SUBTRACT_PAYLOAD_COUNTER

add wave -position insertpoint  \
sim:/tb_master_reception_read/u_TOP_MASTER/u_BACKEND/u_RECEPTION/u_DEPACKETIZER_CONTROL/u_DEPACKETIZER_CONTROL_NORMAL/i_FLIT

add wave -position insertpoint  \
sim:/tb_master_reception_read/u_TOP_MASTER/u_BACKEND/u_RECEPTION/w_WRITE_BUFFER \
sim:/tb_master_reception_read/u_TOP_MASTER/u_BACKEND/u_RECEPTION/w_WRITE_OK_BUFFER \
sim:/tb_master_reception_read/u_TOP_MASTER/u_BACKEND/u_RECEPTION/w_READ_BUFFER \
sim:/tb_master_reception_read/u_TOP_MASTER/u_BACKEND/u_RECEPTION/w_READ_OK_BUFFER

add wave -position insertpoint  \
sim:/tb_master_reception_read/u_TOP_MASTER/u_BACKEND/u_RECEPTION/u_INTEGRITY_CONTROL_RECEIVE/u_INTEGRITY_CONTROL_RECEIVE_NORMAL/i_ADD \
sim:/tb_master_reception_read/u_TOP_MASTER/u_BACKEND/u_RECEPTION/u_INTEGRITY_CONTROL_RECEIVE/u_INTEGRITY_CONTROL_RECEIVE_NORMAL/i_VALUE_ADD \
sim:/tb_master_reception_read/u_TOP_MASTER/u_BACKEND/u_RECEPTION/u_INTEGRITY_CONTROL_RECEIVE/u_INTEGRITY_CONTROL_RECEIVE_NORMAL/o_CHECKSUM \
sim:/tb_master_reception_read/u_TOP_MASTER/u_BACKEND/u_RECEPTION/u_INTEGRITY_CONTROL_RECEIVE/u_INTEGRITY_CONTROL_RECEIVE_NORMAL/i_COMPARE \
sim:/tb_master_reception_read/u_TOP_MASTER/u_BACKEND/u_RECEPTION/u_INTEGRITY_CONTROL_RECEIVE/u_INTEGRITY_CONTROL_RECEIVE_NORMAL/i_VALUE_COMPARE \
sim:/tb_master_reception_read/u_TOP_MASTER/u_BACKEND/u_RECEPTION/u_INTEGRITY_CONTROL_RECEIVE/u_INTEGRITY_CONTROL_RECEIVE_NORMAL/o_CORRUPT

add wave -position insertpoint  \
sim:/tb_master_reception_read/u_TOP_MASTER/u_BACKEND/u_INJECTION/u_BUFFER_FIFO/u_BUFFER_FIFO_NORMAL/w_FIFO

#---------------------------------------------------------------------------------------------
# Network signals.

add wave -position insertpoint  \
sim:/tb_master_reception_read/t_l_out_data_o \
sim:/tb_master_reception_read/t_l_out_val_o \
sim:/tb_master_reception_read/t_l_out_ack_i