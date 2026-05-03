// This is the testbench. It generates fake signals to test our gate.
module tb_muller_c;

    // 'reg' is used for inputs we want to control (like flipping a switch)
    reg a_test;
    reg b_test;
    reg rst_n_test;

    // 'wire' is used for outputs we just want to look at
    wire y_out;

    // Here we "plug in" our muller_c module to these test wires
    muller_c my_gate (
        .a(a_test),
        .b(b_test),
        .rst_n(rst_n_test),
        .y(y_out)
    );

    // This block tells the simulator exactly what to do step-by-step
    initial begin
        // 1. Tell the simulator to record the waveforms into a file
        $dumpfile("waveforms.vcd");
        $dumpvars(0, tb_muller_c);

        // 2. Start the test: Hold reset low, everything off.
        rst_n_test = 0; a_test = 0; b_test = 0; 
        #10; // Wait 10 nanoseconds

        // 3. Turn reset off (system is active)
        rst_n_test = 1; 
        #10; 

        // 4. Send a Request (a=1) and an Acknowledge (b=1)
        a_test = 1; b_test = 1; 
        #10; // Wait and let the signal propagate. Output 'y' should go to 1.

        // 5. Drop 'a' to 0. Since 'b' is still 1, 'y' should hold its state!
        a_test = 0; b_test = 1; 
        #10; 

        // 6. Drop both to 0. The output 'y' should finally clear to 0.
        a_test = 0; b_test = 0; 
        #10; 

        // 7. End the simulation
        $finish;
    end

endmodule