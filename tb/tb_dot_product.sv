`timescale 1ns/1ps

module tb_dot_product;

    logic clk;
    logic reset_n;
    logic start;

    logic signed [7:0] x0, x1, x2, x3;
    logic signed [7:0] w0, w1, w2, w3;

    logic signed [17:0] result;
    logic done;

    dot_product dut (
        .clk     (clk),
        .reset_n (reset_n),
        .start   (start),

        .x0 (x0),
        .x1 (x1),
        .x2 (x2),
        .x3 (x3),

        .w0 (w0),
        .w1 (w1),
        .w2 (w2),
        .w3 (w3),

        .result (result),
        .done   (done)
    );

    always #5 clk = ~clk;

    initial begin
        clk     = 0;
        reset_n = 0;
        start   = 0;

        x0 = 2;
        x1 = 3;
        x2 = 4;
        x3 = 5;

        w0 = 1;
        w1 = 2;
        w2 = 3;
        w3 = 4;

        #20;
        reset_n = 1;

        @(negedge clk);
        start = 1;

        @(negedge clk);
        start = 0;

        wait(done);

        #1;

        // 2*1 + 3*2 + 4*3 + 5*4
        // = 2 + 6 + 12 + 20
        // = 40

        if (result === 40)
            $display("PASS: dot product = %0d", result);
        else
            $display("FAIL: expected 40, got %0d", result);

        #20;
        $finish;
    end

endmodule