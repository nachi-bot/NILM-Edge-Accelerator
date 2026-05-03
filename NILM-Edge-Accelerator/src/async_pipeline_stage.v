// ----------------------------------------------------
// Module: async_pipeline_stage
// Description: A single data checkpoint in our clockless NoC
// ----------------------------------------------------
module async_pipeline_stage #(
    parameter WIDTH = 8 // We are passing 8 bits of data at a time
)(
    input wire rst_n,
    
    // Left Side: From the Sender
    input wire [WIDTH-1:0] data_in,
    input wire req_in,
    output wire ack_out,
    
    // Right Side: To the Receiver
    output reg [WIDTH-1:0] data_out,
    output wire req_out,
    input wire ack_in
);

    wire enable; // The internal wire coming out of your Muller-C gate

    // 1. PLUGGING IN YOUR LEAF MODULE
    // We instantiate the muller_c module you made. 
    // We invert ack_in (~ack_in) because we only want to send data 
    // if the next stage is NOT busy.
    muller_c controller (
        .a(req_in),
        .b(~ack_in), 
        .rst_n(rst_n),
        .y(enable)
    );

    // 2. THE DATA LATCH (The Garage Door)
    always @(*) begin
        if (!rst_n) begin
            data_out = 8'b00000000;
        end else if (enable) begin
            data_out = data_in; // When the C-element says go, pass the data!
        end
    end

    // 3. PASS THE TRAFFIC SIGNALS FORWARD
    assign req_out = enable;
    assign ack_out = enable;

endmodule