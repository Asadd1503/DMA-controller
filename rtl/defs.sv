package defs;

    localparam MAX_BEATS            = 256; // Maximum beats per burst (for AXI4, this is typically 256)
    localparam ADDR_W               = 32;     // Address width
    localparam DATA_W               = 32;     // Data width
    localparam ARSIZE_SIZE          = 3;
    localparam ARBURST_SIZE         = 2;
    localparam [2:0] ARSIZE_4BYTES  = 3'b010; // ARSIZE encoding for 4 bytes (32 bits);
    localparam ARSIZE_IN_BYTES      = (1<<(ARSIZE_4BYTES));
    localparam LOG2_MAX_BEATS       = $clog2(MAX_BEATS);
    localparam MASK_FOR_REMAINDER   = 32'hFF; // SELECTED BASED ON MAX_BEATS, FOR DIFFERENT MAX_BEATS, THIS MASK SHOULD BE UPDATED ACCORDINGLY
    localparam MAX_ALLOWED_BURSTS   = 4;      // This is an arbitrary limit to prevent excessive bursting, can be adjusted based on requirements;
    localparam [1:0]ARBURST_INCR    = 2'b01;          // AXI4 burst type for incrementing address;
    localparam DESC_LEN             = 16;               // 16 Bytes
    localparam DESC_NO_TRANSFERS    = DESC_LEN >> ARSIZE_4BYTES; // 16 bytes / 4 bytes = 4 
    localparam [2:0] AWSIZE_4BYTES  = 3'b010; // AWSIZE encoding for 4 bytes (32 bits);
    localparam AWSIZE_IN_BYTES      = (1<<(AWSIZE_4BYTES));
    localparam [1:0] BURST_INCR     = 2'b01;
    
    
    
endpackage