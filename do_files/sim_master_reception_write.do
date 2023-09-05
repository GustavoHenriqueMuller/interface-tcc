vsim -voptargs=+acc -debugDB work.tb_master_reception_write

add wave -position insertpoint  \
sim:/tb_master_reception_write/t_ACLK \
sim:/tb_master_reception_write/t_RESETn

add wave -position insertpoint  \
sim:/tb_master_reception_write/u_TOP_MASTER/u_BACKEND_MASTER/u_BACKEND_MASTER_RECEPTION/l_out_data_o \
sim:/tb_master_reception_write/u_TOP_MASTER/u_BACKEND_MASTER/u_BACKEND_MASTER_RECEPTION/l_out_val_o \
sim:/tb_master_reception_write/u_TOP_MASTER/u_BACKEND_MASTER/u_BACKEND_MASTER_RECEPTION/l_out_ack_i \
sim:/tb_master_reception_write/u_TOP_MASTER/u_BACKEND_MASTER/u_BACKEND_MASTER_RECEPTION/w_ARESET \
sim:/tb_master_reception_write/u_TOP_MASTER/u_BACKEND_MASTER/u_BACKEND_MASTER_RECEPTION/w_FLIT \
sim:/tb_master_reception_write/u_TOP_MASTER/u_BACKEND_MASTER/u_BACKEND_MASTER_RECEPTION/w_WRITE_BUFFER \
sim:/tb_master_reception_write/u_TOP_MASTER/u_BACKEND_MASTER/u_BACKEND_MASTER_RECEPTION/w_WRITE_OK_BUFFER \
sim:/tb_master_reception_write/u_TOP_MASTER/u_BACKEND_MASTER/u_BACKEND_MASTER_RECEPTION/w_READ_BUFFER \
sim:/tb_master_reception_write/u_TOP_MASTER/u_BACKEND_MASTER/u_BACKEND_MASTER_RECEPTION/w_READ_OK_BUFFER

add wave -position insertpoint  \
sim:/tb_master_reception_write/u_TOP_MASTER/u_BACKEND_MASTER/u_BACKEND_MASTER_RECEPTION/u_BUFFER_FIFO/fifo/shift/fifo_r