// ----------------------------------------------------
// Module: muller_c
// Description: The fundamental memory element for 
// asynchronous clockless handshaking.
// ----------------------------------------------------
module muller_c (
    input wire a,      // Input 1 (e.g., Request from sender)
    input wire b,      // Input 2 (e.g., Acknowledge from receiver)
    input wire rst_n,  // Active-low asynchronous reset
    output reg y       // Output state
);

    always @(a or b or rst_n) begin
        if (!rst_n) begin
            y <= 1'b0; // Reset state
        end 
        else if (a == 1'b1 && b == 1'b1) begin
            y <= 1'b1; // Both ready: push data forward
        end 
        else if (a == 1'b0 && b == 1'b0) begin
            y <= 1'b0; // Both idle: clear the pipeline
        end
        // Implicit else: If inputs differ, 'y' holds its previous state.
        // This is what creates the asynchronous memory.
    end

endmodule