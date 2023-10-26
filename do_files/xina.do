vlib work

#---------------------------------------------------------------------------------------------
# XINA standard.

vcom -2008 ../hdl/dependencies/xina/rtl/flow_in_hs.vhd
vcom -2008 ../hdl/dependencies/xina/rtl/flow_in.vhd
vcom -2008 ../hdl/dependencies/xina/rtl/flow_out_hs.vhd
vcom -2008 ../hdl/dependencies/xina/rtl/flow_out.vhd
vcom -2008 ../hdl/dependencies/xina/rtl/routing_xy.vhd
vcom -2008 ../hdl/dependencies/xina/rtl/routing.vhd
vcom -2008 ../hdl/dependencies/xina/rtl/arbitration_rr.vhd
vcom -2008 ../hdl/dependencies/xina/rtl/arbitration.vhd
vcom -2008 ../hdl/dependencies/xina/rtl/buffering_fifo.vhd
vcom -2008 ../hdl/dependencies/xina/rtl/buffering.vhd
vcom -2008 ../hdl/dependencies/xina/rtl/switch.vhd
vcom -2008 ../hdl/dependencies/xina/rtl/channel_in.vhd
vcom -2008 ../hdl/dependencies/xina/rtl/channel_out.vhd
vcom -2008 ../hdl/dependencies/xina/rtl/crossbar.vhd
vcom -2008 ../hdl/dependencies/xina/rtl/router.vhd
vcom -2008 ../hdl/dependencies/xina/rtl/xina.vhd
vcom -2008 ../hdl/dependencies/xina/tb/xina_tb.vhd

#---------------------------------------------------------------------------------------------
# XINA FT.

vcom -2008 ../hdl/dependencies/xina/rtl/ft/hamming_pkg.vhd
vcom -2008 ../hdl/dependencies/xina/rtl/ft/routing_tmr.vhd
vcom -2008 ../hdl/dependencies/xina/rtl/ft/arbitration_tmr.vhd
vcom -2008 ../hdl/dependencies/xina/rtl/ft/flow_in_tmr.vhd
vcom -2008 ../hdl/dependencies/xina/rtl/ft/flow_out_tmr.vhd
vcom -2008 ../hdl/dependencies/xina/rtl/ft/channel_in_ft.vhd
vcom -2008 ../hdl/dependencies/xina/rtl/ft/channel_out_ft.vhd
vcom -2008 ../hdl/dependencies/xina/rtl/ft/hamming_dec.vhd
vcom -2008 ../hdl/dependencies/xina/rtl/ft/hamming_enc.vhd
vcom -2008 ../hdl/dependencies/xina/rtl/ft/buffering_ham.vhd
vcom -2008 ../hdl/dependencies/xina/rtl/ft/router_ft.vhd
vcom -2008 ../hdl/dependencies/xina/rtl/ft/xina_ft.vhd