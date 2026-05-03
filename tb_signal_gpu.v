module tb_signal_gpu;

    reg rst_n;
    reg [7:0] ch_a_in;
    reg [7:0] ch_b_in;
    reg req_in, ack_in;

    wire [7:0] ch_a_out;
    wire [7:0] ch_b_out;
    wire req_out, ack_out;

    // Plug in the master chip
    signal_gpu_top my_asic (
        .rst_n(rst_n),
        .ch_a_in(ch_a_in), .ch_b_in(ch_b_in),
        .req_in(req_in), .ack_out(ack_out),
        .ch_a_out(ch_a_out), .ch_b_out(ch_b_out),
        .req_out(req_out), .ack_in(ack_in)
    );

    initial begin
        $dumpfile("master_wave.vcd");
        $dumpvars(0, tb_signal_gpu);

        // 1. Boot up the chip
        rst_n = 0; req_in = 0; ack_in = 0; 
        ch_a_in = 0; ch_b_in = 0;
        #10; rst_n = 1; #10;

        // 2. SIMULATE A NILM EVENT (Motor Startup Transient)
        // Injecting Voltage A=10, Voltage B=5 into the front pins
        ch_a_in = 8'd10; 
        ch_b_in = 8'd5;
        
        // 3. Trigger the Asynchronous Handshake
        req_in = 1;  // Sensor says "I have data!"
        #10;
        
        ack_in = 1;  // Output processor says "I am ready to read it!"
        #10;

        req_in = 0;  // Clear pipeline
        ack_in = 0;
        #20;

        $finish;
    end
endmodule