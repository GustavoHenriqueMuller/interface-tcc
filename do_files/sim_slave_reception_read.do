vsim -voptargs=+acc -debugDB work.tb_slave_reception_read

add wave -position insertpoint  \
sim:/tb_slave_reception_read/t_ACLK \
sim:/tb_slave_reception_read/t_RESETn

add wave -position insertpoint  \
sim:/tb_slave_reception_read/t_ARVALID \
sim:/tb_slave_reception_read/t_ARREADY \
sim:/tb_slave_reception_read/t_AR_ID \
sim:/tb_slave_reception_read/t_ARADDR \
sim:/tb_slave_reception_read/t_ARLEN \
sim:/tb_slave_reception_read/t_ARSIZE \
sim:/tb_slave_reception_read/t_ARBURST \
sim:/tb_slave_reception_read/t_RVALID \
sim:/tb_slave_reception_read/t_RREADY \
sim:/tb_slave_reception_read/t_RDATA \
sim:/tb_slave_reception_read/t_RLAST \
sim:/tb_slave_reception_read/t_RRESP

add wave -position insertpoint  \
sim:/tb_slave_reception_read/u_TOP_SLAVE/u_BACKEND/u_RECEPTION/u_DEPACKETIZER_CONTROL/r_CURRENT_STATE

add wave -position insertpoint  \
sim:/tb_slave_reception_read/u_TOP_SLAVE/u_BACKEND/u_RECEPTION/w_HEADER_1 \
sim:/tb_slave_reception_read/u_TOP_SLAVE/u_BACKEND/u_RECEPTION/w_HEADER_2 \
sim:/tb_slave_reception_read/u_TOP_SLAVE/u_BACKEND/u_RECEPTION/w_ADDRESS

add wave -position insertpoint  \
sim:/tb_slave_reception_read/u_TOP_SLAVE/u_BACKEND/u_RECEPTION/w_WRITE_BUFFER \
sim:/tb_slave_reception_read/u_TOP_SLAVE/u_BACKEND/u_RECEPTION/w_WRITE_OK_BUFFER \
sim:/tb_slave_reception_read/u_TOP_SLAVE/u_BACKEND/u_RECEPTION/w_READ_BUFFER \
sim:/tb_slave_reception_read/u_TOP_SLAVE/u_BACKEND/u_RECEPTION/w_READ_OK_BUFFER

add wave -position insertpoint  \
sim:/tb_slave_reception_read/u_TOP_SLAVE/u_BACKEND/u_RECEPTION/u_BUFFER_FIFO/fifo/shift/fifo_r

add wave -position insertpoint  \
sim:/tb_slave_reception_read/u_TOP_SLAVE/u_BACKEND/u_RECEPTION/u_BUFFER_FIFO/data_o