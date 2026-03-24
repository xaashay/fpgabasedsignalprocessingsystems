
module fir_df1_9tap (
    input clk,                     // System clock
    input reset,                   // Asynchronous reset
    input signed [7:0] x,          // Input
    output reg signed [31:0] y     // Output
);

// Scaled coefficients (×10000)
reg signed [15:0] coeff [0:8];

// Coefficient assignments
initial begin
    coeff[0] = -222;
    coeff[1] = -1037;
    coeff[2] = 225;
    coeff[3] = 3175;
    coeff[4] = 4775;
    coeff[5] = 3175;
    coeff[6] = 225;
    coeff[7] = -1037;
    coeff[8] = -222;
end
// Delay line
reg signed [7:0] tap [0:8];

integer i;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Asynchronous clear
        for (i = 0; i <= 8; i = i + 1)
            tap[i] <= 0;

        y <= 0;
    end
    else begin
        // Shift delay line
        for (i = 8; i > 0; i = i - 1)
            tap[i] <= tap[i-1];

        tap[0] <= x;

        // FIR output (convolution sum)
        y <= coeff[0]*tap[0] +
             coeff[1]*tap[1] +
             coeff[2]*tap[2] +
             coeff[3]*tap[3] +
             coeff[4]*tap[4] +
             coeff[5]*tap[5] +
             coeff[6]*tap[6] +
             coeff[7]*tap[7] +
             coeff[8]*tap[8];
    end
end

endmodule
