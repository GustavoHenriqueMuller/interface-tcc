vsim -voptargs=+acc -debugDB work.tb_integration

add wave -position insertpoint  \
sim:/tb_integration/t_ACLK \
sim:/tb_integration/t_RESETn

add wave -position insertpoint  \
sim:/tb_integration/t2_AWVALID \
sim:/tb_integration/t2_AWREADY \
sim:/tb_integration/t2_AWID \
sim:/tb_integration/t2_AWADDR \
sim:/tb_integration/t2_AWLEN \
sim:/tb_integration/t2_AWSIZE \
sim:/tb_integration/t2_AWBURST \
sim:/tb_integration/t2_WVALID \
sim:/tb_integration/t2_WREADY \
sim:/tb_integration/t2_WDATA \
sim:/tb_integration/t2_WLAST \
sim:/tb_integration/t2_BVALID \
sim:/tb_integration/t2_BREADY \
sim:/tb_integration/t2_BID \
sim:/tb_integration/t2_BRESP \
sim:/tb_integration/t2_ARVALID \
sim:/tb_integration/t2_ARREADY \
sim:/tb_integration/t2_ARID \
sim:/tb_integration/t2_ARADDR \
sim:/tb_integration/t2_ARLEN \
sim:/tb_integration/t2_ARSIZE \
sim:/tb_integration/t2_ARBURST \
sim:/tb_integration/t2_RVALID \
sim:/tb_integration/t2_RREADY \
sim:/tb_integration/t2_RDATA \
sim:/tb_integration/t2_RID \
sim:/tb_integration/t2_RRESP \
sim:/tb_integration/t2_CORRUPT_PACKET

add wave -position insertpoint  \
sim:/tb_integration/u_TOP_SLAVE/u_BACKEND/u_RECEPTION/u_DEPACKETIZER_CONTROL/u_DEPACKETIZER_CONTROL_NORMAL/r_STATE