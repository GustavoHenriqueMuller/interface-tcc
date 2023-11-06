vlib work

#---------------------------------------------------------------------------------------------
# Adder.

vcom -2008 ../hdl/dependencies/adder/adder.vhd
vcom -2008 ../hdl/dependencies/adder/adder_full_v1_0.vhd
vcom -2008 ../hdl/dependencies/adder/adder_full_v1_0_S00_AXI.vhd

#---------------------------------------------------------------------------------------------
# Compressor.

vcom -2008 ../hdl/dependencies/compressor_axi/ccsds123_B2_package.vhd
vcom -2008 ../hdl/dependencies/compressor_axi/central_local_diff.vhd
vcom -2008 ../hdl/dependencies/compressor_axi/compressor_v1_1.vhd
vcom -2008 ../hdl/dependencies/compressor_axi/compressor_top.vhd
vcom -2008 ../hdl/dependencies/compressor_axi/compressor_v1_1_S00_AXI.vhd
vcom -2008 ../hdl/dependencies/compressor_axi/double_res.vhd
vcom -2008 ../hdl/dependencies/compressor_axi/high_resolution.vhd
vcom -2008 ../hdl/dependencies/compressor_axi/init_weights.vhd
vcom -2008 ../hdl/dependencies/compressor_axi/local_diff_reg.vhd
vcom -2008 ../hdl/dependencies/compressor_axi/local_sum.vhd
vcom -2008 ../hdl/dependencies/compressor_axi/mapped_residual.vhd
vcom -2008 ../hdl/dependencies/compressor_axi/mux_weight_mem.vhd
vcom -2008 ../hdl/dependencies/compressor_axi/p_control.vhd
vcom -2008 ../hdl/dependencies/compressor_axi/p_top.vhd
vcom -2008 ../hdl/dependencies/compressor_axi/predict_central.vhd
vcom -2008 ../hdl/dependencies/compressor_axi/quantization.vhd
vcom -2008 ../hdl/dependencies/compressor_axi/top_test.vhd
vcom -2008 ../hdl/dependencies/compressor_axi/update_weights.vhd
vcom -2008 ../hdl/dependencies/compressor_axi/weights_reg.vhd
