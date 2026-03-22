module iir #(parameter W = 14)(
    input clk,                          // System clock
    input reset,                        // Asynchronous reset
    input signed [W:0] x_in,            // System input
    output signed [W:0] y_out           // System output
);
// Internal registers
reg signed [W:0] x, y;

//--------------------------------------
// Sequential logic (input + recursion)
//--------------------------------------
always @(posedge clk or posedge reset)
begin
    if (reset) begin
        x <= 0;
        y <= 0;
    end
    else begin
        x <= x_in;

        // IIR equation:
        // y[n] = x[n-1] + (3/4)*y[n-1]
        y <= x + (y >>> 1) + (y >>> 2);
        // y[n] = x[n-1] + 3/4*y[n-1]; //lossy integrator
        // y <= x + y/ 'sd2 + y/'sd4; // same as /2 and /4
        // y <= x + y/2 + y/4; // div w / usese more LEs
        
    end
end

//--------------------------------------
// Output
//--------------------------------------
assign y_out = y;

endmodule