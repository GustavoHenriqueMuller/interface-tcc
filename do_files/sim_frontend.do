vsim -voptargs=+acc work.tcc_frontend_master_tb

add wave -position insertpoint  \
sim:/tcc_frontend_master_tb/t_ACLK \
sim:/tcc_frontend_master_tb/t_RESETn \
sim:/tcc_frontend_master_tb/t_AWADDR \
sim:/tcc_frontend_master_tb/t_AW_ID \
sim:/tcc_frontend_master_tb/t_AWLEN \
sim:/tcc_frontend_master_tb/t_WDATA \
sim:/tcc_frontend_master_tb/t_AWVALID \
sim:/tcc_frontend_master_tb/t_AWREADY \
sim:/tcc_frontend_master_tb/t_WVALID \
sim:/tcc_frontend_master_tb/t_WREADY \
sim:/tcc_frontend_master_tb/t_WLAST \
sim:/tcc_frontend_master_tb/t_BVALID \
sim:/tcc_frontend_master_tb/t_BACKEND_VALID_IN \
sim:/tcc_frontend_master_tb/t_BACKEND_OPC_IN \
sim:/tcc_frontend_master_tb/t_BACKEND_DATA_IN \
sim:/tcc_frontend_master_tb/t_BACKEND_READY_OUT

add wave -position insertpoint  \
sim:/tcc_frontend_master_tb/u_TCC_FRONTEND_MASTER/u_tcc_FRONTEND_MASTER_SEND_CONTROL/r_CURRENT_STATE

add wave -position insertpoint  \
sim:/tcc_frontend_master_tb/u_TCC_FRONTEND_MASTER/u_tcc_FRONTEND_MASTER_SEND_CONTROL/r_NEXT_STATE