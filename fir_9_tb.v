module fir_df1_9tap_tb;

// Inputs
reg clk;
reg reset;
reg [7:0] x;

// Outputs
wire [31:0] y;

// Instantiate the Unit Under Test (UUT)
fir_df1_9tap uut (
    .clk(clk),
    .reset(reset),
    .x(x),
    .y(y)
);

// Clock generator: 10ns period
always #5 clk = ~clk;

//--------------------------------------
// Task to wait N clock cycles
//--------------------------------------
task wait_cycles(input integer n);
    integer i;
    begin
        for (i = 0; i < n; i = i + 1)
            @(posedge clk);
    end
endtask

//--------------------------------------
// Stimulus
//--------------------------------------
initial begin
    $display("=== FIR Filter Testbench (Signed Inputs) ===");
    $display("Time\tInput\tOutput");

    // Enable VCD dump (optional)
    $dumpfile("fir_df1_9tap.vcd");
    $dumpvars(0, fir_df1_9tap_tb);

    // Initialize
    clk = 0;
    reset = 1;
    x = 0;

    // Reset the system
    wait_cycles(2);
    reset = 0;

    // -------- IMPULSE RESPONSE TEST --------
    $display("\n-- Impulse Response --");

    x = 8'sd1;        // Single impulse
    wait_cycles(1);

    x = 8'sd0;        // Rest zeros
    wait_cycles(20);

    // -------- STEP RESPONSE TEST --------
    $display("\n-- Step Response --");

    x = 8'sd1;        // Constant input
    wait_cycles(20);

    $stop;
end

//--------------------------------------
// Output monitor
//--------------------------------------
always @(posedge clk) begin
    $display("%4t\t%4d\t%10d", $time, x, y);
end

endmodule