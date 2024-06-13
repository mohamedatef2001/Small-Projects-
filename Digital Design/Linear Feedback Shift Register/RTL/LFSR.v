module LFSR (
  input wire clk , rst , enable_in , enable_out ,
  input wire [7:0] seed  ,
  output reg out , valid 
  );
  
  integer i;
  parameter [7:0] taps = 8'b10101010; 
  reg [7:0] lfsr;
  wire bits0_6 , feedback;
  assign bits0_6 = ~|lfsr[6:0];
  assign feedback =bits0_6 ^ lfsr[7];
 /*------------------------------------------------
 -------------------------------------------------- 
 */
  always @(posedge clk or negedge rst)
  begin
    if (!rst)
      begin
        lfsr <= seed ;
        valid <= 1'b0;
        out <= 1'b0;
      end
//#########################################      
    else if (enable_in)
      begin
        lfsr[0] <= feedback ;
        for(i=7;i>=1;i=i-1)
        if (taps[i]==0)
          lfsr[i]<=lfsr[i-1];
        else
          lfsr[i] <= lfsr[i-1] ^feedback;
      end
//##########################################      
    else if (enable_out)
      begin
        valid <= 1'b1;
        {lfsr[6:0] , out } <= lfsr;
      end
 //########################################3
    end
  endmodule
      
      
      
      
                
      