module gift_shop (
    input  logic        clk,
    input  logic        resetn,
    input  logic [63:0] id,
    output logic [63:0] invalid_sum
);

    // Stage 0: input register
    logic [63:0] s0_id;

    // Stage 1: Binary → BCD
    logic [3:0] s1_bcd [0:18];
    logic [4:0] s1_digits;
    logic [63:0] s1_id;

    bin_to_bcd b2b (
        .bin(s1_id),
        .bcd(s1_bcd),
        .digit_count(s1_digits)
    );

    // Stage 2: detect INVALID using factors of digit_count
    logic s2_invalid;
    logic match;
    logic [63:0] s2_id;
    logic [2:0] s2_factors [0:2];
    logic [4:0] s2_digits;
    logic [3:0] s2_bcd [0:18];

  // Factorization of digit_count
    factorization factor(
        .digit_count(s2_digits),
        .factors(s2_factors)
    );

    // COMBINATIONAL LOGIC
    always_comb begin
        match = 1'b0;
        s2_invalid = 1'b0;
        for (int i = 0; i < 3; i++) begin
            if (s2_factors[i] != 0) begin
                match = 1'b1;
                for (int j = 0; j < 19; j++) begin
                        if (j < s2_digits && j + s2_factors[i] < s2_digits) begin
                            if (s2_bcd[j] != s2_bcd[j + s2_factors[i]]) match = 1'b0;
                        end
                    end
                end
                if (match) s2_invalid = 1'b1;
            end
        end

    // Stage 3: accumulate INVALID numbers
    logic [63:0] sum;
    logic s3_invalid;
    logic [63:0] s3_id;

    always_ff @(posedge clk) begin
        if (!resetn) begin
            s0_id      <= 0;
            s1_id      <= 0;
            s2_id      <= 0; s2_digits <= 0;
            s3_invalid <= 0;
            sum        <= 0;
        end else begin
            s0_id      <= id;
            
            s1_id      <= s0_id;

            s2_id      <= s1_id;
            s2_digits  <= s1_digits;
            s2_bcd     <= s1_bcd;

            s3_invalid <= s2_invalid;
            s3_id      <= s2_id;   

            if (s3_invalid)
                sum <= sum + s3_id;     
        end
    end

    assign invalid_sum = sum;

endmodule
