vsim -voptargs=+acc -debugDB work.tb_master_frontend

add wave -position insertpoint  \
sim:/tb_master_frontend/t_ACLK \
sim:/tb_master_frontend/t_RESETn \
sim:/tb_master_frontend/t_AWADDR \
sim:/tb_master_frontend/t_AW_ID \
sim:/tb_master_frontend/t_AWLEN \
sim:/tb_master_frontend/t_WDATA \
sim:/tb_master_frontend/t_AWVALID \
sim:/tb_master_frontend/t_AWREADY \
sim:/tb_master_frontend/t_WVALID \
sim:/tb_master_frontend/t_WREADY \
sim:/tb_master_frontend/t_WLAST \
sim:/tb_master_frontend/t_BVALID \
sim:/tb_master_frontend/t_VALID_SEND_DATA \
sim:/tb_master_frontend/t_OPC_SEND \
sim:/tb_master_frontend/t_DATA_SEND \
sim:/tb_master_frontend/t_READY_SEND_DATA \
sim:/tb_master_frontend/t_READY_RECEIVE_DATA \