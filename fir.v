module fir_df(
    input clk,
    input reset,
    input signed [7:0] x,
    output reg signed [7:0] y
);

// System clock, Asynchronous reset, System input, System output

reg signed [7:0] tap [0:3];   // 4 taps with each 8 bits wide
integer i;                    // Loop variable

always @(posedge clk or posedge reset)
begin : P1   // Behavioral Style

    // The coefficients are [-1 3.75 3.75 -1]

    if (reset) begin   // Asynchronous clear
        for (i = 0; i <= 3; i = i + 1)
            tap[i] <= 0;

        y <= 0;
    end
    else begin
        y <= -tap[0]                                   // -1
           + (tap[1] <<< 1) + tap[1] + (tap[1] >>> 1) + (tap[1] >>> 2)  // 3.75
           + (tap[2] <<< 1) + tap[2] + (tap[2] >>> 1) + (tap[2] >>> 2)  // 3.75
           - tap[3];                                  // -1

        // Tapped delay line: shift one
        for (i = 3; i > 0; i = i - 1) begin
            tap[i] <= tap[i-1];
        end

        tap[0] <= x;   // Input
    end
end

endmodule