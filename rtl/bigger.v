/* verilator lint_off MODDUP */
module bigger(
    input clk,
    /* verilator lint_off SYNCASYNCNET */
    input reset,
    input run,

    output done,
    output [15:0] instr,
    output [15:0] d_out
);
 
    parameter S0 = 4'b0000;
    parameter S1 = 4'b0001;
    parameter S2 = 4'b0010;
    parameter S3 = 4'b0011;
    parameter S4 = 4'b0100;
    parameter S5 = 4'b0101;
    parameter S6 = 4'b0110;
    parameter S7 = 4'b0111;
    parameter S8 = 4'b1000;
    parameter S9 = 4'b1001;

    reg [3:0] cur_state, next_state;

    reg run_bitty;
    wire [15:0] mem_out;
    wire [7:0] addr;
    wire [7:0] new_pc;

    branch_logic instance4(
        .address(addr),
        .instruction(mem_out),
        .last_alu_result(d_out),
        .new_pc(new_pc)
    );

    pc instance1(
        .clk(clk),
        .en_pc(done),
        .reset(reset),
        .d_in(new_pc),
        .d_out(addr)
    );

    memory instance2(
        .clk(clk),
        .addr(addr),
        .out(mem_out)
    );




    always @(*) begin
        case (cur_state)
            S0: begin
                run_bitty = 0;
            end 
            S3:  run_bitty = 1;
            default: run_bitty = 0;
        endcase
    end
    

    always @(posedge clk) begin
        if(run) begin
            cur_state <= next_state;
        end
        if(reset) begin
            cur_state<= S0;
        end
    end

    always @(*) begin
        case(cur_state)
            S0: next_state = S1;
            S1: next_state = S2;
            S2: next_state = S3;
            S3: next_state = (done==1) ? S0:S3;
            default: next_state = S0;
        endcase
    end


    bitty instance3(
        .clk(clk),
        .reset(reset),
        .run(run_bitty),
        .d_instr(mem_out),
        .done(done),
        .d_out(d_out)
    );

    assign instr = mem_out;

  

endmodule
