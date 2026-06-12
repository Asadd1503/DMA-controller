

import dma_pkg::enviroment;
module dma_tb(dma_interface dma_if);
   
   initial begin
      enviroment env;
      env = new(dma_if);      
      env.run();
      $stop;
   end


endmodule