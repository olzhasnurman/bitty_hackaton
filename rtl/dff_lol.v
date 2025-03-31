module dff_lol(
    input clk,
    input en,
    input wire [15:0] d_in,
    input [15:0] starting,
    input reset,

    output reg [15:0] mux_out

);

    always @(posedge clk) begin
        if (reset) begin
            mux_out <= starting;
        end
        else if(en) begin
            mux_out <= d_in;
        end
    end
	 
endmodule