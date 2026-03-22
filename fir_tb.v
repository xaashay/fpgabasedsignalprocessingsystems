module fir_df_tb;

// Inputs
reg clk;
reg reset;
reg [7:0] x;

// Outputs
wire [7:0] y;

// Instantiate the Unit Under Test (UUT)
fir_df uut (
    .clk(clk),
    .reset(reset),
    .x(x),
    .y(y)
);

initial begin
    // Initialize Inputs
    clk = 0;
    reset = 1;
    x = 0;

    // Wait 100 ns for global reset to finish
    #100;

    // Add stimulus here
    #100 x = 10; reset = 0;
    #100 x = 0;
end

// Clock generation
always #50 clk = ~clk;

// Monitor outputs
initial begin
    $display("Time\tx\ty");
    $monitor("%0t\t%d\t%d", $time, x, y);
end

endmodule