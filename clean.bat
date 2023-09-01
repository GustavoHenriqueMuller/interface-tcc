@echo off
del "*.vhd.bak" /S /Q

pushd "do_files"
del "vsim.wlf" /Q
@RD /S /Q "work"
popd