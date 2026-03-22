module iir3 #(parameter W = 14)(
    input clk,                          // System clock
    input reset,                        // Asynchronous reset
    input signed [W:0] x_in,            // System input
    output signed [W:0] y_out           // System output
);

// Parameter

// Internal registers
reg signed [W:0] x, y, a, b, c;

//--------------------------------------
// Sequential logic (pipelined IIR)
//--------------------------------------
always @(posedge clk or posedge reset)
begin
    if (reset) begin
        x <= 0;
        y <= 0;
        a <= 0;
        b <= 0;
        c <= 0;
    end
    else begin
        x <= x_in;

        // Pipeline stages
        a <= x/2 + x/4;        // 3/4 x[n-1]
        b <= x + a;            // x[n-1] + 3/4 x[n-2]
        c <= y/2 + y/16;       // 9/16 y[n-1]

        y <= b + c;            // Final output
    end
end

//--------------------------------------
// Output
//--------------------------------------
assign y_out = y;

endmodule