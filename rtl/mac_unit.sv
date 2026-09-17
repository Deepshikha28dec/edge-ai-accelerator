module mac_unit (
    input  logic               clk,
    input  logic               reset_n,
    input  logic               clear_acc,
    input  logic               valid_in,

    input  logic signed [7:0]  a,
    input  logic signed [7:0]  b,

    output logic signed [17:0] acc,
    output logic               valid_out
);

    logic signed [15:0] mult_result;

    always_comb begin
        mult_result = a * b;
    end

    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            acc       <= '0;
            valid_out <= 1'b0;
        end
        else begin
            valid_out <= valid_in;

            if (clear_acc) begin
                acc <= '0;
            end
            else if (valid_in) begin
                acc <= acc + mult_result;
            end
        end
    end

endmodule