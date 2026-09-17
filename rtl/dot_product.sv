module dot_product (
    input  logic               clk,
    input  logic               reset_n,
    input  logic               start,

    input  logic signed [7:0]  x0,
    input  logic signed [7:0]  x1,
    input  logic signed [7:0]  x2,
    input  logic signed [7:0]  x3,

    input  logic signed [7:0]  w0,
    input  logic signed [7:0]  w1,
    input  logic signed [7:0]  w2,
    input  logic signed [7:0]  w3,

    output logic signed [17:0] result,
    output logic               done
);

    logic [2:0] index;
    logic       running;

    logic signed [7:0] mac_a;
    logic signed [7:0] mac_b;

    logic signed [17:0] mac_acc;

    logic mac_valid;
    logic clear_acc;

    // ----------------------------------------------------
    // Select input pair according to current MAC operation
    // ----------------------------------------------------
    always_comb begin
        case (index)
            3'd0: begin
                mac_a = x0;
                mac_b = w0;
            end

            3'd1: begin
                mac_a = x1;
                mac_b = w1;
            end

            3'd2: begin
                mac_a = x2;
                mac_b = w2;
            end

            3'd3: begin
                mac_a = x3;
                mac_b = w3;
            end

            default: begin
                mac_a = '0;
                mac_b = '0;
            end
        endcase
    end

    // MAC operates whenever accelerator is running
    assign mac_valid = running;

    // Clear accumulator immediately when a new operation starts
    assign clear_acc = start && !running;

    mac_unit u_mac (
        .clk       (clk),
        .reset_n   (reset_n),
        .clear_acc (clear_acc),
        .valid_in  (mac_valid),
        .a         (mac_a),
        .b         (mac_b),
        .acc       (mac_acc),
        .valid_out ()
    );

    // ----------------------------------------------------
    // Controller
    // ----------------------------------------------------
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            index   <= 3'd0;
            running <= 1'b0;
            result  <= '0;
            done    <= 1'b0;
        end
        else begin
            done <= 1'b0;

            // Start new dot product
            if (start && !running) begin
                index   <= 3'd0;
                running <= 1'b1;
            end

            // Process four MAC operations
            else if (running) begin
                if (index == 3'd3) begin
                    running <= 1'b0;
                    index   <= 3'd4;
                end
                else begin
                    index <= index + 1'b1;
                end
            end

            // MAC result is now stable
            else if (index == 3'd4) begin
                result <= mac_acc;
                done   <= 1'b1;
                index  <= 3'd5;
            end
        end
    end

endmodule