// ----------------------------------------------------
// Module: signal_gpu_top
// Description: The master wrapper for the Asynchronous 
// Analog-Compute Edge Accelerator.
// ----------------------------------------------------
module signal_gpu_top (
    input wire rst_n,
    
    // Front-End: Raw Electrical Signal Inputs (NILM Channels)
    input wire [7:0] ch_a_in,
    input wire [7:0] ch_b_in,
    input wire req_in,
    output wire ack_out,

    // Back-End: Processed Classification Outputs
    output wire [7:0] ch_a_out,
    output wire [7:0] ch_b_out,
    output wire req_out,
    input wire ack_in
);

    // INTERNAL WIRES (The copper traces connecting our blocks)
    wire [15:0] routed_signals; // Carries both 8-bit channels
    wire router_req;
    wire router_ack;
    wire [7:0] math_out_0;
    wire [7:0] math_out_1;

    // 1. THE INPUT ROUTER
    // We use your async pipeline stage. We set the parameter to 16 bits 
    // so it can carry both Channel A and Channel B simultaneously.
    async_pipeline_stage #(16) input_router (
        .rst_n(rst_n),
        .data_in({ch_a_in, ch_b_in}), // Concatenate both 8-bit signals
        .req_in(req_in),
        .ack_out(ack_out),
        .data_out(routed_signals),
        .req_out(router_req),
        .ack_in(router_ack) // Handshake directly with the output latch
    );

    // 2. THE ANALOG EXECUTION CORE
    // The router delivers the signal packets directly into the math matrix.
    analog_crossbar #(8) math_core (
        .v_in_0(routed_signals[15:8]), // Split the 16-bit bus back into two
        .v_in_1(routed_signals[7:0]),
        .i_out_0(math_out_0),
        .i_out_1(math_out_1)
    );

    // 3. THE OUTPUT LATCH
    // Catches the noisy analog math result and safely holds it 
    // until the outside world is ready to read it.
    async_pipeline_stage #(16) output_latch (
        .rst_n(rst_n),
        .data_in({math_out_0, math_out_1}),
        .req_in(router_req),
        .ack_out(router_ack),
        .data_out({ch_a_out, ch_b_out}),
        .req_out(req_out),
        .ack_in(ack_in)
    );

endmodule