module Automatic_Garag_Door_Controller (
  input wire UP_Max ,
  input wire DN_MAX ,
  input wire Activate,
  input wire CLK ,
  input wire RST ,
  output reg UP_M ,
  output reg DN_M
  );
  
  localparam [1:0]
  IDLE = 2'b00, // UP_M =0 , DN_M =0
  Mv_Up = 2'b01,// UP_M =1 , DN_M =0
  Mv_Dn = 2'b11;// UP_M =0 , DN_M =1
  
  
  reg [1:0] current_state , next_state;
  
  //########### state Transition ######################
  
  always @(posedge CLK or negedge RST)
  begin 
    if (!RST)
      current_state <=IDLE;
    else
      current_state <= next_state;
    end
    
  //############# next state logic ################
  
  always @(*)
  case (current_state)
  IDLE : begin
    if (!Activate)
      begin
        next_state = IDLE;
      end
    else 
      begin
        if ( DN_MAX && !UP_Max )
          next_state = Mv_Up;
        else
          next_state = Mv_Dn;
        end
      end

Mv_Up : begin
  if ( UP_Max )
    next_state = IDLE;
  else
    next_state = Mv_Up;
  end

Mv_Dn : begin 
  if ( DN_MAX )
    next_state = IDLE;
  else
    next_state = Mv_Dn;
  end
  default :   next_state = IDLE ;
  endcase

//#################################################

always @(*)
case (current_state )
  IDLE : begin
    UP_M =1'b0;
    DN_M =1'b0;
  end
  
Mv_Up : begin
  UP_M =1'b1;
  DN_M =1'b0;
end

Mv_Dn : begin
  UP_M =1'b0;
  DN_M =1'b1;
end

default :  
begin
 UP_M =1'b0;
 DN_M =1'b0;
 end
 
endcase
endmodule        
        