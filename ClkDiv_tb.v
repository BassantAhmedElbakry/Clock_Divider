// Scale my time to nano second 
`timescale 1ns/1ns

module ClkDiv_tb #(
    parameter WIDTH_TB = 4) ();

// DUT Signals
reg  i_clk_ref_tb;
reg  i_rst_n_tb;
reg  i_clk_en_tb;
reg  [WIDTH_TB - 1 : 0] i_div_ratio_tb;
wire o_div_clk_tb;

// Parameters and variables
parameter CLK_PERIOD = 4;
integer i;

// DUT Instantiation
ClkDiv #(.WIDTH(WIDTH_TB)) DUT (
    .i_clk_ref(i_clk_ref_tb),
    .i_rst_n(i_rst_n_tb),
    .i_clk_en(i_clk_en_tb),
    .i_div_ratio(i_div_ratio_tb),
    .o_div_clk(o_div_clk_tb)
);

// Clock Generator --> 250M Hz --> Tperiod = 4 nano seconds
always #(CLK_PERIOD/2) i_clk_ref_tb = ~i_clk_ref_tb;

// Initial Block
initial begin
    
    // Save Waveform
    $dumpfile("ClkDiv.vcd");
    $dumpvars;

    // Initialization
    Initialize();

    // Reset
    Reset();  

    // Test all cases: No out at n = 0 && n = 1 
    // And from n = 2 --> n = 15 
    for (i = 0 ; i < 16 ; i = i + 1 ) begin
        Clock_Divider(i);
        #(i*CLK_PERIOD);
        #(10*CLK_PERIOD);
    end

    $stop;

end

/********************************** TASKS **********************************/

// Initialize task
task Initialize;
    begin
        i_clk_ref_tb   = 1'b0;
        i_rst_n_tb     = 1'b0;
        i_clk_en_tb    = 1'b0;
        i_div_ratio_tb =  'b0;
    end
endtask

// Reset task
task Reset;
    begin
        i_rst_n_tb = 1'b0;
        #(CLK_PERIOD)
        i_rst_n_tb = 1'b1;
        #(CLK_PERIOD);
    end
endtask

task Clock_Divider;
input [WIDTH_TB - 1 : 0] Ratio;
    begin
        i_clk_en_tb    = 1'b1;
        i_div_ratio_tb = Ratio; 
    end
endtask

    
endmodule
