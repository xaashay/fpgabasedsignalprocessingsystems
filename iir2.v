module iir2 #(parameter W = 14)(
    input clk,                          // System clock
    input reset,                        // Asynchronous reset
    input signed [W:0] x_in,            // System input
    output signed [W:0] y_out           // System output
);

// Parameter


// Internal registers
reg signed [W:0] x, y;

//--------------------------------------
// Sequential logic
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
        // y[n] = (7/4)x[n-1] + (9/16)y[n-1]
        y <= x + x/2 + x/4 + y/2 + y/16;
    end
end

//--------------------------------------
// Output
//--------------------------------------
assign y_out = y;

endmodule