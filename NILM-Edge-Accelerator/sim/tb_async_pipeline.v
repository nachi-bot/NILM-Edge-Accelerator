module tb_async_pipeline;

    reg rst_n;
    reg [7:0] data_in;
    reg req_in;
    reg ack_in;

    wire [7:0] data_out;
    wire req_out;
    wire ack_out;

    // Plug our test wires into the new pipeline module
    async_pipeline_stage #(8) my_pipeline (
        .rst_n(rst_n),
        .data_in(data_in),
        .req_in(req_in),
        .ack_out(ack_out),
        .data_out(data_out),
        .req_out(req_out),
        .ack_in(ack_in)
    );

    initial begin
        // Output file for GTKWave
        $dumpfile("pipeline_wave.vcd");
        $dumpvars(0, tb_async_pipeline);

        // Turn on the system
        rst_n = 0; req_in = 0; ack_in = 0; data_in = 8'h00;
        #10; rst_n = 1; #10;

        // --- THE 4-PHASE HANDSHAKE ---
        
        // 1. Sender puts Hex 'AA' (10101010) on the line and Requests
        data_in = 8'hAA;
        req_in = 1; 
        #10;

        // 2. Receiver grabs it and Acknowledges
        ack_in = 1; 
        #10;

        // 3. Sender drops Request (done sending)
        req_in = 0; 
        #10;

        // 4. Receiver drops Acknowledge (ready for next data)
        ack_in = 0; 
        #10;

        $finish;
    end
endmodule