vsim -voptargs=+acc -debugDB work.tb_integration_compressor

add wave -position insertpoint  \
sim:/tb_integration_compressor/t_ACLK \
sim:/tb_integration_compressor/t_RESETn


add wave -position insertpoint  \
sim:/tb_integration_compressor/t_AWVALID \
sim:/tb_integration_compressor/t_AWREADY \
sim:/tb_integration_compressor/t_AWID \
sim:/tb_integration_compressor/t_AWADDR \
sim:/tb_integration_compressor/t_AWLEN \
sim:/tb_integration_compressor/t_AWBURST \
sim:/tb_integration_compressor/t_WVALID \
sim:/tb_integration_compressor/t_WREADY \
sim:/tb_integration_compressor/t_WDATA \
sim:/tb_integration_compressor/t_WLAST \
sim:/tb_integration_compressor/t_BVALID \
sim:/tb_integration_compressor/t_BREADY \
sim:/tb_integration_compressor/t_BID \
sim:/tb_integration_compressor/t_BRESP \
sim:/tb_integration_compressor/t_ARVALID \
sim:/tb_integration_compressor/t_ARREADY \
sim:/tb_integration_compressor/t_ARID \
sim:/tb_integration_compressor/t_ARADDR \
sim:/tb_integration_compressor/t_ARLEN \
sim:/tb_integration_compressor/t_ARBURST \
sim:/tb_integration_compressor/t_RVALID \
sim:/tb_integration_compressor/t_RREADY \
sim:/tb_integration_compressor/t_RDATA \
sim:/tb_integration_compressor/t_RLAST \
sim:/tb_integration_compressor/t_RID \
sim:/tb_integration_compressor/t_RRESP \
sim:/tb_integration_compressor/t_CORRUPT_PACKET \
sim:/tb_integration_compressor/t2_AWVALID \
sim:/tb_integration_compressor/t2_AWREADY \
sim:/tb_integration_compressor/t2_AWID \
sim:/tb_integration_compressor/t2_AWADDR \
sim:/tb_integration_compressor/t2_AWLEN \
sim:/tb_integration_compressor/t2_AWSIZE \
sim:/tb_integration_compressor/t2_AWBURST \
sim:/tb_integration_compressor/t2_WVALID \
sim:/tb_integration_compressor/t2_WREADY \
sim:/tb_integration_compressor/t2_WDATA \
sim:/tb_integration_compressor/t2_WLAST \
sim:/tb_integration_compressor/t2_BVALID \
sim:/tb_integration_compressor/t2_BREADY \
sim:/tb_integration_compressor/t2_BID \
sim:/tb_integration_compressor/t2_BRESP \
sim:/tb_integration_compressor/t2_ARVALID \
sim:/tb_integration_compressor/t2_ARREADY \
sim:/tb_integration_compressor/t2_ARID \
sim:/tb_integration_compressor/t2_ARADDR \
sim:/tb_integration_compressor/t2_ARLEN \
sim:/tb_integration_compressor/t2_ARSIZE \
sim:/tb_integration_compressor/t2_ARBURST \
sim:/tb_integration_compressor/t2_RVALID \
sim:/tb_integration_compressor/t2_RREADY \
sim:/tb_integration_compressor/t2_RDATA \
sim:/tb_integration_compressor/t2_RLAST \
sim:/tb_integration_compressor/t2_RID \
sim:/tb_integration_compressor/t2_RRESP \
sim:/tb_integration_compressor/t2_CORRUPT_PACKET

add wave -position insertpoint  \
sim:/tb_integration_compressor/u_COMPRESSOR/ccsds_axifull_v1_0_S00_AXI_inst/mem_data_out

add wave -position insertpoint  \
sim:/tb_integration_compressor/u_COMPRESSOR/ccsds_axifull_v1_0_S00_AXI_inst/w_mapped