// ----------------------------------------------------
// Module: signal_gpu_top_16
// Description: Upgraded 128-bit Master Wrapper for 
// the 16x16 Analog Edge Accelerator.
// ----------------------------------------------------
module signal_gpu_top_16 (
    input wire rst_n,
    
    // Front-End: 128-bit Bus (Carries 16 x 8-bit Channels)
    input wire [127:0] ch_in_bus, 
    input wire req_in,
    output wire ack_out,

    // Back-End: 128-bit Processed Output Bus
    output wire [127:0] ch_out_bus,
    output wire req_out,
    input wire ack_in
);

    wire [127:0] routed_signals;
    wire router_req;
    wire router_ack;
    wire [127:0] math_out_bus;

    // 1. THE 128-BIT INPUT ROUTER
    async_pipeline_stage #(128) input_router (
        .rst_n(rst_n),
        .data_in(ch_in_bus), 
        .req_in(req_in),
        .ack_out(ack_out),
        .data_out(routed_signals),
        .req_out(router_req),
        .ack_in(router_ack)
    );

    // 2. THE 16x16 ANALOG EXECUTION CORE
    // We slice the 128-bit bus into 16 individual 8-bit wires 
    // to feed the physical memristor rows.
    analog_crossbar_16x16 #(8) math_core (
        .v_in_15(routed_signals[127:120]), .v_in_14(routed_signals[119:112]),
        .v_in_13(routed_signals[111:104]), .v_in_12(routed_signals[103:96]),
        .v_in_11(routed_signals[95:88]),   .v_in_10(routed_signals[87:80]),
        .v_in_9(routed_signals[79:72]),    .v_in_8(routed_signals[71:64]),
        .v_in_7(routed_signals[63:56]),    .v_in_6(routed_signals[55:48]),
        .v_in_5(routed_signals[47:40]),    .v_in_4(routed_signals[39:32]),
        .v_in_3(routed_signals[31:24]),    .v_in_2(routed_signals[23:16]),
        .v_in_1(routed_signals[15:8]),     .v_in_0(routed_signals[7:0]),

        .i_out_15(math_out_bus[127:120]), .i_out_14(math_out_bus[119:112]),
        .i_out_13(math_out_bus[111:104]), .i_out_12(math_out_bus[103:96]),
        .i_out_11(math_out_bus[95:88]),   .i_out_10(math_out_bus[87:80]),
        .i_out_9(math_out_bus[79:72]),    .i_out_8(math_out_bus[71:64]),
        .i_out_7(math_out_bus[63:56]),    .i_out_6(math_out_bus[55:48]),
        .i_out_5(math_out_bus[47:40]),    .i_out_4(math_out_bus[39:32]),
        .i_out_3(math_out_bus[31:24]),    .i_out_2(math_out_bus[23:16]),
        .i_out_1(math_out_bus[15:8]),     .i_out_0(math_out_bus[7:0])
    );

    // 3. THE 128-BIT OUTPUT LATCH
    async_pipeline_stage #(128) output_latch (
        .rst_n(rst_n),
        .data_in(math_out_bus),
        .req_in(router_req),
        .ack_out(router_ack),
        .data_out(ch_out_bus),
        .req_out(req_out),
        .ack_in(ack_in)
    );

endmodule