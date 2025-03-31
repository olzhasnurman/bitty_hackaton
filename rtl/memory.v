module memory(
    input clk,
    input [7:0] addr,

    output reg [15:0] out
);
    reg [15:0] memory_array [0:255]; //256 instructions each wtih 16 bits
    initial begin
        $readmemh("instructions.txt", memory_array);
    end

    always @(posedge clk) begin
        out <= memory_array[addr];
    end
endmodule



