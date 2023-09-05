vsim -voptargs=+acc -debugDB work.tb_master_reception_write

add wave -position insertpoint  \
sim:/tb_master_reception_write/t_ACLK \
sim:/tb_master_reception_write/t_RESETn

add wave -position insertpoint  \
sim:/tb_master_reception_write/t_l_in_data_i \
sim:/tb_master_reception_write/t_l_in_val_i \
sim:/tb_master_reception_write/t_l_in_ack_o