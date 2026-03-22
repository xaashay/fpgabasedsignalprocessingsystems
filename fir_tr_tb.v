module fir_df1_tb();

// Inputs
reg clk;
reg reset;
reg Load_x;
reg [8:0] x_in;
reg [8:0] c_in;

// Outputs
wire [10:0] y_out;

// Instantiate the Unit Under Test (UUT)
FIR_FILTER uut (
    .clk(clk),
    .reset(reset),
    .Load_x(Load_x),
    .x_in(x_in),
    .c_in(c_in),
    .y_out(y_out)
);

//--------------------------------------
// Initialize Inputs
//--------------------------------------
initial begin
    clk = 0;
    reset = 0;
    Load_x = 1;
    x_in = 0;
    c_in = 0;
end

//--------------------------------------
// Stimulus + Monitoring
//--------------------------------------
initial begin
    $display("Time\tx_in\tc_in\ty_out");
    $monitor("%0t\t%d\t%d\t%d", $time, x_in, c_in, y_out);

    #100 reset = 0; Load_x = 0; c_in = 124;
    #100 c_in = 214;
    #100 c_in = 57;
    #100 c_in = -9'd33;

    #100 Load_x = 1; c_in = 0;
         x_in = 100;

    #100 x_in = 0;
end

//--------------------------------------
// Clock generation
//--------------------------------------
always #50 clk = ~clk;

endmodule