module Automatic_Garag_Door_Controller_tb ();
  
reg UP_Max_tb ;
reg DN_MAX_tb ;
reg Activate_tb ;
reg CLK_tb ;
reg RST_tb ;
wire UP_M_tb ;
wire DN_M_tb ;

Automatic_Garag_Door_Controller DUT (
.UP_Max(UP_Max_tb),
.DN_MAX(DN_MAX_tb),
.Activate(Activate_tb),
.CLK(CLK_tb),
.RST(RST_tb),
.UP_M(UP_M_tb),
.DN_M(DN_M_tb)
);

always #10 CLK_tb = ~CLK_tb ;

initial 
begin
  $dumpfile("Automatic_Garag_Door_Controller_tb.vcd");
  $dumpvars;
  RST_tb = 1'b1;
  CLK_tb = 1'b0;
  Activate_tb = 1'b0;
  UP_Max_tb = 1'b0;
  DN_MAX_tb = 1'b0;
  //#################################3
  $display (" test 1 ");
  #30
   if (!UP_M_tb && !DN_M_tb)
     $display (" test IDLE pass ");
   else
     $display (" test IDLE filed ");
 //######################################
 $display (" test 2 ");
 #10
 Activate_tb = 1'b1;
 DN_MAX_tb = 1'b1;
 #11
 if (UP_M_tb && !DN_M_tb)
   $display (" tset UP_M pass ");
 else 
   $display (" test UP_M filed ");
 //######################################
 $display (" test 3 ");
 #10
 DN_MAX_tb = 1'b0;
 UP_Max_tb = 1'b1;
 #30
 if (!UP_M_tb && DN_M_tb)
   $display (" tset DN_M pass ");
 else
   $display (" tset DN_M filed ");
 //######################################
 $display (" test 4 ");
 #41
 RST_tb = 1'b0;
 #10
 if (!UP_M_tb && !DN_M_tb)
     $display (" test RST pass ");
   else
     $display (" test RST filed ");
 #20
 $finish;
 end
 endmodule
   