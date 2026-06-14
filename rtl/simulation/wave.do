onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group {DMA IF} /tb_top/dma_if/aclk
add wave -noupdate -group {DMA IF} /tb_top/dma_if/rst_n
add wave -noupdate -group {DMA IF} /tb_top/dma_if/awaddr
add wave -noupdate -group {DMA IF} /tb_top/dma_if/awvalid
add wave -noupdate -group {DMA IF} /tb_top/dma_if/awready
add wave -noupdate -group {DMA IF} /tb_top/dma_if/wdata
add wave -noupdate -group {DMA IF} /tb_top/dma_if/wstrb
add wave -noupdate -group {DMA IF} /tb_top/dma_if/wvalid
add wave -noupdate -group {DMA IF} /tb_top/dma_if/wready
add wave -noupdate -group {DMA IF} /tb_top/dma_if/bresp
add wave -noupdate -group {DMA IF} /tb_top/dma_if/bvalid
add wave -noupdate -group {DMA IF} /tb_top/dma_if/bready
add wave -noupdate -group {DMA IF} /tb_top/dma_if/araddr
add wave -noupdate -group {DMA IF} /tb_top/dma_if/arvalid
add wave -noupdate -group {DMA IF} /tb_top/dma_if/arready
add wave -noupdate -group {DMA IF} /tb_top/dma_if/rdata
add wave -noupdate -group {DMA IF} /tb_top/dma_if/rresp
add wave -noupdate -group {DMA IF} /tb_top/dma_if/rvalid
add wave -noupdate -group {DMA IF} /tb_top/dma_if/rready
add wave -noupdate -group {DMA IF} /tb_top/dma_if/cpu_read_req
add wave -noupdate -group {DMA IF} /tb_top/dma_if/cpu_read_addr
add wave -noupdate -group {DMA IF} /tb_top/dma_if/cpu_write_req
add wave -noupdate -group {DMA IF} /tb_top/dma_if/cpu_write_addr
add wave -noupdate -group {DMA IF} /tb_top/dma_if/cpu_write_data
add wave -noupdate -group {DMA IF} /tb_top/dma_if/cpu_write_strb
add wave -noupdate -group {DMA IF} /tb_top/dma_if/cpu_c_read_done
add wave -noupdate -group {DMA IF} /tb_top/dma_if/cpu_c_write_done
add wave -noupdate -group {DMA IF} /tb_top/dma_if/cpu_read_data
add wave -noupdate -group {DMA IF} /tb_top/dma_if/c_read_error_o
add wave -noupdate -group {DMA IF} /tb_top/dma_if/c_write_error_o
add wave -noupdate -group {DMA IF} /tb_top/dma_if/ar_ready_i
add wave -noupdate -group {DMA IF} /tb_top/dma_if/ar_valid_o
add wave -noupdate -group {DMA IF} /tb_top/dma_if/ar_addr_o
add wave -noupdate -group {DMA IF} /tb_top/dma_if/ar_len_o
add wave -noupdate -group {DMA IF} /tb_top/dma_if/ar_size_o
add wave -noupdate -group {DMA IF} /tb_top/dma_if/ar_burst_o
add wave -noupdate -group {DMA IF} /tb_top/dma_if/aw_ready_i
add wave -noupdate -group {DMA IF} /tb_top/dma_if/aw_valid_o
add wave -noupdate -group {DMA IF} /tb_top/dma_if/aw_addr_o
add wave -noupdate -group {DMA IF} /tb_top/dma_if/aw_len_o
add wave -noupdate -group {DMA IF} /tb_top/dma_if/aw_size_o
add wave -noupdate -group {DMA IF} /tb_top/dma_if/aw_burst_o
add wave -noupdate -group {DMA IF} /tb_top/dma_if/r_valid_i
add wave -noupdate -group {DMA IF} /tb_top/dma_if/r_data_i
add wave -noupdate -group {DMA IF} /tb_top/dma_if/r_last_i
add wave -noupdate -group {DMA IF} /tb_top/dma_if/r_resp_i
add wave -noupdate -group {DMA IF} /tb_top/dma_if/r_ready_o
add wave -noupdate -group {DMA IF} /tb_top/dma_if/w_valid_o
add wave -noupdate -group {DMA IF} /tb_top/dma_if/w_data_o
add wave -noupdate -group {DMA IF} /tb_top/dma_if/w_ready_i
add wave -noupdate -group {DMA IF} /tb_top/dma_if/b_valid_i
add wave -noupdate -group {DMA IF} /tb_top/dma_if/b_resp_i
add wave -noupdate -group {DMA IF} /tb_top/dma_if/b_ready_o
add wave -noupdate -group {DMA IF} /tb_top/dma_if/reset_done
add wave -noupdate -group {DMA IF} /tb_top/dma_if/rd_master_idle_o
add wave -noupdate -group {DMA IF} /tb_top/dma_if/wr_master_idle_o
add wave -noupdate -group {DMA DUT} /tb_top/dma_dut/aclk
add wave -noupdate -group {DMA DUT} /tb_top/dma_dut/rst_n
add wave -noupdate -group {DMA DUT} /tb_top/dma_dut/done_intrpt_o
add wave -noupdate -group {DMA DUT} /tb_top/dma_dut/error_intrpt_o
add wave -noupdate -group {DMA DUT} /tb_top/dma_dut/rm_req
add wave -noupdate -group {DMA DUT} /tb_top/dma_dut/rm_addr
add wave -noupdate -group {DMA DUT} /tb_top/dma_dut/desc_addr_arb
add wave -noupdate -group {DMA DUT} /tb_top/dma_dut/desc_fetch_arb
add wave -noupdate -group {DMA DUT} /tb_top/dma_dut/wm_req
add wave -noupdate -group {DMA DUT} /tb_top/dma_dut/wm_addr
add wave -noupdate -group {DMA DUT} /tb_top/dma_dut/master_len
add wave -noupdate -group {DMA DUT} /tb_top/dma_dut/wm_data
add wave -noupdate -group {DMA DUT} /tb_top/dma_dut/cpu_op
add wave -noupdate -group {DMA DUT} /tb_top/dma_dut/axi_read_done
add wave -noupdate -group {DMA DUT} /tb_top/dma_dut/axi_write_done
add wave -noupdate -group {DMA DUT} /tb_top/dma_dut/axi_read_data
add wave -noupdate -group {DMA DUT} /tb_top/dma_dut/axi_desc_data
add wave -noupdate -group {DMA DUT} /tb_top/dma_dut/axi_data_valid
add wave -noupdate -group {DMA DUT} /tb_top/dma_dut/axi_read_error
add wave -noupdate -group {DMA DUT} /tb_top/dma_dut/axi_write_error
add wave -noupdate -group {DMA DUT} /tb_top/dma_dut/axi_master_idle
add wave -noupdate -group {DMA DUT} /tb_top/dma_dut/axi_wr_master_idle
add wave -noupdate -group {DMA DUT} /tb_top/dma_dut/ch_en
add wave -noupdate -group {DMA DUT} /tb_top/dma_dut/ch_abort
add wave -noupdate -group {DMA DUT} /tb_top/dma_dut/ch_done
add wave -noupdate -group {DMA DUT} /tb_top/dma_dut/busy
add wave -noupdate -group {DMA DUT} /tb_top/dma_dut/response_valid
add wave -noupdate -group {DMA DUT} /tb_top/dma_dut/clear_en
add wave -noupdate -group {DMA DUT} /tb_top/dma_dut/fsm_ch_req
add wave -noupdate -group {DMA DUT} /tb_top/dma_dut/fsm_start_read
add wave -noupdate -group {DMA DUT} /tb_top/dma_dut/fsm_write_start
add wave -noupdate -group {DMA DUT} /tb_top/dma_dut/fsm_src_address
add wave -noupdate -group {DMA DUT} /tb_top/dma_dut/fsm_dest_address
add wave -noupdate -group {DMA DUT} /tb_top/dma_dut/fsm_desc_address
add wave -noupdate -group {DMA DUT} /tb_top/dma_dut/fsm_len
add wave -noupdate -group {DMA DUT} /tb_top/dma_dut/fsm_type_in
add wave -noupdate -group {DMA DUT} /tb_top/dma_dut/fsm_grant
add wave -noupdate -group {DMA DUT} /tb_top/dma_dut/fsm_desc_data_out
add wave -noupdate -group {DMA DUT} /tb_top/dma_dut/fsm_desc_valid
add wave -noupdate -group {DMA DUT} /tb_top/dma_dut/fsm_read_done
add wave -noupdate -group {DMA DUT} /tb_top/dma_dut/fsm_write_done
add wave -noupdate -group {DMA DUT} /tb_top/dma_dut/fsm_read_error
add wave -noupdate -group {DMA DUT} /tb_top/dma_dut/fsm_write_error
add wave -noupdate -group {DMA DUT} /tb_top/dma_dut/int_src_addr
add wave -noupdate -group {DMA DUT} /tb_top/dma_dut/int_dest_addr
add wave -noupdate -group {DMA DUT} /tb_top/dma_dut/int_desc_addr
add wave -noupdate -group {DMA DUT} /tb_top/dma_dut/int_transfer_len
add wave -noupdate -group {DMA DUT} /tb_top/dma_dut/int_start_read
add wave -noupdate -group {DMA DUT} /tb_top/dma_dut/int_start_write
add wave -noupdate -group {DMA DUT} /tb_top/dma_dut/int_desc_fetch
add wave -noupdate -group {DMA DUT} /tb_top/dma_dut/int_read_done
add wave -noupdate -group {DMA DUT} /tb_top/dma_dut/int_write_done
add wave -noupdate -group {DMA DUT} /tb_top/dma_dut/int_read_error
add wave -noupdate -group {DMA DUT} /tb_top/dma_dut/int_write_error
add wave -noupdate -group {DMA DUT} /tb_top/dma_dut/int_desc_data
add wave -noupdate -group {DMA DUT} /tb_top/dma_dut/int_desc_valid
add wave -noupdate -group {DMA DUT} /tb_top/dma_dut/int_read_master_idle
add wave -noupdate -group {DMA DUT} /tb_top/dma_dut/int_write_master_idle
add wave -noupdate -expand -group {DMA REG TOP} /tb_top/dma_dut/dma_reg_top_inst/aclk
add wave -noupdate -expand -group {DMA REG TOP} /tb_top/dma_dut/dma_reg_top_inst/rst_n
add wave -noupdate -expand -group {DMA REG TOP} /tb_top/dma_dut/dma_reg_top_inst/awaddr
add wave -noupdate -expand -group {DMA REG TOP} /tb_top/dma_dut/dma_reg_top_inst/awvalid
add wave -noupdate -expand -group {DMA REG TOP} /tb_top/dma_dut/dma_reg_top_inst/awready
add wave -noupdate -expand -group {DMA REG TOP} /tb_top/dma_dut/dma_reg_top_inst/wdata
add wave -noupdate -expand -group {DMA REG TOP} /tb_top/dma_dut/dma_reg_top_inst/wstrb
add wave -noupdate -expand -group {DMA REG TOP} /tb_top/dma_dut/dma_reg_top_inst/wvalid
add wave -noupdate -expand -group {DMA REG TOP} /tb_top/dma_dut/dma_reg_top_inst/wready
add wave -noupdate -expand -group {DMA REG TOP} /tb_top/dma_dut/dma_reg_top_inst/bresp
add wave -noupdate -expand -group {DMA REG TOP} /tb_top/dma_dut/dma_reg_top_inst/bvalid
add wave -noupdate -expand -group {DMA REG TOP} /tb_top/dma_dut/dma_reg_top_inst/bready
add wave -noupdate -expand -group {DMA REG TOP} /tb_top/dma_dut/dma_reg_top_inst/araddr
add wave -noupdate -expand -group {DMA REG TOP} /tb_top/dma_dut/dma_reg_top_inst/arvalid
add wave -noupdate -expand -group {DMA REG TOP} /tb_top/dma_dut/dma_reg_top_inst/arready
add wave -noupdate -expand -group {DMA REG TOP} /tb_top/dma_dut/dma_reg_top_inst/rdata
add wave -noupdate -expand -group {DMA REG TOP} /tb_top/dma_dut/dma_reg_top_inst/rresp
add wave -noupdate -expand -group {DMA REG TOP} /tb_top/dma_dut/dma_reg_top_inst/rvalid
add wave -noupdate -expand -group {DMA REG TOP} /tb_top/dma_dut/dma_reg_top_inst/rready
add wave -noupdate -expand -group {DMA REG TOP} /tb_top/dma_dut/dma_reg_top_inst/ch_en_o
add wave -noupdate -expand -group {DMA REG TOP} /tb_top/dma_dut/dma_reg_top_inst/ch_abort_o
add wave -noupdate -expand -group {DMA REG TOP} /tb_top/dma_dut/dma_reg_top_inst/done_i
add wave -noupdate -expand -group {DMA REG TOP} /tb_top/dma_dut/dma_reg_top_inst/resp_valid_i
add wave -noupdate -expand -group {DMA REG TOP} /tb_top/dma_dut/dma_reg_top_inst/busy_i
add wave -noupdate -expand -group {DMA REG TOP} /tb_top/dma_dut/dma_reg_top_inst/clear_en_i
add wave -noupdate -expand -group {DMA REG TOP} /tb_top/dma_dut/dma_reg_top_inst/irq_o
add wave -noupdate -expand -group {DMA REG TOP} /tb_top/dma_dut/dma_reg_top_inst/err_irq_o
add wave -noupdate -expand -group {DMA REG TOP} /tb_top/dma_dut/dma_reg_top_inst/reg_index
add wave -noupdate -expand -group {DMA REG TOP} /tb_top/dma_dut/dma_reg_top_inst/wdata_rf
add wave -noupdate -expand -group {DMA REG TOP} /tb_top/dma_dut/dma_reg_top_inst/wstrb_rf
add wave -noupdate -expand -group {DMA REG TOP} /tb_top/dma_dut/dma_reg_top_inst/wen
add wave -noupdate -expand -group {DMA REG TOP} /tb_top/dma_dut/dma_reg_top_inst/ren
add wave -noupdate -expand -group {DMA REG TOP} /tb_top/dma_dut/dma_reg_top_inst/rdata_rf
add wave -noupdate -group {REGISTER FILE} /tb_top/dma_dut/dma_reg_top_inst/u_reg_file/aclk
add wave -noupdate -group {REGISTER FILE} /tb_top/dma_dut/dma_reg_top_inst/u_reg_file/rst_n
add wave -noupdate -group {REGISTER FILE} /tb_top/dma_dut/dma_reg_top_inst/u_reg_file/reg_index
add wave -noupdate -group {REGISTER FILE} /tb_top/dma_dut/dma_reg_top_inst/u_reg_file/wdata
add wave -noupdate -group {REGISTER FILE} /tb_top/dma_dut/dma_reg_top_inst/u_reg_file/wstrb
add wave -noupdate -group {REGISTER FILE} /tb_top/dma_dut/dma_reg_top_inst/u_reg_file/wen
add wave -noupdate -group {REGISTER FILE} /tb_top/dma_dut/dma_reg_top_inst/u_reg_file/ren
add wave -noupdate -group {REGISTER FILE} /tb_top/dma_dut/dma_reg_top_inst/u_reg_file/rdata
add wave -noupdate -group {REGISTER FILE} /tb_top/dma_dut/dma_reg_top_inst/u_reg_file/ch_en_o
add wave -noupdate -group {REGISTER FILE} /tb_top/dma_dut/dma_reg_top_inst/u_reg_file/ch_abort_o
add wave -noupdate -group {REGISTER FILE} /tb_top/dma_dut/dma_reg_top_inst/u_reg_file/done_i
add wave -noupdate -group {REGISTER FILE} /tb_top/dma_dut/dma_reg_top_inst/u_reg_file/resp_valid_i
add wave -noupdate -group {REGISTER FILE} /tb_top/dma_dut/dma_reg_top_inst/u_reg_file/busy_i
add wave -noupdate -group {REGISTER FILE} /tb_top/dma_dut/dma_reg_top_inst/u_reg_file/clear_en_i
add wave -noupdate -group {REGISTER FILE} /tb_top/dma_dut/dma_reg_top_inst/u_reg_file/err_irq_o
add wave -noupdate -group {REGISTER FILE} /tb_top/dma_dut/dma_reg_top_inst/u_reg_file/irq_o
add wave -noupdate -group {REGISTER FILE} /tb_top/dma_dut/dma_reg_top_inst/u_reg_file/reg_is_writable
add wave -noupdate -group {SLAVE CONTROLLER} /tb_top/dma_dut/dma_reg_top_inst/u_axi_slave/reg_index_o
add wave -noupdate -group {SLAVE CONTROLLER} /tb_top/dma_dut/dma_reg_top_inst/u_axi_slave/wdata_o
add wave -noupdate -group {SLAVE CONTROLLER} /tb_top/dma_dut/dma_reg_top_inst/u_axi_slave/wstrb_o
add wave -noupdate -group {SLAVE CONTROLLER} /tb_top/dma_dut/dma_reg_top_inst/u_axi_slave/wen_o
add wave -noupdate -group {SLAVE CONTROLLER} /tb_top/dma_dut/dma_reg_top_inst/u_axi_slave/ren_o
add wave -noupdate -group {SLAVE CONTROLLER} /tb_top/dma_dut/dma_reg_top_inst/u_axi_slave/rdata_i
add wave -noupdate -group {SLAVE CONTROLLER} /tb_top/dma_dut/dma_reg_top_inst/u_axi_slave/write_addr_index
add wave -noupdate -group {SLAVE CONTROLLER} /tb_top/dma_dut/dma_reg_top_inst/u_axi_slave/read_addr_index
add wave -noupdate -group {SLAVE CONTROLLER} /tb_top/dma_dut/dma_reg_top_inst/u_axi_slave/addr_valid_write
add wave -noupdate -group {SLAVE CONTROLLER} /tb_top/dma_dut/dma_reg_top_inst/u_axi_slave/addr_valid_read
add wave -noupdate -group {SLAVE CONTROLLER} /tb_top/dma_dut/dma_reg_top_inst/u_axi_slave/aw_offset
add wave -noupdate -group {SLAVE CONTROLLER} /tb_top/dma_dut/dma_reg_top_inst/u_axi_slave/ar_offset
add wave -noupdate -group {SLAVE CONTROLLER} /tb_top/dma_dut/dma_reg_top_inst/u_axi_slave/aw_aligned
add wave -noupdate -group {SLAVE CONTROLLER} /tb_top/dma_dut/dma_reg_top_inst/u_axi_slave/ar_aligned
add wave -noupdate -group {SLAVE CONTROLLER} /tb_top/dma_dut/dma_reg_top_inst/u_axi_slave/aw_in_range
add wave -noupdate -group {SLAVE CONTROLLER} /tb_top/dma_dut/dma_reg_top_inst/u_axi_slave/ar_in_range
add wave -noupdate -group {SLAVE CONTROLLER} /tb_top/dma_dut/dma_reg_top_inst/u_axi_slave/write_state
add wave -noupdate -group {SLAVE CONTROLLER} /tb_top/dma_dut/dma_reg_top_inst/u_axi_slave/read_state
add wave -noupdate -group {AXI LITE INTF} /tb_top/dma_dut/dma_reg_top_inst/axi_if/aclk
add wave -noupdate -group {AXI LITE INTF} /tb_top/dma_dut/dma_reg_top_inst/axi_if/rst_n
add wave -noupdate -group {AXI LITE INTF} /tb_top/dma_dut/dma_reg_top_inst/axi_if/awaddr
add wave -noupdate -group {AXI LITE INTF} /tb_top/dma_dut/dma_reg_top_inst/axi_if/awvalid
add wave -noupdate -group {AXI LITE INTF} /tb_top/dma_dut/dma_reg_top_inst/axi_if/awready
add wave -noupdate -group {AXI LITE INTF} /tb_top/dma_dut/dma_reg_top_inst/axi_if/wdata
add wave -noupdate -group {AXI LITE INTF} /tb_top/dma_dut/dma_reg_top_inst/axi_if/wstrb
add wave -noupdate -group {AXI LITE INTF} /tb_top/dma_dut/dma_reg_top_inst/axi_if/wvalid
add wave -noupdate -group {AXI LITE INTF} /tb_top/dma_dut/dma_reg_top_inst/axi_if/wready
add wave -noupdate -group {AXI LITE INTF} /tb_top/dma_dut/dma_reg_top_inst/axi_if/bresp
add wave -noupdate -group {AXI LITE INTF} /tb_top/dma_dut/dma_reg_top_inst/axi_if/bvalid
add wave -noupdate -group {AXI LITE INTF} /tb_top/dma_dut/dma_reg_top_inst/axi_if/bready
add wave -noupdate -group {AXI LITE INTF} /tb_top/dma_dut/dma_reg_top_inst/axi_if/araddr
add wave -noupdate -group {AXI LITE INTF} /tb_top/dma_dut/dma_reg_top_inst/axi_if/arvalid
add wave -noupdate -group {AXI LITE INTF} /tb_top/dma_dut/dma_reg_top_inst/axi_if/arready
add wave -noupdate -group {AXI LITE INTF} /tb_top/dma_dut/dma_reg_top_inst/axi_if/rdata
add wave -noupdate -group {AXI LITE INTF} /tb_top/dma_dut/dma_reg_top_inst/axi_if/rresp
add wave -noupdate -group {AXI LITE INTF} /tb_top/dma_dut/dma_reg_top_inst/axi_if/rvalid
add wave -noupdate -group {AXI LITE INTF} /tb_top/dma_dut/dma_reg_top_inst/axi_if/rready
add wave -noupdate -expand -group {DMA FSM CH 0} {/tb_top/dma_dut/gen_dma_fsm[0]/dma_fsm_inst/clk}
add wave -noupdate -expand -group {DMA FSM CH 0} {/tb_top/dma_dut/gen_dma_fsm[0]/dma_fsm_inst/rst_n}
add wave -noupdate -expand -group {DMA FSM CH 0} {/tb_top/dma_dut/gen_dma_fsm[0]/dma_fsm_inst/ch_en}
add wave -noupdate -expand -group {DMA FSM CH 0} {/tb_top/dma_dut/gen_dma_fsm[0]/dma_fsm_inst/desc_ptr}
add wave -noupdate -expand -group {DMA FSM CH 0} {/tb_top/dma_dut/gen_dma_fsm[0]/dma_fsm_inst/ch_abort}
add wave -noupdate -expand -group {DMA FSM CH 0} {/tb_top/dma_dut/gen_dma_fsm[0]/dma_fsm_inst/error_response}
add wave -noupdate -expand -group {DMA FSM CH 0} {/tb_top/dma_dut/gen_dma_fsm[0]/dma_fsm_inst/desc_valid}
add wave -noupdate -expand -group {DMA FSM CH 0} {/tb_top/dma_dut/gen_dma_fsm[0]/dma_fsm_inst/grant}
add wave -noupdate -expand -group {DMA FSM CH 0} {/tb_top/dma_dut/gen_dma_fsm[0]/dma_fsm_inst/read_done}
add wave -noupdate -expand -group {DMA FSM CH 0} {/tb_top/dma_dut/gen_dma_fsm[0]/dma_fsm_inst/write_done}
add wave -noupdate -expand -group {DMA FSM CH 0} {/tb_top/dma_dut/gen_dma_fsm[0]/dma_fsm_inst/write_error}
add wave -noupdate -expand -group {DMA FSM CH 0} {/tb_top/dma_dut/gen_dma_fsm[0]/dma_fsm_inst/read_error}
add wave -noupdate -expand -group {DMA FSM CH 0} {/tb_top/dma_dut/gen_dma_fsm[0]/dma_fsm_inst/desc_data}
add wave -noupdate -expand -group {DMA FSM CH 0} {/tb_top/dma_dut/gen_dma_fsm[0]/dma_fsm_inst/ch_done}
add wave -noupdate -expand -group {DMA FSM CH 0} {/tb_top/dma_dut/gen_dma_fsm[0]/dma_fsm_inst/busy}
add wave -noupdate -expand -group {DMA FSM CH 0} {/tb_top/dma_dut/gen_dma_fsm[0]/dma_fsm_inst/ch_req}
add wave -noupdate -expand -group {DMA FSM CH 0} {/tb_top/dma_dut/gen_dma_fsm[0]/dma_fsm_inst/start_read}
add wave -noupdate -expand -group {DMA FSM CH 0} {/tb_top/dma_dut/gen_dma_fsm[0]/dma_fsm_inst/start_write}
add wave -noupdate -expand -group {DMA FSM CH 0} {/tb_top/dma_dut/gen_dma_fsm[0]/dma_fsm_inst/src_addr}
add wave -noupdate -expand -group {DMA FSM CH 0} {/tb_top/dma_dut/gen_dma_fsm[0]/dma_fsm_inst/dest_addr}
add wave -noupdate -expand -group {DMA FSM CH 0} {/tb_top/dma_dut/gen_dma_fsm[0]/dma_fsm_inst/len}
add wave -noupdate -expand -group {DMA FSM CH 0} {/tb_top/dma_dut/gen_dma_fsm[0]/dma_fsm_inst/desc_fetch}
add wave -noupdate -expand -group {DMA FSM CH 0} {/tb_top/dma_dut/gen_dma_fsm[0]/dma_fsm_inst/desc_addr}
add wave -noupdate -expand -group {DMA FSM CH 0} {/tb_top/dma_dut/gen_dma_fsm[0]/dma_fsm_inst/response_valid}
add wave -noupdate -expand -group {DMA FSM CH 0} {/tb_top/dma_dut/gen_dma_fsm[0]/dma_fsm_inst/response_status}
add wave -noupdate -expand -group {DMA FSM CH 0} {/tb_top/dma_dut/gen_dma_fsm[0]/dma_fsm_inst/clear_en_o}
add wave -noupdate -expand -group {DMA FSM CH 0} {/tb_top/dma_dut/gen_dma_fsm[0]/dma_fsm_inst/nxt_desc_reg}
add wave -noupdate -expand -group {DMA FSM CH 0} {/tb_top/dma_dut/gen_dma_fsm[0]/dma_fsm_inst/ch_abort_reg}
add wave -noupdate -expand -group {DMA FSM CH 0} {/tb_top/dma_dut/gen_dma_fsm[0]/dma_fsm_inst/src_addr_reg}
add wave -noupdate -expand -group {DMA FSM CH 0} {/tb_top/dma_dut/gen_dma_fsm[0]/dma_fsm_inst/dest_addr_reg}
add wave -noupdate -expand -group {DMA FSM CH 0} {/tb_top/dma_dut/gen_dma_fsm[0]/dma_fsm_inst/len_and_flag_reg}
add wave -noupdate -expand -group {DMA FSM CH 0} {/tb_top/dma_dut/gen_dma_fsm[0]/dma_fsm_inst/response_reg}
add wave -noupdate -expand -group {DMA FSM CH 0} {/tb_top/dma_dut/gen_dma_fsm[0]/dma_fsm_inst/response_valid_reg}
add wave -noupdate -expand -group {DMA FSM CH 0} {/tb_top/dma_dut/gen_dma_fsm[0]/dma_fsm_inst/current_state}
add wave -noupdate -expand -group {DMA FSM CH 0} {/tb_top/dma_dut/gen_dma_fsm[0]/dma_fsm_inst/next_state}
add wave -noupdate -expand -group {INTERNAL ARBITER} /tb_top/dma_dut/int_arbiter_inst/clk
add wave -noupdate -expand -group {INTERNAL ARBITER} /tb_top/dma_dut/int_arbiter_inst/rst_n
add wave -noupdate -expand -group {INTERNAL ARBITER} /tb_top/dma_dut/int_arbiter_inst/ch_req
add wave -noupdate -expand -group {INTERNAL ARBITER} /tb_top/dma_dut/int_arbiter_inst/start_read
add wave -noupdate -expand -group {INTERNAL ARBITER} /tb_top/dma_dut/int_arbiter_inst/write_start
add wave -noupdate -expand -group {INTERNAL ARBITER} /tb_top/dma_dut/int_arbiter_inst/src_address
add wave -noupdate -expand -group {INTERNAL ARBITER} /tb_top/dma_dut/int_arbiter_inst/dest_address
add wave -noupdate -expand -group {INTERNAL ARBITER} /tb_top/dma_dut/int_arbiter_inst/desc_address
add wave -noupdate -expand -group {INTERNAL ARBITER} /tb_top/dma_dut/int_arbiter_inst/len
add wave -noupdate -expand -group {INTERNAL ARBITER} /tb_top/dma_dut/int_arbiter_inst/type_in
add wave -noupdate -expand -group {INTERNAL ARBITER} /tb_top/dma_dut/int_arbiter_inst/grant
add wave -noupdate -expand -group {INTERNAL ARBITER} /tb_top/dma_dut/int_arbiter_inst/desc_data_out
add wave -noupdate -expand -group {INTERNAL ARBITER} /tb_top/dma_dut/int_arbiter_inst/desc_valid
add wave -noupdate -expand -group {INTERNAL ARBITER} /tb_top/dma_dut/int_arbiter_inst/read_done
add wave -noupdate -expand -group {INTERNAL ARBITER} /tb_top/dma_dut/int_arbiter_inst/write_done
add wave -noupdate -expand -group {INTERNAL ARBITER} /tb_top/dma_dut/int_arbiter_inst/read_error
add wave -noupdate -expand -group {INTERNAL ARBITER} /tb_top/dma_dut/int_arbiter_inst/write_error
add wave -noupdate -expand -group {INTERNAL ARBITER} /tb_top/dma_dut/int_arbiter_inst/rd_master_idle
add wave -noupdate -expand -group {INTERNAL ARBITER} /tb_top/dma_dut/int_arbiter_inst/wr_master_idle
add wave -noupdate -expand -group {INTERNAL ARBITER} /tb_top/dma_dut/int_arbiter_inst/read_done_in
add wave -noupdate -expand -group {INTERNAL ARBITER} /tb_top/dma_dut/int_arbiter_inst/write_done_in
add wave -noupdate -expand -group {INTERNAL ARBITER} /tb_top/dma_dut/int_arbiter_inst/read_error_in
add wave -noupdate -expand -group {INTERNAL ARBITER} /tb_top/dma_dut/int_arbiter_inst/write_error_in
add wave -noupdate -expand -group {INTERNAL ARBITER} /tb_top/dma_dut/int_arbiter_inst/datavalid_in
add wave -noupdate -expand -group {INTERNAL ARBITER} /tb_top/dma_dut/int_arbiter_inst/desc_data_in
add wave -noupdate -expand -group {INTERNAL ARBITER} /tb_top/dma_dut/int_arbiter_inst/src_address_o
add wave -noupdate -expand -group {INTERNAL ARBITER} /tb_top/dma_dut/int_arbiter_inst/dest_address_o
add wave -noupdate -expand -group {INTERNAL ARBITER} /tb_top/dma_dut/int_arbiter_inst/desc_address_o
add wave -noupdate -expand -group {INTERNAL ARBITER} /tb_top/dma_dut/int_arbiter_inst/transfer_length_o
add wave -noupdate -expand -group {INTERNAL ARBITER} /tb_top/dma_dut/int_arbiter_inst/start_read_i
add wave -noupdate -expand -group {INTERNAL ARBITER} /tb_top/dma_dut/int_arbiter_inst/start_write_i
add wave -noupdate -expand -group {INTERNAL ARBITER} /tb_top/dma_dut/int_arbiter_inst/desc_fetch_o
add wave -noupdate -expand -group {INTERNAL ARBITER} /tb_top/dma_dut/int_arbiter_inst/update_rr_ptr
add wave -noupdate -expand -group {INTERNAL ARBITER} /tb_top/dma_dut/int_arbiter_inst/current_ch_id
add wave -noupdate -expand -group {INTERNAL ARBITER} /tb_top/dma_dut/int_arbiter_inst/sel_en
add wave -noupdate -expand -group {INTERNAL ARBITER} /tb_top/dma_dut/int_arbiter_inst/sel_src
add wave -noupdate -expand -group {INTERNAL ARBITER} /tb_top/dma_dut/int_arbiter_inst/sel_dest
add wave -noupdate -expand -group {INTERNAL ARBITER} /tb_top/dma_dut/int_arbiter_inst/sel_desc_addr
add wave -noupdate -expand -group {INTERNAL ARBITER} /tb_top/dma_dut/int_arbiter_inst/sel_len
add wave -noupdate -expand -group {INTERNAL ARBITER} /tb_top/dma_dut/int_arbiter_inst/sel_type
add wave -noupdate -expand -group {INTERNAL ARBITER} /tb_top/dma_dut/int_arbiter_inst/do_read_trigger
add wave -noupdate -expand -group {INTERNAL ARBITER} /tb_top/dma_dut/int_arbiter_inst/do_write_trigger
add wave -noupdate -expand -group {INTERNAL ARBITER} /tb_top/dma_dut/int_arbiter_inst/resp_en
add wave -noupdate -expand -group {INTERNAL ARBITER} /tb_top/dma_dut/int_arbiter_inst/route_desc
add wave -noupdate -expand -group {INTERNAL ARBITER} /tb_top/dma_dut/int_arbiter_inst/route_read
add wave -noupdate -expand -group {INTERNAL ARBITER} /tb_top/dma_dut/int_arbiter_inst/route_write
add wave -noupdate -expand -group {INTERNAL ARBITER} /tb_top/dma_dut/int_arbiter_inst/ch_rq_any
add wave -noupdate -expand -group {INTERNAL ARBITER} /tb_top/dma_dut/int_arbiter_inst/start_read_any
add wave -noupdate -expand -group {INTERNAL ARBITER} /tb_top/dma_dut/int_arbiter_inst/write_start_any
add wave -noupdate -group {INTERNAL ARBITER CH_REQ_MUX} /tb_top/dma_dut/int_arbiter_inst/u_ch_mux/clk
add wave -noupdate -group {INTERNAL ARBITER CH_REQ_MUX} /tb_top/dma_dut/int_arbiter_inst/u_ch_mux/rst_n
add wave -noupdate -group {INTERNAL ARBITER CH_REQ_MUX} /tb_top/dma_dut/int_arbiter_inst/u_ch_mux/current_ch_id
add wave -noupdate -group {INTERNAL ARBITER CH_REQ_MUX} /tb_top/dma_dut/int_arbiter_inst/u_ch_mux/sel_en
add wave -noupdate -group {INTERNAL ARBITER CH_REQ_MUX} /tb_top/dma_dut/int_arbiter_inst/u_ch_mux/src_address
add wave -noupdate -group {INTERNAL ARBITER CH_REQ_MUX} /tb_top/dma_dut/int_arbiter_inst/u_ch_mux/dest_address
add wave -noupdate -group {INTERNAL ARBITER CH_REQ_MUX} /tb_top/dma_dut/int_arbiter_inst/u_ch_mux/desc_address
add wave -noupdate -group {INTERNAL ARBITER CH_REQ_MUX} /tb_top/dma_dut/int_arbiter_inst/u_ch_mux/len
add wave -noupdate -group {INTERNAL ARBITER CH_REQ_MUX} /tb_top/dma_dut/int_arbiter_inst/u_ch_mux/type_in
add wave -noupdate -group {INTERNAL ARBITER CH_REQ_MUX} /tb_top/dma_dut/int_arbiter_inst/u_ch_mux/sel_src
add wave -noupdate -group {INTERNAL ARBITER CH_REQ_MUX} /tb_top/dma_dut/int_arbiter_inst/u_ch_mux/sel_dest
add wave -noupdate -group {INTERNAL ARBITER CH_REQ_MUX} /tb_top/dma_dut/int_arbiter_inst/u_ch_mux/sel_desc_addr
add wave -noupdate -group {INTERNAL ARBITER CH_REQ_MUX} /tb_top/dma_dut/int_arbiter_inst/u_ch_mux/sel_len
add wave -noupdate -group {INTERNAL ARBITER CH_REQ_MUX} /tb_top/dma_dut/int_arbiter_inst/u_ch_mux/sel_type
add wave -noupdate -group {INTERNAL ARBITER CH_REQ_MUX} /tb_top/dma_dut/int_arbiter_inst/u_ch_mux/desc_debug
add wave -noupdate -expand -group {INTERNAL ARBITER CONTROLLER} /tb_top/dma_dut/int_arbiter_inst/u_controller/clk
add wave -noupdate -expand -group {INTERNAL ARBITER CONTROLLER} /tb_top/dma_dut/int_arbiter_inst/u_controller/rst_n
add wave -noupdate -expand -group {INTERNAL ARBITER CONTROLLER} /tb_top/dma_dut/int_arbiter_inst/u_controller/ch_rq_any
add wave -noupdate -expand -group {INTERNAL ARBITER CONTROLLER} /tb_top/dma_dut/int_arbiter_inst/u_controller/start_read
add wave -noupdate -expand -group {INTERNAL ARBITER CONTROLLER} /tb_top/dma_dut/int_arbiter_inst/u_controller/write_start
add wave -noupdate -expand -group {INTERNAL ARBITER CONTROLLER} /tb_top/dma_dut/int_arbiter_inst/u_controller/sel_type
add wave -noupdate -expand -group {INTERNAL ARBITER CONTROLLER} /tb_top/dma_dut/int_arbiter_inst/u_controller/rd_master_idle
add wave -noupdate -expand -group {INTERNAL ARBITER CONTROLLER} /tb_top/dma_dut/int_arbiter_inst/u_controller/wr_master_idle
add wave -noupdate -expand -group {INTERNAL ARBITER CONTROLLER} /tb_top/dma_dut/int_arbiter_inst/u_controller/read_done_in
add wave -noupdate -expand -group {INTERNAL ARBITER CONTROLLER} /tb_top/dma_dut/int_arbiter_inst/u_controller/write_done_in
add wave -noupdate -expand -group {INTERNAL ARBITER CONTROLLER} /tb_top/dma_dut/int_arbiter_inst/u_controller/sel_en
add wave -noupdate -expand -group {INTERNAL ARBITER CONTROLLER} /tb_top/dma_dut/int_arbiter_inst/u_controller/do_read_trigger
add wave -noupdate -expand -group {INTERNAL ARBITER CONTROLLER} /tb_top/dma_dut/int_arbiter_inst/u_controller/do_write_trigger
add wave -noupdate -expand -group {INTERNAL ARBITER CONTROLLER} /tb_top/dma_dut/int_arbiter_inst/u_controller/resp_en
add wave -noupdate -expand -group {INTERNAL ARBITER CONTROLLER} /tb_top/dma_dut/int_arbiter_inst/u_controller/update_rr_ptr
add wave -noupdate -expand -group {INTERNAL ARBITER CONTROLLER} /tb_top/dma_dut/int_arbiter_inst/u_controller/route_desc
add wave -noupdate -expand -group {INTERNAL ARBITER CONTROLLER} /tb_top/dma_dut/int_arbiter_inst/u_controller/route_read
add wave -noupdate -expand -group {INTERNAL ARBITER CONTROLLER} /tb_top/dma_dut/int_arbiter_inst/u_controller/route_write
add wave -noupdate -expand -group {INTERNAL ARBITER CONTROLLER} /tb_top/dma_dut/int_arbiter_inst/u_controller/current_state
add wave -noupdate -expand -group {INTERNAL ARBITER CONTROLLER} /tb_top/dma_dut/int_arbiter_inst/u_controller/next_state
add wave -noupdate -expand -group {INTERNAL ARBITER CONTROLLER} /tb_top/dma_dut/int_arbiter_inst/u_controller/fsm_state
add wave -noupdate -group {INTERNAL ARBITER RESP DEMUX} /tb_top/dma_dut/int_arbiter_inst/u_resp_demux/resp_en
add wave -noupdate -group {INTERNAL ARBITER RESP DEMUX} /tb_top/dma_dut/int_arbiter_inst/u_resp_demux/route_desc
add wave -noupdate -group {INTERNAL ARBITER RESP DEMUX} /tb_top/dma_dut/int_arbiter_inst/u_resp_demux/route_read
add wave -noupdate -group {INTERNAL ARBITER RESP DEMUX} /tb_top/dma_dut/int_arbiter_inst/u_resp_demux/route_write
add wave -noupdate -group {INTERNAL ARBITER RESP DEMUX} /tb_top/dma_dut/int_arbiter_inst/u_resp_demux/current_ch_id
add wave -noupdate -group {INTERNAL ARBITER RESP DEMUX} /tb_top/dma_dut/int_arbiter_inst/u_resp_demux/read_done_in
add wave -noupdate -group {INTERNAL ARBITER RESP DEMUX} /tb_top/dma_dut/int_arbiter_inst/u_resp_demux/write_done_in
add wave -noupdate -group {INTERNAL ARBITER RESP DEMUX} /tb_top/dma_dut/int_arbiter_inst/u_resp_demux/read_error_in
add wave -noupdate -group {INTERNAL ARBITER RESP DEMUX} /tb_top/dma_dut/int_arbiter_inst/u_resp_demux/write_error_in
add wave -noupdate -group {INTERNAL ARBITER RESP DEMUX} /tb_top/dma_dut/int_arbiter_inst/u_resp_demux/datavalid_in
add wave -noupdate -group {INTERNAL ARBITER RESP DEMUX} /tb_top/dma_dut/int_arbiter_inst/u_resp_demux/desc_data_in
add wave -noupdate -group {INTERNAL ARBITER RESP DEMUX} /tb_top/dma_dut/int_arbiter_inst/u_resp_demux/read_done
add wave -noupdate -group {INTERNAL ARBITER RESP DEMUX} /tb_top/dma_dut/int_arbiter_inst/u_resp_demux/write_done
add wave -noupdate -group {INTERNAL ARBITER RESP DEMUX} /tb_top/dma_dut/int_arbiter_inst/u_resp_demux/read_error
add wave -noupdate -group {INTERNAL ARBITER RESP DEMUX} /tb_top/dma_dut/int_arbiter_inst/u_resp_demux/write_error
add wave -noupdate -group {INTERNAL ARBITER RESP DEMUX} /tb_top/dma_dut/int_arbiter_inst/u_resp_demux/desc_valid
add wave -noupdate -group {INTERNAL ARBITER RESP DEMUX} /tb_top/dma_dut/int_arbiter_inst/u_resp_demux/desc_data_out
add wave -noupdate -group {EXTERNAL ARBITER TOP} /tb_top/dma_dut/ext_arbiter_inst/clk
add wave -noupdate -group {EXTERNAL ARBITER TOP} /tb_top/dma_dut/ext_arbiter_inst/rst_n
add wave -noupdate -group {EXTERNAL ARBITER TOP} /tb_top/dma_dut/ext_arbiter_inst/read_req
add wave -noupdate -group {EXTERNAL ARBITER TOP} /tb_top/dma_dut/ext_arbiter_inst/read_addr
add wave -noupdate -group {EXTERNAL ARBITER TOP} /tb_top/dma_dut/ext_arbiter_inst/write_req
add wave -noupdate -group {EXTERNAL ARBITER TOP} /tb_top/dma_dut/ext_arbiter_inst/write_addr
add wave -noupdate -group {EXTERNAL ARBITER TOP} /tb_top/dma_dut/ext_arbiter_inst/write_data
add wave -noupdate -group {EXTERNAL ARBITER TOP} /tb_top/dma_dut/ext_arbiter_inst/write_strb
add wave -noupdate -group {EXTERNAL ARBITER TOP} /tb_top/dma_dut/ext_arbiter_inst/c_read_done
add wave -noupdate -group {EXTERNAL ARBITER TOP} /tb_top/dma_dut/ext_arbiter_inst/c_write_done
add wave -noupdate -group {EXTERNAL ARBITER TOP} /tb_top/dma_dut/ext_arbiter_inst/read_data
add wave -noupdate -group {EXTERNAL ARBITER TOP} /tb_top/dma_dut/ext_arbiter_inst/c_read_error_o
add wave -noupdate -group {EXTERNAL ARBITER TOP} /tb_top/dma_dut/ext_arbiter_inst/c_write_error_o
add wave -noupdate -group {EXTERNAL ARBITER TOP} /tb_top/dma_dut/ext_arbiter_inst/start_read_i
add wave -noupdate -group {EXTERNAL ARBITER TOP} /tb_top/dma_dut/ext_arbiter_inst/src_addr
add wave -noupdate -group {EXTERNAL ARBITER TOP} /tb_top/dma_dut/ext_arbiter_inst/desc_addr_i
add wave -noupdate -group {EXTERNAL ARBITER TOP} /tb_top/dma_dut/ext_arbiter_inst/desc_fetch_i
add wave -noupdate -group {EXTERNAL ARBITER TOP} /tb_top/dma_dut/ext_arbiter_inst/start_write_i
add wave -noupdate -group {EXTERNAL ARBITER TOP} /tb_top/dma_dut/ext_arbiter_inst/dest_addr
add wave -noupdate -group {EXTERNAL ARBITER TOP} /tb_top/dma_dut/ext_arbiter_inst/transfer_len
add wave -noupdate -group {EXTERNAL ARBITER TOP} /tb_top/dma_dut/ext_arbiter_inst/d_read_done
add wave -noupdate -group {EXTERNAL ARBITER TOP} /tb_top/dma_dut/ext_arbiter_inst/d_write_done
add wave -noupdate -group {EXTERNAL ARBITER TOP} /tb_top/dma_dut/ext_arbiter_inst/d_read_error_o
add wave -noupdate -group {EXTERNAL ARBITER TOP} /tb_top/dma_dut/ext_arbiter_inst/d_write_error_o
add wave -noupdate -group {EXTERNAL ARBITER TOP} /tb_top/dma_dut/ext_arbiter_inst/desc_data
add wave -noupdate -group {EXTERNAL ARBITER TOP} /tb_top/dma_dut/ext_arbiter_inst/desc_valid
add wave -noupdate -group {EXTERNAL ARBITER TOP} /tb_top/dma_dut/ext_arbiter_inst/read_master_idle
add wave -noupdate -group {EXTERNAL ARBITER TOP} /tb_top/dma_dut/ext_arbiter_inst/write_master_idle
add wave -noupdate -group {EXTERNAL ARBITER TOP} /tb_top/dma_dut/ext_arbiter_inst/rm_req
add wave -noupdate -group {EXTERNAL ARBITER TOP} /tb_top/dma_dut/ext_arbiter_inst/rm_addr
add wave -noupdate -group {EXTERNAL ARBITER TOP} /tb_top/dma_dut/ext_arbiter_inst/desc_addr_o
add wave -noupdate -group {EXTERNAL ARBITER TOP} /tb_top/dma_dut/ext_arbiter_inst/desc_fetch_o
add wave -noupdate -group {EXTERNAL ARBITER TOP} /tb_top/dma_dut/ext_arbiter_inst/wm_req
add wave -noupdate -group {EXTERNAL ARBITER TOP} /tb_top/dma_dut/ext_arbiter_inst/wm_addr
add wave -noupdate -group {EXTERNAL ARBITER TOP} /tb_top/dma_dut/ext_arbiter_inst/master_len
add wave -noupdate -group {EXTERNAL ARBITER TOP} /tb_top/dma_dut/ext_arbiter_inst/wm_data
add wave -noupdate -group {EXTERNAL ARBITER TOP} /tb_top/dma_dut/ext_arbiter_inst/cpu_op_o
add wave -noupdate -group {EXTERNAL ARBITER TOP} /tb_top/dma_dut/ext_arbiter_inst/axi_read_done
add wave -noupdate -group {EXTERNAL ARBITER TOP} /tb_top/dma_dut/ext_arbiter_inst/axi_write_done
add wave -noupdate -group {EXTERNAL ARBITER TOP} /tb_top/dma_dut/ext_arbiter_inst/axi_read_data
add wave -noupdate -group {EXTERNAL ARBITER TOP} /tb_top/dma_dut/ext_arbiter_inst/axi_desc_data
add wave -noupdate -group {EXTERNAL ARBITER TOP} /tb_top/dma_dut/ext_arbiter_inst/axi_data_valid
add wave -noupdate -group {EXTERNAL ARBITER TOP} /tb_top/dma_dut/ext_arbiter_inst/axi_read_error
add wave -noupdate -group {EXTERNAL ARBITER TOP} /tb_top/dma_dut/ext_arbiter_inst/axi_write_error
add wave -noupdate -group {EXTERNAL ARBITER TOP} /tb_top/dma_dut/ext_arbiter_inst/axi_master_idle
add wave -noupdate -group {EXTERNAL ARBITER TOP} /tb_top/dma_dut/ext_arbiter_inst/axi_wr_master_idle
add wave -noupdate -group {EXTERNAL ARBITER TOP} /tb_top/dma_dut/ext_arbiter_inst/sel_cpu_r
add wave -noupdate -group {EXTERNAL ARBITER TOP} /tb_top/dma_dut/ext_arbiter_inst/sel_cpu_w
add wave -noupdate -group {EXTERNAL ARBITER TOP} /tb_top/dma_dut/ext_arbiter_inst/sel_dma_r
add wave -noupdate -group {EXTERNAL ARBITER TOP} /tb_top/dma_dut/ext_arbiter_inst/sel_dma_w
add wave -noupdate -group {EXTERNAL ARBITER TOP} /tb_top/dma_dut/ext_arbiter_inst/int_c_read_done
add wave -noupdate -group {EXTERNAL ARBITER TOP} /tb_top/dma_dut/ext_arbiter_inst/int_c_write_done
add wave -noupdate -group {EXTERNAL ARBITER TOP} /tb_top/dma_dut/ext_arbiter_inst/int_d_read_done
add wave -noupdate -group {EXTERNAL ARBITER TOP} /tb_top/dma_dut/ext_arbiter_inst/int_d_write_done
add wave -noupdate -group {AXI MASTER READ TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/clk
add wave -noupdate -group {AXI MASTER READ TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rst_n
add wave -noupdate -group {AXI MASTER READ TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/src_addr_i
add wave -noupdate -group {AXI MASTER READ TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/desc_fetch_i
add wave -noupdate -group {AXI MASTER READ TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/start_read_i
add wave -noupdate -group {AXI MASTER READ TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/transfer_len_i
add wave -noupdate -group {AXI MASTER READ TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/desc_addr_i
add wave -noupdate -group {AXI MASTER READ TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/cpu_op_i
add wave -noupdate -group {AXI MASTER READ TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/read_done_o
add wave -noupdate -group {AXI MASTER READ TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_master_idle_o
add wave -noupdate -group {AXI MASTER READ TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/read_error_o
add wave -noupdate -group {AXI MASTER READ TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/data_valid_o
add wave -noupdate -group {AXI MASTER READ TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/desc_data_o
add wave -noupdate -group {AXI MASTER READ TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/cpu_data_o
add wave -noupdate -group {AXI MASTER READ TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/ar_ready_i
add wave -noupdate -group {AXI MASTER READ TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/ar_valid_o
add wave -noupdate -group {AXI MASTER READ TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/ar_addr_o
add wave -noupdate -group {AXI MASTER READ TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/ar_len_o
add wave -noupdate -group {AXI MASTER READ TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/ar_size_o
add wave -noupdate -group {AXI MASTER READ TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/ar_burst_o
add wave -noupdate -group {AXI MASTER READ TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/r_valid_i
add wave -noupdate -group {AXI MASTER READ TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/r_data_i
add wave -noupdate -group {AXI MASTER READ TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/r_last_i
add wave -noupdate -group {AXI MASTER READ TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/r_resp_i
add wave -noupdate -group {AXI MASTER READ TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/r_ready_o
add wave -noupdate -group {AXI MASTER READ TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/fifo_full_i
add wave -noupdate -group {AXI MASTER READ TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/fifo_wr_en_o
add wave -noupdate -group {AXI MASTER READ TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/fifo_data_o
add wave -noupdate -group {AXI MASTER READ TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rst_rd_fifo_o
add wave -noupdate -group {AXI MASTER READ TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/load_burst_cntr
add wave -noupdate -group {AXI MASTER READ TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/load_beat_cntr
add wave -noupdate -group {AXI MASTER READ TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/burst_done
add wave -noupdate -group {AXI MASTER READ TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/beat_done
add wave -noupdate -group {AXI MASTER READ TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/beat_count_en
add wave -noupdate -group {AXI MASTER READ TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/burst_count_en
add wave -noupdate -group {AXI MASTER READ TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/r_ready
add wave -noupdate -group {AXI MASTER READ TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/beat_sel
add wave -noupdate -group {AXI MASTER READ TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/burst_sel
add wave -noupdate -group {AXI MASTER READ TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/err
add wave -noupdate -group {AXI MASTER READ TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/remaining_beats_zero
add wave -noupdate -group {AXI MASTER READ TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/load_beat_reg
add wave -noupdate -group {AXI MASTER READ TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/ld_desc_addr
add wave -noupdate -group {AXI MASTER READ TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/ar_addr_sel
add wave -noupdate -group {AXI MASTER READ TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/ar_len_sel
add wave -noupdate -group {AXI MASTER READ TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/sample_en
add wave -noupdate -group {AXI MASTER READ TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/desc_count_en
add wave -noupdate -group {AXI MASTER READ TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/ld_desc_data_r
add wave -noupdate -group {AXI MASTER READ TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/ld_src_addr
add wave -noupdate -group {AXI MASTER READ TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/ld_trans_len
add wave -noupdate -group {AXI MASTER READ TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/nxt_addr_sel
add wave -noupdate -group {AXI MASTER READ TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/desc_count_done
add wave -noupdate -group {AXI MASTER READ TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/latch_remain_burst_done_flag
add wave -noupdate -group {AXI MASTER READ TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/remain_burst_done_flag
add wave -noupdate -group {AXI MASTER READ TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/err_flag
add wave -noupdate -group {AXI MASTER READ TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/route_zeros
add wave -noupdate -group {AXI MASTER READ TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/ld_cpu_data
add wave -noupdate -expand -group {AXI MASTER READ DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_datapath/clk
add wave -noupdate -expand -group {AXI MASTER READ DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_datapath/rst_n
add wave -noupdate -expand -group {AXI MASTER READ DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_datapath/src_addr_i
add wave -noupdate -expand -group {AXI MASTER READ DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_datapath/start_read_i
add wave -noupdate -expand -group {AXI MASTER READ DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_datapath/desc_fetch_i
add wave -noupdate -expand -group {AXI MASTER READ DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_datapath/trans_len_i
add wave -noupdate -expand -group {AXI MASTER READ DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_datapath/desc_addr_i
add wave -noupdate -expand -group {AXI MASTER READ DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_datapath/desc_data_r
add wave -noupdate -expand -group {AXI MASTER READ DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_datapath/read_error_o
add wave -noupdate -expand -group {AXI MASTER READ DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_datapath/cpu_data_o
add wave -noupdate -expand -group {AXI MASTER READ DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_datapath/ar_addr_o
add wave -noupdate -expand -group {AXI MASTER READ DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_datapath/ar_len_o
add wave -noupdate -expand -group {AXI MASTER READ DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_datapath/ar_size_o
add wave -noupdate -expand -group {AXI MASTER READ DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_datapath/ar_burst_o
add wave -noupdate -expand -group {AXI MASTER READ DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_datapath/r_valid_i
add wave -noupdate -expand -group {AXI MASTER READ DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_datapath/r_data_i
add wave -noupdate -expand -group {AXI MASTER READ DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_datapath/r_resp_i
add wave -noupdate -expand -group {AXI MASTER READ DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_datapath/load_burst_cntr_i
add wave -noupdate -expand -group {AXI MASTER READ DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_datapath/load_beat_cntr_i
add wave -noupdate -expand -group {AXI MASTER READ DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_datapath/beat_count_en_i
add wave -noupdate -expand -group {AXI MASTER READ DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_datapath/burst_count_en_i
add wave -noupdate -expand -group {AXI MASTER READ DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_datapath/r_ready_i
add wave -noupdate -expand -group {AXI MASTER READ DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_datapath/beat_sel_i
add wave -noupdate -expand -group {AXI MASTER READ DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_datapath/burst_sel_i
add wave -noupdate -expand -group {AXI MASTER READ DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_datapath/load_beats_reg_i
add wave -noupdate -expand -group {AXI MASTER READ DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_datapath/ld_desc_addr_i
add wave -noupdate -expand -group {AXI MASTER READ DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_datapath/ar_addr_sel_i
add wave -noupdate -expand -group {AXI MASTER READ DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_datapath/ar_len_sel_i
add wave -noupdate -expand -group {AXI MASTER READ DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_datapath/sample_en_i
add wave -noupdate -expand -group {AXI MASTER READ DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_datapath/desc_count_en_i
add wave -noupdate -expand -group {AXI MASTER READ DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_datapath/ld_desc_data_r_i
add wave -noupdate -expand -group {AXI MASTER READ DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_datapath/ld_src_addr_i
add wave -noupdate -expand -group {AXI MASTER READ DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_datapath/ld_trans_len_i
add wave -noupdate -expand -group {AXI MASTER READ DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_datapath/nxt_addr_sel_i
add wave -noupdate -expand -group {AXI MASTER READ DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_datapath/route_zeros_i
add wave -noupdate -expand -group {AXI MASTER READ DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_datapath/latch_remain_burst_done_flag_i
add wave -noupdate -expand -group {AXI MASTER READ DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_datapath/ld_cpu_data_i
add wave -noupdate -expand -group {AXI MASTER READ DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_datapath/burst_done_o
add wave -noupdate -expand -group {AXI MASTER READ DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_datapath/beat_done_o
add wave -noupdate -expand -group {AXI MASTER READ DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_datapath/err_o
add wave -noupdate -expand -group {AXI MASTER READ DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_datapath/remaining_beats_zero_o
add wave -noupdate -expand -group {AXI MASTER READ DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_datapath/desc_count_done_o
add wave -noupdate -expand -group {AXI MASTER READ DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_datapath/remain_burst_done_flag_r
add wave -noupdate -expand -group {AXI MASTER READ DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_datapath/err_flag_r
add wave -noupdate -expand -group {AXI MASTER READ DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_datapath/fifo_data_o
add wave -noupdate -expand -group {AXI MASTER READ DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_datapath/src_addr_r
add wave -noupdate -expand -group {AXI MASTER READ DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_datapath/desc_addr_r
add wave -noupdate -expand -group {AXI MASTER READ DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_datapath/src_addr_aligned
add wave -noupdate -expand -group {AXI MASTER READ DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_datapath/src_addr_mux_o
add wave -noupdate -expand -group {AXI MASTER READ DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_datapath/src_addr_nxt_burst
add wave -noupdate -expand -group {AXI MASTER READ DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_datapath/r_data_mux_o
add wave -noupdate -expand -group {AXI MASTER READ DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_datapath/cpu_data_read_r
add wave -noupdate -expand -group {AXI MASTER READ DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_datapath/trans_len_r
add wave -noupdate -expand -group {AXI MASTER READ DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_datapath/sample_reg_data_o
add wave -noupdate -expand -group {AXI MASTER READ DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_datapath/total_beats
add wave -noupdate -expand -group {AXI MASTER READ DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_datapath/no_bursts
add wave -noupdate -expand -group {AXI MASTER READ DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_datapath/no_bursts_selected
add wave -noupdate -expand -group {AXI MASTER READ DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_datapath/no_beats
add wave -noupdate -expand -group {AXI MASTER READ DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_datapath/remaining_beats
add wave -noupdate -expand -group {AXI MASTER READ DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_datapath/beat_cntr_data_i
add wave -noupdate -expand -group {AXI MASTER READ DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_datapath/no_beats_r
add wave -noupdate -expand -group {AXI MASTER READ CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_ctrl/clk
add wave -noupdate -expand -group {AXI MASTER READ CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_ctrl/rst_n
add wave -noupdate -expand -group {AXI MASTER READ CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_ctrl/burst_done_i
add wave -noupdate -expand -group {AXI MASTER READ CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_ctrl/beat_done_i
add wave -noupdate -expand -group {AXI MASTER READ CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_ctrl/err_i
add wave -noupdate -expand -group {AXI MASTER READ CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_ctrl/remaining_beats_zero_i
add wave -noupdate -expand -group {AXI MASTER READ CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_ctrl/desc_count_done_i
add wave -noupdate -expand -group {AXI MASTER READ CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_ctrl/remain_burst_done_flag_i
add wave -noupdate -expand -group {AXI MASTER READ CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_ctrl/err_flag_i
add wave -noupdate -expand -group {AXI MASTER READ CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_ctrl/load_burst_cntr_o
add wave -noupdate -expand -group {AXI MASTER READ CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_ctrl/load_beat_cntr_o
add wave -noupdate -expand -group {AXI MASTER READ CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_ctrl/beat_sel_o
add wave -noupdate -expand -group {AXI MASTER READ CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_ctrl/beat_count_en_o
add wave -noupdate -expand -group {AXI MASTER READ CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_ctrl/load_beat_reg_o
add wave -noupdate -expand -group {AXI MASTER READ CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_ctrl/ld_desc_addr_o
add wave -noupdate -expand -group {AXI MASTER READ CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_ctrl/ar_addr_sel_o
add wave -noupdate -expand -group {AXI MASTER READ CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_ctrl/ar_len_sel_o
add wave -noupdate -expand -group {AXI MASTER READ CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_ctrl/burst_count_en_o
add wave -noupdate -expand -group {AXI MASTER READ CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_ctrl/burst_sel_o
add wave -noupdate -expand -group {AXI MASTER READ CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_ctrl/sample_en_o
add wave -noupdate -expand -group {AXI MASTER READ CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_ctrl/desc_count_en_o
add wave -noupdate -expand -group {AXI MASTER READ CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_ctrl/ld_desc_data_r_o
add wave -noupdate -expand -group {AXI MASTER READ CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_ctrl/ld_src_addr_o
add wave -noupdate -expand -group {AXI MASTER READ CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_ctrl/ld_trans_len_o
add wave -noupdate -expand -group {AXI MASTER READ CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_ctrl/nxt_addr_sel_o
add wave -noupdate -expand -group {AXI MASTER READ CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_ctrl/route_zeros_o
add wave -noupdate -expand -group {AXI MASTER READ CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_ctrl/latch_remain_burst_done_flag_o
add wave -noupdate -expand -group {AXI MASTER READ CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_ctrl/ld_cpu_data_o
add wave -noupdate -expand -group {AXI MASTER READ CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_ctrl/start_read_i
add wave -noupdate -expand -group {AXI MASTER READ CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_ctrl/desc_fetch_i
add wave -noupdate -expand -group {AXI MASTER READ CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_ctrl/cpu_op_i
add wave -noupdate -expand -group {AXI MASTER READ CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_ctrl/read_done_o
add wave -noupdate -expand -group {AXI MASTER READ CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_ctrl/rd_master_idle_o
add wave -noupdate -expand -group {AXI MASTER READ CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_ctrl/data_valid_o
add wave -noupdate -expand -group {AXI MASTER READ CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_ctrl/ar_ready_i
add wave -noupdate -expand -group {AXI MASTER READ CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_ctrl/r_valid_i
add wave -noupdate -expand -group {AXI MASTER READ CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_ctrl/r_last_i
add wave -noupdate -expand -group {AXI MASTER READ CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_ctrl/ar_valid_o
add wave -noupdate -expand -group {AXI MASTER READ CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_ctrl/r_ready_o
add wave -noupdate -expand -group {AXI MASTER READ CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_ctrl/fifo_full_i
add wave -noupdate -expand -group {AXI MASTER READ CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_ctrl/fifo_wr_en_o
add wave -noupdate -expand -group {AXI MASTER READ CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_ctrl/rst_rd_fifo_o
add wave -noupdate -expand -group {AXI MASTER READ CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_ctrl/c_state
add wave -noupdate -expand -group {AXI MASTER READ CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_ctrl/n_state
add wave -noupdate -group {BEAT COUNTER} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_datapath/beat_cnt/clk
add wave -noupdate -group {BEAT COUNTER} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_datapath/beat_cnt/rst_n
add wave -noupdate -group {BEAT COUNTER} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_datapath/beat_cnt/load
add wave -noupdate -group {BEAT COUNTER} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_datapath/beat_cnt/total_beats
add wave -noupdate -group {BEAT COUNTER} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_datapath/beat_cnt/count_en
add wave -noupdate -group {BEAT COUNTER} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_datapath/beat_cnt/beat_done
add wave -noupdate -group {BEAT COUNTER} /tb_top/dma_dut/axi_master_top_inst/axi_master_rd_top_inst/rd_datapath/beat_cnt/cnt
add wave -noupdate -group {AXI MASTER WRITE TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/clk
add wave -noupdate -group {AXI MASTER WRITE TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/rst_n
add wave -noupdate -group {AXI MASTER WRITE TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_master_idle_o
add wave -noupdate -group {AXI MASTER WRITE TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_done_o
add wave -noupdate -group {AXI MASTER WRITE TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_error_o
add wave -noupdate -group {AXI MASTER WRITE TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/dest_addr_i
add wave -noupdate -group {AXI MASTER WRITE TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/start_write_i
add wave -noupdate -group {AXI MASTER WRITE TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/transfer_len_i
add wave -noupdate -group {AXI MASTER WRITE TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/c_data_i
add wave -noupdate -group {AXI MASTER WRITE TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/cpu_op_i
add wave -noupdate -group {AXI MASTER WRITE TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/aw_valid_o
add wave -noupdate -group {AXI MASTER WRITE TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/aw_addr_o
add wave -noupdate -group {AXI MASTER WRITE TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/aw_len_o
add wave -noupdate -group {AXI MASTER WRITE TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/aw_size_o
add wave -noupdate -group {AXI MASTER WRITE TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/aw_burst_o
add wave -noupdate -group {AXI MASTER WRITE TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/aw_ready_i
add wave -noupdate -group {AXI MASTER WRITE TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/w_valid_o
add wave -noupdate -group {AXI MASTER WRITE TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/w_data_o
add wave -noupdate -group {AXI MASTER WRITE TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/w_ready_i
add wave -noupdate -group {AXI MASTER WRITE TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/b_ready_o
add wave -noupdate -group {AXI MASTER WRITE TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/b_valid_i
add wave -noupdate -group {AXI MASTER WRITE TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/b_resp_i
add wave -noupdate -group {AXI MASTER WRITE TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/fifo_empty_i
add wave -noupdate -group {AXI MASTER WRITE TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/fifo_data_i
add wave -noupdate -group {AXI MASTER WRITE TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/fifo_rd_en_o
add wave -noupdate -group {AXI MASTER WRITE TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/rst_wr_fifo_o
add wave -noupdate -group {AXI MASTER WRITE TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/ld_dest_addr
add wave -noupdate -group {AXI MASTER WRITE TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/ld_trans_len
add wave -noupdate -group {AXI MASTER WRITE TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/nxt_addr_sel
add wave -noupdate -group {AXI MASTER WRITE TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/ld_burst_cntr
add wave -noupdate -group {AXI MASTER WRITE TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/burst_count_en
add wave -noupdate -group {AXI MASTER WRITE TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/burst_sel
add wave -noupdate -group {AXI MASTER WRITE TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/ld_beat_cntr
add wave -noupdate -group {AXI MASTER WRITE TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/beat_count_en
add wave -noupdate -group {AXI MASTER WRITE TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/beat_sel
add wave -noupdate -group {AXI MASTER WRITE TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/ld_beats_reg
add wave -noupdate -group {AXI MASTER WRITE TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/ld_cur_addr
add wave -noupdate -group {AXI MASTER WRITE TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/cur_addr_sel
add wave -noupdate -group {AXI MASTER WRITE TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/rem_bytes_sel
add wave -noupdate -group {AXI MASTER WRITE TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/ld_rem_bytes
add wave -noupdate -group {AXI MASTER WRITE TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/is_first_beat
add wave -noupdate -group {AXI MASTER WRITE TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/beat_done
add wave -noupdate -group {AXI MASTER WRITE TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/burst_done
add wave -noupdate -group {AXI MASTER WRITE TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/str_resp
add wave -noupdate -group {AXI MASTER WRITE TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/err
add wave -noupdate -group {AXI MASTER WRITE TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/rst_beat_flag
add wave -noupdate -group {AXI MASTER WRITE TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/set_beat_flag
add wave -noupdate -group {AXI MASTER WRITE TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/remaining_beats_zero
add wave -noupdate -group {AXI MASTER WRITE TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/not_first_beat_flag
add wave -noupdate -group {AXI MASTER WRITE TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/set_wr_error
add wave -noupdate -group {AXI MASTER WRITE TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/remain_burst_done_flag
add wave -noupdate -group {AXI MASTER WRITE TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/latch_remain_burst_done_flag
add wave -noupdate -group {AXI MASTER WRITE TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/rst_wr_error
add wave -noupdate -group {AXI MASTER WRITE TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/ld_cpu_data
add wave -noupdate -group {AXI MASTER WRITE TOP} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/sel_cpu_data
add wave -noupdate -expand -group {AXI MASTER WRITE DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_datapath/clk
add wave -noupdate -expand -group {AXI MASTER WRITE DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_datapath/rst_n
add wave -noupdate -expand -group {AXI MASTER WRITE DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_datapath/dest_addr_i
add wave -noupdate -expand -group {AXI MASTER WRITE DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_datapath/trans_len_i
add wave -noupdate -expand -group {AXI MASTER WRITE DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_datapath/c_data_i
add wave -noupdate -expand -group {AXI MASTER WRITE DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_datapath/write_start_i
add wave -noupdate -expand -group {AXI MASTER WRITE DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_datapath/wr_error_o
add wave -noupdate -expand -group {AXI MASTER WRITE DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_datapath/ld_dest_addr_i
add wave -noupdate -expand -group {AXI MASTER WRITE DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_datapath/ld_trans_len_i
add wave -noupdate -expand -group {AXI MASTER WRITE DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_datapath/nxt_addr_sel_i
add wave -noupdate -expand -group {AXI MASTER WRITE DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_datapath/ld_burst_cntr_i
add wave -noupdate -expand -group {AXI MASTER WRITE DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_datapath/burst_count_en_i
add wave -noupdate -expand -group {AXI MASTER WRITE DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_datapath/burst_sel_i
add wave -noupdate -expand -group {AXI MASTER WRITE DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_datapath/ld_beat_cntr_i
add wave -noupdate -expand -group {AXI MASTER WRITE DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_datapath/beat_count_en_i
add wave -noupdate -expand -group {AXI MASTER WRITE DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_datapath/beat_sel_i
add wave -noupdate -expand -group {AXI MASTER WRITE DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_datapath/ld_beats_reg_i
add wave -noupdate -expand -group {AXI MASTER WRITE DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_datapath/ld_cur_addr_i
add wave -noupdate -expand -group {AXI MASTER WRITE DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_datapath/cur_addr_sel_i
add wave -noupdate -expand -group {AXI MASTER WRITE DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_datapath/rem_bytes_sel_i
add wave -noupdate -expand -group {AXI MASTER WRITE DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_datapath/ld_rem_bytes_i
add wave -noupdate -expand -group {AXI MASTER WRITE DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_datapath/is_first_beat_i
add wave -noupdate -expand -group {AXI MASTER WRITE DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_datapath/str_resp_i
add wave -noupdate -expand -group {AXI MASTER WRITE DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_datapath/rst_beat_flag_i
add wave -noupdate -expand -group {AXI MASTER WRITE DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_datapath/set_beat_flag_i
add wave -noupdate -expand -group {AXI MASTER WRITE DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_datapath/set_wr_error_i
add wave -noupdate -expand -group {AXI MASTER WRITE DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_datapath/latch_remain_burst_done_flag_i
add wave -noupdate -expand -group {AXI MASTER WRITE DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_datapath/ld_cpu_data_i
add wave -noupdate -expand -group {AXI MASTER WRITE DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_datapath/sel_cpu_data_i
add wave -noupdate -expand -group {AXI MASTER WRITE DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_datapath/burst_done_o
add wave -noupdate -expand -group {AXI MASTER WRITE DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_datapath/beat_done_o
add wave -noupdate -expand -group {AXI MASTER WRITE DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_datapath/err_o
add wave -noupdate -expand -group {AXI MASTER WRITE DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_datapath/not_first_beat_flag_o
add wave -noupdate -expand -group {AXI MASTER WRITE DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_datapath/remaining_beats_zero_o
add wave -noupdate -expand -group {AXI MASTER WRITE DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_datapath/remain_burst_done_flag_r
add wave -noupdate -expand -group {AXI MASTER WRITE DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_datapath/aw_addr_o
add wave -noupdate -expand -group {AXI MASTER WRITE DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_datapath/aw_len_o
add wave -noupdate -expand -group {AXI MASTER WRITE DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_datapath/aw_size_o
add wave -noupdate -expand -group {AXI MASTER WRITE DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_datapath/aw_burst_o
add wave -noupdate -expand -group {AXI MASTER WRITE DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_datapath/w_strb_o
add wave -noupdate -expand -group {AXI MASTER WRITE DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_datapath/w_data_o
add wave -noupdate -expand -group {AXI MASTER WRITE DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_datapath/b_resp_i
add wave -noupdate -expand -group {AXI MASTER WRITE DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_datapath/fifo_data_i
add wave -noupdate -expand -group {AXI MASTER WRITE DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_datapath/dest_addr_r
add wave -noupdate -expand -group {AXI MASTER WRITE DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_datapath/dest_addr_aligned
add wave -noupdate -expand -group {AXI MASTER WRITE DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_datapath/dest_addr_nxt_burst
add wave -noupdate -expand -group {AXI MASTER WRITE DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_datapath/selected_addr
add wave -noupdate -expand -group {AXI MASTER WRITE DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_datapath/w_data_sel
add wave -noupdate -expand -group {AXI MASTER WRITE DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_datapath/c_data_r
add wave -noupdate -expand -group {AXI MASTER WRITE DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_datapath/trans_len_r
add wave -noupdate -expand -group {AXI MASTER WRITE DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_datapath/cur_addr_r
add wave -noupdate -expand -group {AXI MASTER WRITE DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_datapath/cur_addr_selected
add wave -noupdate -expand -group {AXI MASTER WRITE DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_datapath/rem_bytes_r
add wave -noupdate -expand -group {AXI MASTER WRITE DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_datapath/rem_bytes_selected
add wave -noupdate -expand -group {AXI MASTER WRITE DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_datapath/addr_offset
add wave -noupdate -expand -group {AXI MASTER WRITE DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_datapath/valid_bytes_this_cycle
add wave -noupdate -expand -group {AXI MASTER WRITE DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_datapath/wstrb
add wave -noupdate -expand -group {AXI MASTER WRITE DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_datapath/strb_written
add wave -noupdate -expand -group {AXI MASTER WRITE DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_datapath/b_resp_r
add wave -noupdate -expand -group {AXI MASTER WRITE DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_datapath/wr_error_r
add wave -noupdate -expand -group {AXI MASTER WRITE DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_datapath/total_beats
add wave -noupdate -expand -group {AXI MASTER WRITE DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_datapath/no_bursts
add wave -noupdate -expand -group {AXI MASTER WRITE DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_datapath/no_bursts_selected
add wave -noupdate -expand -group {AXI MASTER WRITE DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_datapath/no_beats
add wave -noupdate -expand -group {AXI MASTER WRITE DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_datapath/remaining_beats
add wave -noupdate -expand -group {AXI MASTER WRITE DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_datapath/beat_cntr_data_i
add wave -noupdate -expand -group {AXI MASTER WRITE DATAPATH} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_datapath/no_beats_r
add wave -noupdate -expand -group {AXI MASTER WRITE CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_ctrl/clk
add wave -noupdate -expand -group {AXI MASTER WRITE CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_ctrl/rst_n
add wave -noupdate -expand -group {AXI MASTER WRITE CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_ctrl/start_write_i
add wave -noupdate -expand -group {AXI MASTER WRITE CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_ctrl/cpu_op_i
add wave -noupdate -expand -group {AXI MASTER WRITE CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_ctrl/wr_master_idle_o
add wave -noupdate -expand -group {AXI MASTER WRITE CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_ctrl/wr_done_o
add wave -noupdate -expand -group {AXI MASTER WRITE CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_ctrl/beat_done_i
add wave -noupdate -expand -group {AXI MASTER WRITE CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_ctrl/burst_done_i
add wave -noupdate -expand -group {AXI MASTER WRITE CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_ctrl/err_i
add wave -noupdate -expand -group {AXI MASTER WRITE CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_ctrl/not_first_beat_flag_i
add wave -noupdate -expand -group {AXI MASTER WRITE CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_ctrl/remaining_beats_zero_i
add wave -noupdate -expand -group {AXI MASTER WRITE CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_ctrl/remain_burst_done_flag_i
add wave -noupdate -expand -group {AXI MASTER WRITE CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_ctrl/ld_dest_addr_o
add wave -noupdate -expand -group {AXI MASTER WRITE CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_ctrl/ld_trans_len_o
add wave -noupdate -expand -group {AXI MASTER WRITE CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_ctrl/nxt_addr_sel_o
add wave -noupdate -expand -group {AXI MASTER WRITE CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_ctrl/ld_burst_cntr_o
add wave -noupdate -expand -group {AXI MASTER WRITE CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_ctrl/burst_count_en_o
add wave -noupdate -expand -group {AXI MASTER WRITE CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_ctrl/burst_sel_o
add wave -noupdate -expand -group {AXI MASTER WRITE CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_ctrl/ld_beat_cntr_o
add wave -noupdate -expand -group {AXI MASTER WRITE CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_ctrl/beat_count_en_o
add wave -noupdate -expand -group {AXI MASTER WRITE CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_ctrl/beat_sel_o
add wave -noupdate -expand -group {AXI MASTER WRITE CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_ctrl/ld_beats_reg_o
add wave -noupdate -expand -group {AXI MASTER WRITE CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_ctrl/ld_cur_addr_o
add wave -noupdate -expand -group {AXI MASTER WRITE CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_ctrl/cur_addr_sel_o
add wave -noupdate -expand -group {AXI MASTER WRITE CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_ctrl/rem_bytes_sel_o
add wave -noupdate -expand -group {AXI MASTER WRITE CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_ctrl/ld_rem_bytes_o
add wave -noupdate -expand -group {AXI MASTER WRITE CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_ctrl/is_first_beat_o
add wave -noupdate -expand -group {AXI MASTER WRITE CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_ctrl/str_resp_o
add wave -noupdate -expand -group {AXI MASTER WRITE CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_ctrl/rst_beat_flag_o
add wave -noupdate -expand -group {AXI MASTER WRITE CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_ctrl/set_beat_flag_o
add wave -noupdate -expand -group {AXI MASTER WRITE CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_ctrl/latch_remain_burst_done_flag_o
add wave -noupdate -expand -group {AXI MASTER WRITE CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_ctrl/set_wr_error_o
add wave -noupdate -expand -group {AXI MASTER WRITE CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_ctrl/ld_cpu_data_o
add wave -noupdate -expand -group {AXI MASTER WRITE CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_ctrl/sel_cpu_data_o
add wave -noupdate -expand -group {AXI MASTER WRITE CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_ctrl/aw_valid_o
add wave -noupdate -expand -group {AXI MASTER WRITE CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_ctrl/aw_ready_i
add wave -noupdate -expand -group {AXI MASTER WRITE CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_ctrl/w_valid_o
add wave -noupdate -expand -group {AXI MASTER WRITE CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_ctrl/w_ready_i
add wave -noupdate -expand -group {AXI MASTER WRITE CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_ctrl/b_valid_i
add wave -noupdate -expand -group {AXI MASTER WRITE CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_ctrl/b_ready_o
add wave -noupdate -expand -group {AXI MASTER WRITE CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_ctrl/fifo_empty_i
add wave -noupdate -expand -group {AXI MASTER WRITE CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_ctrl/fifo_rd_en_o
add wave -noupdate -expand -group {AXI MASTER WRITE CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_ctrl/rst_wr_fifo_o
add wave -noupdate -expand -group {AXI MASTER WRITE CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_ctrl/c_state
add wave -noupdate -expand -group {AXI MASTER WRITE CONTROLLER} /tb_top/dma_dut/axi_master_top_inst/axi_master_wr_top_inst/wr_ctrl/n_state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {175 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 530
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {614 ns}
