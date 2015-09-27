transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlib DE2_115_qsys
vmap DE2_115_qsys DE2_115_qsys
vlog -vlog01compat -work DE2_115_qsys +incdir+/home/alpha/Documents/lab2/DE2_115/DE2_115_qsys/synthesis {/home/alpha/Documents/lab2/DE2_115/DE2_115_qsys/synthesis/DE2_115_qsys.v}
vlog -vlog01compat -work DE2_115_qsys +incdir+/home/alpha/Documents/lab2/DE2_115/DE2_115_qsys/synthesis/submodules {/home/alpha/Documents/lab2/DE2_115/DE2_115_qsys/synthesis/submodules/altera_reset_controller.v}
vlog -vlog01compat -work DE2_115_qsys +incdir+/home/alpha/Documents/lab2/DE2_115/DE2_115_qsys/synthesis/submodules {/home/alpha/Documents/lab2/DE2_115/DE2_115_qsys/synthesis/submodules/altera_reset_synchronizer.v}
vlog -vlog01compat -work DE2_115_qsys +incdir+/home/alpha/Documents/lab2/DE2_115/DE2_115_qsys/synthesis/submodules {/home/alpha/Documents/lab2/DE2_115/DE2_115_qsys/synthesis/submodules/DE2_115_qsys_mm_interconnect_0.v}
vlog -vlog01compat -work DE2_115_qsys +incdir+/home/alpha/Documents/lab2/DE2_115/DE2_115_qsys/synthesis/submodules {/home/alpha/Documents/lab2/DE2_115/DE2_115_qsys/synthesis/submodules/DE2_115_qsys_uart_0.v}
vlog -sv -work DE2_115_qsys +incdir+/home/alpha/Documents/lab2/DE2_115/DE2_115_qsys/synthesis/submodules {/home/alpha/Documents/lab2/DE2_115/DE2_115_qsys/synthesis/submodules/altera_merlin_slave_translator.sv}
vlog -sv -work DE2_115_qsys +incdir+/home/alpha/Documents/lab2/DE2_115/DE2_115_qsys/synthesis/submodules {/home/alpha/Documents/lab2/DE2_115/DE2_115_qsys/synthesis/submodules/altera_merlin_master_translator.sv}
vlog -sv -work DE2_115_qsys +incdir+/home/alpha/Documents/lab2/DE2_115/DE2_115_qsys/synthesis/submodules {/home/alpha/Documents/lab2/DE2_115/DE2_115_qsys/synthesis/submodules/Rsa256Wrapper.sv}
vlog -sv -work work +incdir+/home/alpha/Documents/lab2/DE2_115 {/home/alpha/Documents/lab2/DE2_115/Rsa256Core.sv}
vlog -sv -work work +incdir+/home/alpha/Documents/lab2/DE2_115 {/home/alpha/Documents/lab2/DE2_115/DE2_115.sv}
vlog -sv -work work +incdir+/home/alpha/Documents/lab2/DE2_115 {/home/alpha/Documents/lab2/DE2_115/Rsa256Wrapper.sv}
vlog -sv -work work +incdir+/home/alpha/Documents/lab2/DE2_115 {/home/alpha/Documents/lab2/DE2_115/SevenHexDecoder.sv}

vlog -sv -work work +incdir+/home/alpha/Documents/lab2/DE2_115 {/home/alpha/Documents/lab2/DE2_115/tb.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -L DE2_115_qsys -voptargs="+acc"  tb

add wave *
view structure
view signals
run -all
