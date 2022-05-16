`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Harry
// 
// Create Date: 05/13/2022 08:30:14 AM
// Design Name: 
// Module Name: AdpLogic
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module AdpLogic(
    input wire clk,
    input wire Adp_pulse,
    input wire [15:0] Quench_T,
    input wire [15:0] Wait_T,
    input [15:0] Reset_T,
    output reg Quench,
    output reg Reset,
    output reg [31:0] NoP
    );

reg [1:0] state = 2'd0;
reg [15:0] counter;
reg Adp_On = 1'b0;

parameter S0 = 2'd0, S1 = 2'd1, S2 = 2'd2, S3 = 2'd3;

always @ (posedge Adp_pulse)
    Adp_On = 1'b1;

always @ (state) 
begin
    case (state)
        S1:begin
           Quench = 1'b1;
           Reset = 1'b0;
           end
        S2:begin
           Quench = 1'b0;
           Reset = 1'b0;
           end
        S3:begin
           Quench = 1'b0;
           Reset = 1'b1;
           end
        default:begin
           Quench = 1'b0;
           Reset = 1'b0;
           end
    endcase
end

always @ (posedge clk) 
begin
    //if (reset)
    //    state <= S0;
    //else
    case (state)
       S1:
       begin
          if(counter >= Quench_T) 
              begin
                counter = 16'd0;
                state <= S2;
              end
          else
              counter=counter+1;
       end
       S2:
       begin
          if(counter >= Wait_T) 
              begin
                counter = 16'd0;
                state <= S3;
              end
          else
              counter=counter+1;
       end
       S3:
       begin
          if(counter >= Reset_T) 
              begin
                counter = 16'd0;
                state <= S0;
              end
          else
              counter=counter+1;
       end
       default:
       begin
          if(Adp_On) 
              begin
                Adp_On = 1'b0;
                counter = 16'd0;
                state <= S1;
              end
          else
              state <= S0;
       end
    endcase
end

endmodule
