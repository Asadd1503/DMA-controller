# 1. Clean old work library if it exists
#if {[file exists work]} {
#    vdel -lib work -all
#}

# 2. Create and map the new library
#vlib work
#vmap work work

# 3. Compile the design using your filelist
vlog -work work -sv -f flist.f

# 4. Load the simulation (replace with your actual testbench name)
vsim -voptargs=+acc work.tb_top


# 5. Add waveforms and run
add wave -group "DMA IF" /tb_top/dma_if/*
add wave -group "DMA DUT" /tb_top/dma_dut/*
add wave -group "DMA FSM CH 0" /tb_top/dma_dut/gen_dma_fsm[0]/dma_fsm_inst/*
add wave -group "INTERNAL ARBITER" /tb_top/dma_dut/int_arbiter_inst/*
add wave -group "INTERNAL ARBITER CH_REQ_MUX" /tb_top/dma_dut/int_arbiter_inst/u_ch_mux/*
add wave -group "INTERNAL ARBITER CONTROLLER" /tb_top/dma_dut/int_arbiter_inst/u_controller/*
add wave -group "INTERNAL ARBITER RESP DEMUX" /tb_top/dma_dut/int_arbiter_inst/u_resp_demux/*
add wave -group "EXTERNAL ARBITER TOP" /tb_top/dma_dut/ext_arbiter_inst/*

add wave -group "AXI MASTER READ TOP" /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/*
add wave -group "AXI MASTER READ DATAPATH" /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_datapath/*
add wave -group "AXI MASTER READ CONTROLLER" /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_ctrl/*
add wave -group "BEAT COUNTER" /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_datapath/beat_cnt/*

add wave -group "AXI MASTER WRITE TOP" /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/*
add wave -group "AXI MASTER WRITE DATAPATH" /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_datapath/*
add wave -group "AXI MASTER WRITE CONTROLLER" /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_ctrl/*

run -all
