vsim -voptargs=+acc -debugDB work.tb_slave_write

add wave -position insertpoint  \
sim:/tb_slave_write/t_ACLK \
sim:/tb_slave_write/t_RESETn

add wave -position insertpoint  \
sim:/tb_slave_write/t_AWVALID \
sim:/tb_slave_write/t_AWREADY \
sim:/tb_slave_write/t_AWID \
sim:/tb_slave_write/t_AWADDR \
sim:/tb_slave_write/t_AWLEN \
sim:/tb_slave_write/t_AWSIZE \
sim:/tb_slave_write/t_AWBURST \
sim:/tb_slave_write/t_WVALID \
sim:/tb_slave_write/t_WREADY \
sim:/tb_slave_write/t_WDATA \
sim:/tb_slave_write/t_WLAST

add wave -position insertpoint  \
sim:/tb_slave_read/u_TOP_SLAVE/u_BACKEND/u_INJECTION/u_PACKETIZER_CONTROL/r_CURRENT_STATE

add wave -position insertpoint  \
sim:/tb_slave_write/u_TOP_SLAVE/u_BACKEND/u_RECEPTION/u_DEPACKETIZER_CONTROL/r_CURRENT_STATE

add wave -position insertpoint  \
sim:/tb_slave_write/u_TOP_SLAVE/u_BACKEND/u_RECEPTION/w_HEADER_1 \
sim:/tb_slave_write/u_TOP_SLAVE/u_BACKEND/u_RECEPTION/w_HEADER_2 \
sim:/tb_slave_write/u_TOP_SLAVE/u_BACKEND/u_RECEPTION/w_ADDRESS

add wave -position insertpoint  \
sim:/tb_slave_write/u_TOP_SLAVE/u_BACKEND/u_RECEPTION/w_WRITE_BUFFER \
sim:/tb_slave_write/u_TOP_SLAVE/u_BACKEND/u_RECEPTION/w_WRITE_OK_BUFFER \
sim:/tb_slave_write/u_TOP_SLAVE/u_BACKEND/u_RECEPTION/w_READ_BUFFER \
sim:/tb_slave_write/u_TOP_SLAVE/u_BACKEND/u_RECEPTION/w_READ_OK_BUFFER

add wave -position insertpoint  \
sim:/tb_slave_read/u_TOP_SLAVE/u_BACKEND/u_INJECTION/u_BUFFER_FIFO/fifo/shift/fifo_r

add wave -position insertpoint  \
sim:/tb_slave_write/u_TOP_SLAVE/u_BACKEND/u_RECEPTION/u_BUFFER_FIFO/fifo/shift/fifo_r

add wave -position insertpoint  \
sim:/tb_slave_write/u_TOP_SLAVE/u_BACKEND/u_RECEPTION/u_BUFFER_FIFO/data_o