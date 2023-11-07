vsim -voptargs=+acc -debugDB work.tb_master_injection_write

#---------------------------------------------------------------------------------------------
# AXI/interface signals.

add wave -position insertpoint  \
sim:/tb_master_injection_write/t_ACLK \
sim:/tb_master_injection_write/t_AWVALID \
sim:/tb_master_injection_write/t_AWREADY

add wave -position insertpoint  \
sim:/tb_master_injection_write/u_TOP_MASTER/u_BACKEND/u_INJECTION/u_PACKETIZER_CONTROL/u_PACKETIZER_CONTROL_NORMAL/r_STATE

add wave -position insertpoint  \
sim:/tb_master_injection_write/u_TOP_MASTER/u_BACKEND/u_INJECTION/w_FLIT \
sim:/tb_master_injection_write/u_TOP_MASTER/u_BACKEND/u_INJECTION/w_WRITE_BUFFER \
sim:/tb_master_injection_write/u_TOP_MASTER/u_BACKEND/u_INJECTION/w_WRITE_OK_BUFFER \
sim:/tb_master_injection_write/u_TOP_MASTER/u_BACKEND/u_INJECTION/w_READ_BUFFER \
sim:/tb_master_injection_write/u_TOP_MASTER/u_BACKEND/u_INJECTION/w_READ_OK_BUFFER

add wave -position insertpoint  \
sim:/tb_master_injection_write/u_TOP_MASTER/u_BACKEND/u_INJECTION/u_BUFFER_FIFO/u_BUFFER_FIFO_NORMAL/w_FIFO