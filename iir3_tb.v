module iir3_tb();

// Inputs
reg clk;
reg reset;
reg [14:0] x_in;

// Outputs
wire [14:0] y_out;

// Instantiate the Unit Under Test (UUT)
iir2 uut (
    .clk(clk),
    .reset(reset),
    .x_in(x_in),
    .y_out(y_out)
);

//--------------------------------------
// Initialize Inputs + Stimulus
//--------------------------------------
initial begin
    // Initialize Inputs
    clk = 0;
    reset = 1;
    x_in = 0;

    // Wait 10 ns for global reset to finish
    #10;

    // Add stimulus here

    // -------- Impulse response --------
    #10 x_in = 0;    reset = 1;
    #10 x_in = 1000; reset = 0;
    #10 x_in = 0;

    // -------- Step response (commented in original) --------
    // #10 x_in = 0; reset = 1;
    // #10 x_in = 100; reset = 0;
end

//--------------------------------------
// Clock generation
//--------------------------------------
always #10 clk = ~clk;

//--------------------------------------
// Monitor outputs
//--------------------------------------
initial begin
    $display("Time\tx_in\ty_out");
    $monitor("%0t\t%d\t%d", $time, x_in, y_out);
end

endmodule