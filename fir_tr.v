module FIR_FILTER(clk, reset, Load_x, x_in, c_in, y_out);

// Parameters
parameter W1 = 9;   // Input bit width
parameter W2 = 18;  // Multiplier bit width = 2*W1
parameter W3 = 19;  // Adder width = W2 + log2(L) - 1
parameter W4 = 11;  // Output bit width
parameter L  = 4;   // Filter length

// Ports
input clk;          // System clock
input reset;        // Asynchronous reset
input Load_x;       // Load/run switch

input signed [W1-1:0] x_in;   // System input
input signed [W1-1:0] c_in;   // Coefficient input

output signed [W4-1:0] y_out; // System output

// Internal registers
reg signed [W3-1:0] a [0:3];  // Adder array (4 stages)
reg signed [W1-1:0] c [0:3];  // Coefficient registers
reg signed [W1-1:0] x;        // Input register

// Internal wires
wire signed [W2-1:0] p [0:3]; // Product terms

//--------------------------------------
// Load block (input & coefficients)
//--------------------------------------
always @(posedge clk or posedge reset)
begin : Load
    integer k;

    if (reset) begin
        // Asynchronous clear
        for (k = 0; k <= L-1; k = k + 1)
            c[k] <= 0;

        x <= 0;
    end
    else if (!Load_x) begin
        // Load coefficients (shift register style)
        c[3] <= c_in;
        c[2] <= c[3];
        c[1] <= c[2];
        c[0] <= c[1];
    end
    else begin
        // Normal operation: load input sample
        x <= x_in;
    end
end

//--------------------------------------
// Sum-of-products (Transposed form)
//--------------------------------------
always @(posedge clk or posedge reset)
begin : SOP
    integer k;

    if (reset) begin
        for (k = 0; k <= 3; k = k + 1)
            a[k] <= 0;
    end
    else begin
        a[0] <= p[0] + a[1];
        a[1] <= p[1] + a[2];
        a[2] <= p[2] + a[3];
        a[3] <= p[3];
    end
end

//--------------------------------------
// Output assignment
//--------------------------------------
wire signed [W3-1:0] y;
assign y = a[0];

// Truncate to output width
assign y_out = y[W3-1 : W3-W4];

//--------------------------------------
// Multiplier generate block
//--------------------------------------
genvar i;

generate
    for (i = 0; i < L; i = i + 1)
    begin : MulGen
        assign p[i] = x * c[i];
    end
endgenerate

endmodule