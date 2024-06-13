module LFSR_1_tb();
  
  parameter CLK_P =100;
  parameter TEST_CASES =10;
  
  //############################
  
  reg [7:0] DATA_tb ;
  reg ACTIVE_tb ;
  reg CLK_tb , RST_tb;
  wire CRC_OUT_tb;
  wire Valid_tb; 
  reg [7:0] Expec_Out_tb [TEST_CASES -1:0] ;
  reg [7:0] DATA_h_tb [TEST_CASES -1:0] ;
  integer operation ;
  
//###############################################
  
  CRC DUT (
  .DATA(DATA_tb),
  .ACTIVE(ACTIVE_tb),
  .CLK(CLK_tb),
  .RST(RST_tb),
  .CRC_OUT(CRC_OUT_tb),
  .Valid(Valid_tb)
  );
  
//######################################
  
  always #(CLK_P/2) CLK_tb = ~CLK_tb;
  
//######################################
initial 
begin
     $dumpfile("LFSR_1_tb.vcd");
     $dumpvars;
     $readmemh("DATA_h.txt" , DATA_h_tb );
     $readmemh("Expec_Out_h.txt" , Expec_Out_tb);
     initialize() ; 
     for (operation=0;operation<10;operation=operation+1)
     begin
          do_operation(DATA_h_tb[operation]); // take 130ns
          check_out(Expec_Out_tb[operation] , operation); // 90ns
     end
     $finish;
end
//######################################
  
  task REST ; // take 20ns
    begin
         RST_tb = 1'b0;
         #(CLK_P)
         RST_tb = 1'b1;
    end
  endtask
  
//*************************
  
  task initialize ;
    begin
         CLK_tb    = 1'b0;
         ACTIVE_tb = 1'b1;
         RST_tb    = 1'b0;
    end
   endtask
   
 //***********************
   
   task do_operation ;
     input [7:0] DATA_IN;
     integer y ;
     begin
          #(CLK_P) ;
          REST();
          ACTIVE_tb =1'b1;
          for (y=0 ; y<8 ;  y=y+1)
          begin
          DATA_tb =DATA_IN[y];
          #(CLK_P) ;
          end
      end
   endtask
   
//***************************  
 
  task check_out;
    input [7:0] Expec_Out ;
    input integer oper_num;
    integer x;
    reg [7:0] GENER_OUT;
    begin
         ACTIVE_tb =1'b0;
         @(posedge Valid_tb)
         for (x=0;x<8;x=x+1)
         begin
         #(CLK_P)
         GENER_OUT [x] = CRC_OUT_tb;
         end
         if(GENER_OUT==Expec_Out)
           $display("Test Case %d is succeeded",oper_num);
         else
           $display("Test Case %d is failed", oper_num);
    end
  endtask
endmodule
  