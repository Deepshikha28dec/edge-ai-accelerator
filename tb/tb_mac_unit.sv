`timescale 1ns/1ps

module tb_mac_unit;

    logic clk;
    logic reset_n;
    logic clear_acc;
    logic valid_in;

    logic signed [7:0] a;
    logic signed [7:0] b;

    logic signed [17:0] acc;
    logic valid_out;

    mac_unit dut (
        .clk       (clk),
        .reset_n   (reset_n),
        .clear_acc (clear_acc),
        .valid_in  (valid_in),
        .a         (a),
        .b         (b),
        .acc       (acc),
        .valid_out (valid_out)
    );

    always #5 clk = ~clk;

    initial begin
        clk       = 0;
        reset_n   = 0;
        clear_acc = 0;
        valid_in  = 0;
        a         = 0;
        b         = 0;

        #20;
        reset_n = 1;

        @(negedge clk);
        clear_acc = 1;

        @(negedge clk);
        clear_acc = 0;

        // 2 * 3 = 6
        a        = 2;
        b        = 3;
        valid_in = 1;

        @(negedge clk);

        // 4 * 5 = 20
        a = 4;
        b = 5;

        @(negedge clk);

        // -2 * 6 = -12
        a = -2;
        b = 6;

        @(negedge clk);

        valid_in = 0;

        @(posedge clk);
        #1;

        // Expected:
        // 6 + 20 - 12 = 14
        if (acc === 14)
            $display("PASS: MAC result = %0d", acc);
        else
            $display("FAIL: expected 14, got %0d", acc);

        #20;
        $finish;
    end

endmodule