vsim -voptargs=+acc -debugDB work.tb_master_reception_write

add wave -position insertpoint  \
sim:/tb_master_reception_write/t_ACLK \
sim:/tb_master_reception_write/t_RESETn

add wave -position insertpoint  \
sim:/tb_master_reception_write/t_l_in_data_i \
sim:/tb_master_reception_write/t_l_in_val_i \
sim:/tb_master_reception_write/t_l_in_ack_o

add wave -position insertpoint  \
sim:/tb_master_reception_write/t_l_out_data_o \
sim:/tb_master_reception_write/t_l_out_val_o \
sim:/tb_master_reception_write/t_l_out_ack_i

add wave -position insertpoint  \
sim:/tb_master_reception_write/t2_l_in_data_i \
sim:/tb_master_reception_write/t2_l_in_val_i \
sim:/tb_master_reception_write/t2_l_in_ack_o \
sim:/tb_master_reception_write/t2_l_out_data_o \
sim:/tb_master_reception_write/t2_l_out_val_o \
sim:/tb_master_reception_write/t2_l_out_ack_i \
sim:/tb_master_reception_write/t2_n_in_data_i \
sim:/tb_master_reception_write/t2_n_in_val_i \
sim:/tb_master_reception_write/t2_n_in_ack_o \
sim:/tb_master_reception_write/t2_n_out_data_o \
sim:/tb_master_reception_write/t2_n_out_val_o \
sim:/tb_master_reception_write/t2_n_out_ack_i \
sim:/tb_master_reception_write/t2_e_in_data_i \
sim:/tb_master_reception_write/t2_e_in_val_i \
sim:/tb_master_reception_write/t2_e_in_ack_o \
sim:/tb_master_reception_write/t2_e_out_data_o \
sim:/tb_master_reception_write/t2_e_out_val_o \
sim:/tb_master_reception_write/t2_e_out_ack_i \
sim:/tb_master_reception_write/t2_s_in_data_i \
sim:/tb_master_reception_write/t2_s_in_val_i \
sim:/tb_master_reception_write/t2_s_in_ack_o \
sim:/tb_master_reception_write/t2_s_out_data_o \
sim:/tb_master_reception_write/t2_s_out_val_o \
sim:/tb_master_reception_write/t2_s_out_ack_i \
sim:/tb_master_reception_write/t2_w_in_data_i \
sim:/tb_master_reception_write/t2_w_in_val_i \
sim:/tb_master_reception_write/t2_w_in_ack_o \
sim:/tb_master_reception_write/t2_w_out_data_o \
sim:/tb_master_reception_write/t2_w_out_val_o \
sim:/tb_master_reception_write/t2_w_out_ack_i