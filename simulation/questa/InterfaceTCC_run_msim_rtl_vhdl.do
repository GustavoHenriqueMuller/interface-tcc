transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -2008 -work work {E:/repos/InterfaceTCC/hdl/dependencies/xina_pkg.vhd}
vcom -2008 -work work {E:/repos/InterfaceTCC/hdl/tcc_package.vhd}
vcom -2008 -work work {E:/repos/InterfaceTCC/hdl/backend/tcc_backend_master_send_control.vhd}
vcom -2008 -work work {E:/repos/InterfaceTCC/hdl/frontend/tcc_frontend_master_send_control.vhd}
vcom -2008 -work work {E:/repos/InterfaceTCC/hdl/backend/tcc_backend_master.vhd}
vcom -2008 -work work {E:/repos/InterfaceTCC/hdl/frontend/tcc_frontend_master.vhd}
vcom -2008 -work work {E:/repos/InterfaceTCC/hdl/tcc_top_master.vhd}

vcom -2008 -work work {E:/repos/InterfaceTCC/hdl/test/tcc_frontend_master_tb.vhd}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cyclonev -L cyclonev_hssi -L rtl_work -L work -voptargs="+acc"  tcc_frontend_master_tb

add wave *
view structure
view signals
run -all
