module tb_analog_crossbar;

    reg [7:0] v_in_0;
    reg [7:0] v_in_1;
    
    wire [7:0] i_out_0;
    wire [7:0] i_out_1;

    // Plug in our analog matrix core
    analog_crossbar #(8) my_matrix (
        .v_in_0(v_in_0),
        .v_in_1(v_in_1),
        .i_out_0(i_out_0),
        .i_out_1(i_out_1)
    );

    initial begin
        $dumpfile("analog_wave.vcd");
        $dumpvars(0, tb_analog_crossbar);

        // Test 1: Inject small voltages
        // Expected math without noise: 
        // I0 = (10*2) + (5*1) = 25. 
        // I1 = (10*1) + (5*3) = 25.
        v_in_0 = 8'd10; // 'd' means decimal format
        v_in_1 = 8'd5;
        #20;

        // Test 2: Inject higher voltages
        v_in_0 = 8'd20;
        v_in_1 = 8'd15;
        #20;

        $finish;
    end
endmodule