module tb_signal_gpu_16;

    reg rst_n;
    reg [127:0] ch_in_bus;
    reg req_in, ack_in;

    wire [127:0] ch_out_bus;
    wire req_out, ack_out;

    // Plug in the massive 16-channel wrapper
    signal_gpu_top_16 my_asic (
        .rst_n(rst_n),
        .ch_in_bus(ch_in_bus),
        .req_in(req_in), .ack_out(ack_out),
        .ch_out_bus(ch_out_bus),
        .req_out(req_out), .ack_in(ack_in)
    );

    initial begin
        $dumpfile("master_wave_16.vcd");
        $dumpvars(0, tb_signal_gpu_16);

        // 1. Boot up
        rst_n = 0; req_in = 0; ack_in = 0; ch_in_bus = 0;
        #10; rst_n = 1; #10;

        // 2. SIMULATE A MASSIVE 16-CHANNEL HARMONIC SPIKE
        // We pack 16 different decimal values (frequencies) into the 128-bit bus
        ch_in_bus = {
            8'd2, 8'd4, 8'd6, 8'd8,      // Ch 15 down to Ch 12
            8'd10, 8'd12, 8'd14, 8'd16,  // Ch 11 down to Ch 8
            8'd18, 8'd20, 8'd15, 8'd10,  // Ch 7 down to Ch 4
            8'd5, 8'd3, 8'd2, 8'd1       // Ch 3 down to Ch 0
        };
        
        // 3. Trigger the Handshake
        req_in = 1;  
        #10;
        ack_in = 1;  
        #10;

        req_in = 0; ack_in = 0;
        #20;

        $finish;
    end
endmodule
