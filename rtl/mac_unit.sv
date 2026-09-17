module mac_unit (
    input  logic               clk,
    input  logic               reset_n,
    input  logic               valid_in,
    input  logic signed [7:0]  a,
    input  logic signed [7:0]  b,

    output logic signed [15:0] product,
    output logic               valid_out
);

    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            product   <= '0;
            valid_out <= 1'b0;
        end
        else begin
            valid_out <= valid_in;

            if (valid_in) begin
                product <= a * b;
            end
        end
    end

endmodule