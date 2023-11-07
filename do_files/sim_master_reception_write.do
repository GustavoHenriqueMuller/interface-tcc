vsim -voptargs=+acc -debugDB work.tb_master_reception_write

#---------------------------------------------------------------------------------------------
# AXI/interface signals.

add wave -position insertpoint  \
sim:/tb_master_reception_write/t_ACLK \
sim:/tb_master_reception_write/t_RESETn

add wave -position insertpoint  \
sim:/tb_master_reception_write/t_BVALID \
sim:/tb_master_reception_write/t_BREADY \
sim:/tb_master_reception_write/t_BRESP

add wave -position insertpoint  \
sim:/tb_master_reception_write/t_CORRUPT_PACKET

add wave -position insertpoint  \
sim:/tb_master_reception_write/u_TOP_MASTER/u_BACKEND/u_RECEPTION/i_READY_RECEIVE_PACKET \
sim:/tb_master_reception_write/u_TOP_MASTER/u_BACKEND/u_RECEPTION/o_VALID_RECEIVE_DATA \
sim:/tb_master_reception_write/u_TOP_MASTER/u_BACKEND/u_RECEPTION/o_LAST_RECEIVE_DATA

add wave -position insertpoint  \
sim:/tb_master_reception_write/u_TOP_MASTER/u_BACKEND/u_RECEPTION/w_FLIT \
sim:/tb_master_reception_write/u_TOP_MASTER/u_BACKEND/u_RECEPTION/w_WRITE_H_INTERFACE_REG \
sim:/tb_master_reception_write/u_TOP_MASTER/u_BACKEND/u_RECEPTION/w_H_INTERFACE \
sim:/tb_master_reception_write/u_TOP_MASTER/u_BACKEND/u_RECEPTION/w_READ_BUFFER \
sim:/tb_master_reception_write/u_TOP_MASTER/u_BACKEND/u_RECEPTION/w_READ_OK_BUFFER

add wave -position insertpoint  \
sim:/tb_master_reception_write/u_TOP_MASTER/u_BACKEND/u_RECEPTION/u_DEPACKETIZER_CONTROL/u_DEPACKETIZER_CONTROL_NORMAL/r_STATE

add wave -position insertpoint  \
sim:/tb_master_reception_write/u_TOP_MASTER/u_BACKEND/u_INJECTION/u_BUFFER_FIFO/u_BUFFER_FIFO_NORMAL/fifo/shift/fifo_r

add wave -position insertpoint  \
sim:/tb_master_reception_write/u_TOP_MASTER/u_BACKEND/u_RECEPTION/w_WRITE_BUFFER \
sim:/tb_master_reception_write/u_TOP_MASTER/u_BACKEND/u_RECEPTION/w_WRITE_OK_BUFFER \

#---------------------------------------------------------------------------------------------
# Network signals.

add wave -position insertpoint  \
sim:/tb_master_reception_write/u_TOP_MASTER/u_BACKEND/u_RECEPTION/l_out_data_o \
sim:/tb_master_reception_write/u_TOP_MASTER/u_BACKEND/u_RECEPTION/l_out_val_o \
sim:/tb_master_reception_write/u_TOP_MASTER/u_BACKEND/u_RECEPTION/l_out_ack_i