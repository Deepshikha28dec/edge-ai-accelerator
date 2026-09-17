`timescale 1ns/1ps

module tb_mac_unit;

    logic clk;
    logic reset_n;
    logic valid_in;

    logic signed [7:0] a;
    logic signed [7:0] b;

    logic signed [15:0] product;
    logic valid_out;

    // DUT = Device Under Test
    mac_unit dut (
        .clk       (clk),
        .reset_n   (reset_n),
        .valid_in  (valid_in),
        .a         (a),
        .b         (b),
        .product   (product),
        .valid_out (valid_out)
    );

    // 10 ns clock period = 100 MHz
    always #5 clk = ~clk;

    initial begin
        // Initial values
        clk      = 0;
        reset_n  = 0;
        valid_in = 0;
        a        = 0;
        b        = 0;

        // Hold reset for a few clock cycles
        #20;
        reset_n = 1;

        // Test 1: 10 * -3 = -30
        @(negedge clk);
        a        = 10;
        b        = -3;
        valid_in = 1;

        @(negedge clk);
        valid_in = 0;

        // Wait for output
        @(posedge clk);

        if (valid_out) begin
            if (product === -30)
                $display("PASS: 10 * -3 = %0d", product);
            else
                $display("FAIL: expected -30, got %0d", product);
        end
        else begin
            $display("FAIL: valid_out was not asserted");
        end

        #20;
        $finish;
    end

endmodule