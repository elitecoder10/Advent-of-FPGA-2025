module gift_shop (
    input  logic        clk,
    input  logic        resetn,
    input  logic [63:0] id,
    output logic [63:0] invalid_sum
);

    // Stage 0: input register
    logic [63:0] s0_id;

    // Stage 1: Binary → BCD
    logic [3:0]  s1_bcd [0:18];
    logic [4:0]  s1_digits;
    logic [63:0] s1_id;

    bin_to_bcd b2b (
        .bin(s1_id),
        .bcd(s1_bcd),
        .digit_count(s1_digits)
    );

    // Stage 2: detect INVALID (exactly two repeating blocks)
    logic s2_invalid;
    logic [63:0] s2_id;
    logic [4:0]  s2_digits;
    logic [3:0]  s2_bcd [0:18];

    // COMBINATIONAL LOGIC
    always_comb begin
    s2_invalid = 1'b0;

    if ((s2_digits != 0) && (s2_digits[0] == 1'b0)) begin
        s2_invalid = 1'b1;

        for (int i = 0; i < 9; i++) begin
            if (i < (s2_digits >> 1)) begin
                if (s2_bcd[i] != s2_bcd[i + (s2_digits >> 1)])
                    s2_invalid = 1'b0;
            end
        end
    end
end

  // Stage 3: accumulate INVALID numbers (SEQUENTIAL PIPELINED LOGIC)
    logic [63:0] sum;
    logic s3_invalid;
    logic [63:0] s3_id;

    always_ff @(posedge clk) begin
        if (!resetn) begin
            s0_id      <= 0;
            s1_id      <= 0;
            s2_id      <= 0; s2_digits <= 0;
            s3_invalid <= 0; s3_id <= 0;
            sum        <= 0;
        end else begin
            s0_id      <= id;

            s1_id      <= s0_id;

            s2_id      <= s1_id;
            s2_bcd     <= s1_bcd;
            s2_digits  <= s1_digits;

            s3_invalid <= s2_invalid;
            s3_id      <= s2_id; 

            if (s3_invalid)
                sum <= sum + s3_id;     
        end
    end

    assign invalid_sum = sum;

endmodule
