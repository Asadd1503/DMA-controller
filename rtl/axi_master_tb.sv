import defs::*;

module axi_master_tb;
logic clk;
logic rst_n;
    // From Arbiter
logic [ADDR_W-1:0] src_addr_i;
logic              start_read_i;
logic [23:0]       transfer_len_i;
//logic [2:0]        burst_size_i,
logic              desc_fetch_i;
logic [ADDR_W-1:0] desc_addr_i;
//logic              ch_ready_i;
logic [ADDR_W-1:0] dest_addr_i;
logic              start_write_i;
logic              cpu_op_i;
logic [DATA_W-1:0] c_data_i;


    // To Arbiter
logic             read_done_o;
logic             rd_master_idle_o;
logic             read_error_o;
logic             data_valid_o;
logic [128-1:0]   desc_data_o;
logic             wr_master_idle_o;
logic             wr_done_o;
logic             wr_error_o;
    // READ Address Channel
logic              ar_ready_i;
 logic             ar_valid_o;
 logic [ADDR_W-1:0] ar_addr_o;
 logic [7:0]       ar_len_o;
 logic [2:0]       ar_size_o;
 logic [1:0]       ar_burst_o;
    // WRITE Address Channel
logic              aw_ready_i;
logic              aw_valid_o;
logic [ADDR_W-1:0] aw_addr_o;
logic [7:0]        aw_len_o;
logic [2:0]        aw_size_o;
logic [1:0]        aw_burst_o;
    // READ Data Channel
logic              r_valid_i;
logic [DATA_W-1:0] r_data_i;
logic              r_last_i;
logic [1:0]        r_resp_i;
 logic             r_ready_o;
    // WRITE DATA CHANNEL
logic              w_valid_o;
logic [DATA_W-1:0] w_data_o;
logic               w_ready_i;
    // WRITE RESPONSE CHANNEL
logic               b_valid_i;
logic [1:0]         b_resp_i;
 logic              b_ready_o;

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

axi_master_top dut (
    .clk(clk),
    .rst_n(rst_n),
    // From Arbiter
    .src_addr_i(src_addr_i),
    .start_read_i(start_read_i),
    .transfer_len_i(transfer_len_i),
    //.burst_size_i(burst_size_i),
    .desc_fetch_i(desc_fetch_i),
    .desc_addr_i(desc_addr_i),
    //.ch_ready_i(ch_ready_i),
    .dest_addr_i(dest_addr_i),
    .start_write_i(start_write_i),
    .cpu_op_i(cpu_op_i),
    .c_data_i(c_data_i),

    // To Arbiter
    .read_done_o(read_done_o),
    .rd_master_idle_o(rd_master_idle_o),
    .read_error_o(read_error_o),
    .data_valid_o(data_valid_o),
    .desc_data_o(desc_data_o),
    .wr_master_idle_o(wr_master_idle_o),
    .wr_done_o(wr_done_o),
    .wr_error_o(wr_error_o),
    // READ Address Channel
    .ar_ready_i(ar_ready_i),
    .ar_valid_o(ar_valid_o),
    .ar_addr_o(ar_addr_o),
    .ar_len_o(ar_len_o),
    .ar_size_o(ar_size_o),
    .ar_burst_o(ar_burst_o),
    // WRITE Address Channel
    .aw_ready_i(aw_ready_i),
    .aw_valid_o(aw_valid_o),
    .aw_addr_o(aw_addr_o),
    .aw_len_o(aw_len_o),
    .aw_size_o(aw_size_o),
    .aw_burst_o(aw_burst_o),
    // READ Data Channel
    .r_valid_i(r_valid_i),
    .r_data_i(r_data_i),
    .r_last_i(r_last_i),
    .r_resp_i(r_resp_i),
    .r_ready_o(r_ready_o),
    // WRITE DATA CHANNEL
    .w_valid_o(w_valid_o),
    .w_data_o(w_data_o),
    .w_ready_i(w_ready_i),
     // WRITE RESPONSE CHANNEL
     .b_valid_i(b_valid_i),
     .b_resp_i(b_resp_i),
     .b_ready_o(b_ready_o)
);


//------------ Driver --------------------
initial begin
    int r_data_array[];
    rst_n =          0;
    src_addr_i =    '0;
    start_read_i =   0;
    transfer_len_i = '0;
    desc_fetch_i =    0;
    desc_addr_i =    '0;
    //ch_ready_i =    0;
    dest_addr_i =    '0;
    start_write_i =  0;
    cpu_op_i       = 0;
    c_data_i        = '0;
    @(posedge clk);

    #2;
    rst_n = 1;
    //--------- 6 beat read transaction -------------
    @(posedge clk);
    #3;
    src_addr_i     = 32'h0000_0004;
    transfer_len_i = 24'd6;
    start_read_i   = 1;                 // Start the read transaction
    @(posedge clk);
    start_read_i   = 0;                 // Deassert start after one cycle
    wait(ar_valid_o);
    ar_ready_i = 1;                     // simulate slave ready to accept address
    wait(r_ready_o);
    ar_ready_i      = 0;                // drive slave ready low
    r_valid_i       = 1;                // simulate read data valid 
    r_data_i        = 32'hDEAD_BEEF;    // simulate read data
    @(posedge clk);                     // next beat and also the last
    r_last_i        = 1;
    r_data_i        = 32'hCAFEBABE;     // simulate read data
    wait(rd_master_idle_o);           // wait for read transaction to complete
    //-------------------------------------------------
    $display("[ %0t ] READ TRANSACTION 6 BEAT TEST COMPLETED", $time);
    //----------- DESC fetch transaction -------------
    /*
    @(posedge clk);
    #3;
    desc_fetch_i        = 1;                 // Start the desc fetch transaction
    desc_addr_i         = 32'h0000_AAAA;    // Provide the desc address
    wait(ar_valid_o);
    ar_ready_i          = 1; 
    wait(r_ready_o);
    ar_ready_i          = 0;  
    r_data_array = new[DESC_NO_TRANSFERS];
    r_data_array = '{32'h1111_1111, 32'h2222_2222, 32'h3333_3333, 32'h4444_4444}; 
    for (int i = 0; i < DESC_NO_TRANSFERS; i++) begin
        r_valid_i           = 1;                                    
        r_data_i            = r_data_array[i];    
        r_resp_i            = 2'b00;           
        @(posedge clk);     //--> 1 beat done
    end 
    wait(data_valid_o);
    ch_ready_i              = 1;            // Simulate channel ready to accept desc data
    wait(rd_master_idle_o);
    $display("DESC FETCH TRANSACTION COMPLETED");
    //------------------------------------------------
    */
    /* 6 beat write transaction */
    @(posedge clk);
    #3;
    dest_addr_i        = 32'hBBBB_AAAA;
    transfer_len_i     = 24'd6;
    start_write_i      = 1; 
    @(posedge clk);
    start_write_i      = 0;
    wait(aw_valid_o);
    aw_ready_i         = 1;
    wait(w_valid_o);
    w_ready_i         = 1;         
    @(posedge clk);          // 1st beat done
    w_ready_i         = 1;
    @(posedge clk);          // 2nd beat done
    wait(b_ready_o);
    b_valid_i         = 1;
    b_resp_i          = 2'b00; // OKAY response 
    wait(wr_master_idle_o);
    $display("[ %0t ] WRITE TRANSACTION 6 BEAT TEST COMPLETED", $time);
    

    $stop;
end

endmodule