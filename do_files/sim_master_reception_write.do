vsim -voptargs=+acc -debugDB work.tb_master_reception_write

add wave -position insertpoint  \
sim:/tb_master_reception_write/t_ACLK \
sim:/tb_master_reception_write/t_RESETn