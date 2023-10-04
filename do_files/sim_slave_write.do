vsim -voptargs=+acc -debugDB work.tb_slave_write

#---------------------------------------------------------------------------------------------
# AXI/interface signals.

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
sim:/tb_slave_write/t_WLAST \
sim:/tb_slave_write/t_BVALID \
sim:/tb_slave_write/t_BREADY \
sim:/tb_slave_write/t_BRESP

add wave -position insertpoint  \
sim:/tb_slave_write/u_TOP_SLAVE/u_BACKEND/u_INJECTION/u_PACKETIZER_CONTROL/r_STATE

add wave -position insertpoint  \
sim:/tb_slave_write/u_TOP_SLAVE/u_BACKEND/u_RECEPTION/u_DEPACKETIZER_CONTROL/r_STATE

add wave -position insertpoint  \
sim:/tb_slave_write/u_TOP_SLAVE/u_BACKEND/u_RECEPTION/u_DEPACKETIZER_CONTROL/r_PAYLOAD_COUNTER \
sim:/tb_slave_write/u_TOP_SLAVE/u_BACKEND/u_RECEPTION/u_DEPACKETIZER_CONTROL/r_SET_PAYLOAD_COUNTER \
sim:/tb_slave_write/u_TOP_SLAVE/u_BACKEND/u_RECEPTION/u_DEPACKETIZER_CONTROL/r_SUBTRACT_PAYLOAD_COUNTER

add wave -position insertpoint  \
sim:/tb_slave_write/u_TOP_SLAVE/u_BACKEND/u_RECEPTION/w_H_SRC \
sim:/tb_slave_write/u_TOP_SLAVE/u_BACKEND/u_RECEPTION/w_H_INTERFACE \
sim:/tb_slave_write/u_TOP_SLAVE/u_BACKEND/u_RECEPTION/w_HEADER_ADDRESS

add wave -position insertpoint  \
sim:/tb_slave_write/u_TOP_SLAVE/u_BACKEND/u_RECEPTION/w_WRITE_BUFFER \
sim:/tb_slave_write/u_TOP_SLAVE/u_BACKEND/u_RECEPTION/w_WRITE_OK_BUFFER \
sim:/tb_slave_write/u_TOP_SLAVE/u_BACKEND/u_RECEPTION/w_READ_BUFFER \
sim:/tb_slave_write/u_TOP_SLAVE/u_BACKEND/u_RECEPTION/w_READ_OK_BUFFER

add wave -position insertpoint  \
sim:/tb_slave_write/u_TOP_SLAVE/u_BACKEND/u_INJECTION/u_BUFFER_FIFO/fifo/shift/fifo_r

add wave -position insertpoint  \
sim:/tb_slave_write/u_TOP_SLAVE/u_BACKEND/u_RECEPTION/u_BUFFER_FIFO/fifo/shift/fifo_r

add wave -position insertpoint  \
sim:/tb_slave_write/u_TOP_SLAVE/u_BACKEND/u_RECEPTION/u_BUFFER_FIFO/data_o