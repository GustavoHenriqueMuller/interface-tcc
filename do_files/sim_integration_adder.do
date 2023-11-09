vsim -voptargs=+acc -debugDB work.tb_integration_adder

add wave -position insertpoint  \
sim:/tb_integration_adder/t_ACLK \
sim:/tb_integration_adder/t_RESETn

add wave -position insertpoint  \
sim:/tb_integration_adder/t_AWVALID \
sim:/tb_integration_adder/t_AWREADY \
sim:/tb_integration_adder/t_AWID \
sim:/tb_integration_adder/t_AWADDR \
sim:/tb_integration_adder/t_AWLEN \
sim:/tb_integration_adder/t_AWBURST \
sim:/tb_integration_adder/t_WVALID \
sim:/tb_integration_adder/t_WREADY \
sim:/tb_integration_adder/t_WDATA \
sim:/tb_integration_adder/t_WLAST \
sim:/tb_integration_adder/t_BVALID \
sim:/tb_integration_adder/t_BREADY \
sim:/tb_integration_adder/t_BID \
sim:/tb_integration_adder/t_BRESP \
sim:/tb_integration_adder/t_ARVALID \
sim:/tb_integration_adder/t_ARREADY \
sim:/tb_integration_adder/t_ARID \
sim:/tb_integration_adder/t_ARADDR \
sim:/tb_integration_adder/t_ARLEN \
sim:/tb_integration_adder/t_ARBURST \
sim:/tb_integration_adder/t_RVALID \
sim:/tb_integration_adder/t_RREADY \
sim:/tb_integration_adder/t_RDATA \
sim:/tb_integration_adder/t_RLAST \
sim:/tb_integration_adder/t_RID \
sim:/tb_integration_adder/t_RRESP \
sim:/tb_integration_adder/t_CORRUPT_PACKET \
sim:/tb_integration_adder/t2_AWVALID \
sim:/tb_integration_adder/t2_AWREADY \
sim:/tb_integration_adder/t2_AWID \
sim:/tb_integration_adder/t2_AWADDR \
sim:/tb_integration_adder/t2_AWLEN \
sim:/tb_integration_adder/t2_AWSIZE \
sim:/tb_integration_adder/t2_AWBURST \
sim:/tb_integration_adder/t2_WVALID \
sim:/tb_integration_adder/t2_WREADY \
sim:/tb_integration_adder/t2_WDATA \
sim:/tb_integration_adder/t2_WLAST \
sim:/tb_integration_adder/t2_BVALID \
sim:/tb_integration_adder/t2_BREADY \
sim:/tb_integration_adder/t2_BID \
sim:/tb_integration_adder/t2_BRESP \
sim:/tb_integration_adder/t2_ARVALID \
sim:/tb_integration_adder/t2_ARREADY \
sim:/tb_integration_adder/t2_ARID \
sim:/tb_integration_adder/t2_ARADDR \
sim:/tb_integration_adder/t2_ARLEN \
sim:/tb_integration_adder/t2_ARSIZE \
sim:/tb_integration_adder/t2_ARBURST \
sim:/tb_integration_adder/t2_RVALID \
sim:/tb_integration_adder/t2_RREADY \
sim:/tb_integration_adder/t2_RDATA \
sim:/tb_integration_adder/t2_RLAST \
sim:/tb_integration_adder/t2_RID \
sim:/tb_integration_adder/t2_RRESP \
sim:/tb_integration_adder/t2_CORRUPT_PACKET