
module axi4_lite_slave # (
    parameter int N = 4
)( 
    axi4_lite_if.slave  axi_if,

     // internal bus to register_file
    output logic [$clog2(1+N+N)-1:0]  reg_index_o,
    output logic [31:0]                wdata_o,
    output logic [3:0]                 wstrb_o,
    output logic                       wen_o,
    output logic                       ren_o,
    input  logic [31:0]                rdata_i

);

   localparam int REG_COUNT   = 1 + N + N;
    localparam int WORD_BYTES  = 4;      // bytes per register (32-bit)
    localparam int ADDR_LSB    = 2;      // log2(WORD_BYTES)
    localparam logic [31:0] BASE_ADDR = 32'h0000_0000;

    localparam logic [1:0] RESP_OKAY  = 2'b00;
    localparam logic [1:0] RESP_SLVERR = 2'b10;

    
    
 // address decode signals
    logic [$clog2(REG_COUNT)-1:0] write_addr_index, read_addr_index;
    logic                          addr_valid_write,  addr_valid_read;
    logic [31:0]                   aw_offset,         ar_offset;
    logic                          aw_aligned,        ar_aligned;
    logic                          aw_in_range,       ar_in_range;

    
// to remove reg_index_o error
   // logic [$clog2(REG_COUNT)-1:0] reg_index_w;
   // logic [$clog2(REG_COUNT)-1:0] reg_index_r;

    // Address decode - combinational
    always_comb begin
        // defaults
        aw_offset       = 32'h0;
        ar_offset      = 32'h0;
        aw_aligned     = 1'b0;
        ar_aligned     = 1'b0;
        aw_in_range    = 1'b0;
        ar_in_range    = 1'b0;
        write_addr_index = 'b0;
        read_addr_index  = 'b0;
        addr_valid_write = 1'b0;
        addr_valid_read  = 1'b0;

        // AW decode
        aw_offset = axi_if.awaddr - BASE_ADDR;
        aw_aligned = (axi_if.awaddr[1:0] == 2'b00);
        aw_in_range = (axi_if.awaddr >= BASE_ADDR) &&
                      (aw_offset < (REG_COUNT * WORD_BYTES));
        if (aw_in_range)
            write_addr_index = aw_offset >> ADDR_LSB; 

        // AR decode
        ar_offset   = axi_if.araddr - BASE_ADDR;
        ar_aligned  = (axi_if.araddr[1:0] == 2'b00);
        ar_in_range = (axi_if.araddr >= BASE_ADDR) &&
                      (ar_offset < (REG_COUNT * WORD_BYTES));
        if (ar_in_range)
            read_addr_index = ar_offset >> ADDR_LSB;

        addr_valid_write = aw_aligned && aw_in_range;
        addr_valid_read  = ar_aligned && ar_in_range;
    end

    // State machines for read and write channels

    

    


    typedef enum logic [1:0] {
        W_IDLE, W_ADDR,W_DATA, W_RESP
    } write_state_t;
    
    typedef enum logic [1:0] {
        R_IDLE, R_ADDR, R_DATA
    } read_state_t;
    
    write_state_t write_state;
    read_state_t  read_state;

    
    always_ff @(posedge axi_if.aclk or negedge axi_if.rst_n) begin
        if (!axi_if.rst_n) begin
            write_state    <= W_IDLE;
            axi_if.awready <= 1'b0;
            axi_if.wready  <= 1'b0;
            axi_if.bvalid  <= 1'b0;
            axi_if.bresp   <= RESP_OKAY;
          //  wen_o          <= 1'b0;
           // wdata_o        <= 32'h0;
           // wstrb_o        <= 4'h0;
          //  reg_index_w    <= '0;

        end else begin
            axi_if.awready <= 1'b0;
            axi_if.wready  <= 1'b0;
          //  wen_o          <= 1'b0;    // default: no write pulse

            case (write_state)
                W_IDLE: begin
                    axi_if.bvalid <= 1'b0;
                    if (axi_if.awvalid && !axi_if.bvalid) begin
                        axi_if.awready <= 1'b1;
                        write_state    <= W_ADDR;
                    end
                end

                W_ADDR: begin
                    axi_if.wready <= 1'b1;
                    if (axi_if.wvalid && axi_if.wready) begin
                        write_state <= W_DATA;
                    end
                end

                W_DATA: begin
                    if (addr_valid_write) begin
                        // fire the write pulse to register file
                      //  wen_o       <= 1'b1;
                      //  reg_index_w <= write_addr_index;
                      //  wdata_o     <= axi_if.wdata;
                      //  wstrb_o     <= axi_if.wstrb;
                        axi_if.bresp <= RESP_OKAY;
                    end else begin
                        axi_if.bresp <= RESP_SLVERR;
                    end
                    axi_if.wready <= 1'b0;
                    axi_if.bvalid <= 1'b1;
                    write_state   <= W_RESP;
                end

                W_RESP: begin
                    if (axi_if.bvalid && axi_if.bready) begin
                        axi_if.bvalid <= 1'b0;
                        write_state   <= W_IDLE;
                    end
                end

                default: write_state <= W_IDLE;
            endcase
        end
    end

    
    always_ff @(posedge axi_if.aclk or negedge axi_if.rst_n) begin
        if (!axi_if.rst_n) begin
            read_state     <= R_IDLE;
            axi_if.arready <= 1'b0;
            axi_if.rvalid  <= 1'b0;
            axi_if.rresp   <= RESP_OKAY;
            axi_if.rdata   <= 32'h0;
          //  reg_index_r    <= '0;
          //  ren_o          <= 1'b0;

        end else begin
            axi_if.arready <= 1'b0;
           // ren_o          <= 1'b0;    // default: no read pulse

            case (read_state)
                R_IDLE: begin
                    axi_if.rvalid <= 1'b0;
                    if (axi_if.arvalid && !axi_if.rvalid) begin
                        axi_if.arready <= 1'b1;
                        if (axi_if.arvalid && axi_if.arready) begin
                            read_state <= R_ADDR;
                        end
                    end
                end

                R_ADDR: begin
                    if (addr_valid_read) begin
                        // fire the read pulse to register file
                      //  ren_o          <= 1'b1;
                      //  reg_index_r    <= read_addr_index;
                        axi_if.rdata   <= rdata_i;
                        axi_if.rresp   <= RESP_OKAY;
                    end else begin
                        axi_if.rdata <= 32'hDEAD_BEEF;
                        axi_if.rresp <= RESP_SLVERR;
                    end
                    axi_if.rvalid <= 1'b1;
                    read_state    <= R_DATA;
                end

                R_DATA: begin
                    if (axi_if.rvalid && axi_if.rready) begin
                        axi_if.rvalid <= 1'b0;
                        read_state    <= R_IDLE;
                    end
                end

                default: read_state <= R_IDLE;
            endcase
        end
    end

    
 always_comb begin
    wen_o   = (write_state == W_DATA) && addr_valid_write;
    ren_o   = (read_state  == R_ADDR) && addr_valid_read;
    wdata_o = axi_if.wdata;   // always pass through — wen_o gates validity
    wstrb_o = axi_if.wstrb;   // always pass through — wen_o gates validity

    if      (wen_o) reg_index_o = write_addr_index;
    else if (ren_o) reg_index_o = read_addr_index;
    else            reg_index_o = '0;
end


        
    
endmodule
