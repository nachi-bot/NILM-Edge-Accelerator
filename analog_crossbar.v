// ----------------------------------------------------
// Module: analog_crossbar
// Description: Behavioral model of a 2x2 analog 
// matrix multiplier using Ohm's Law (I = V * G)
// ----------------------------------------------------
module analog_crossbar #(
    parameter WIDTH = 8 // 8-bit digital inputs/outputs
)(
    input wire [WIDTH-1:0] v_in_0, // Input Voltage 0
    input wire [WIDTH-1:0] v_in_1, // Input Voltage 1
    output reg [WIDTH-1:0] i_out_0, // Output Current 0
    output reg [WIDTH-1:0] i_out_1  // Output Current 1
);

    // 1. THE MEMRISTOR WEIGHTS (G)
    // In a real chip, these are physical resistor values. 
    // We will hardcode a simple 2x2 matrix for this test.
    integer G_00 = 2;  integer G_01 = 1;
    integer G_10 = 1;  integer G_11 = 3;

    // 2. INTERNAL HIGH-PRECISION MATH
    integer raw_i_0, raw_i_1;

    // 3. THE ANALOG BEHAVIOR
    always @(*) begin
        // Ohm's Law Matrix Math instantly calculates the raw values
        raw_i_0 = (v_in_0 * G_00) + (v_in_1 * G_10);
        raw_i_1 = (v_in_0 * G_01) + (v_in_1 * G_11);

        // --- THE "ANALOG HACK" (Simulated Noise) ---
        // Analog math is never 100% precise. To simulate the physical 
        // inaccuracies of hardware, we intentionally chop off the lowest 
        // bit of the result (simulating noise floor precision loss).
        
        i_out_0 = raw_i_0[WIDTH-1:0] & 8'b11111110; 
        i_out_1 = raw_i_1[WIDTH-1:0] & 8'b11111110;
    end

endmodule