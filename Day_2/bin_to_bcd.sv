module bin_to_bcd (
    input  logic [63:0] bin,
    output logic [3:0]  bcd [0:18],
    output logic [4:0]  digit_count
);

    logic [63:0] bin_shift;
    logic [3:0]  bcd_next [0:18];
    integer i, d;

    always_comb begin
        // init
        bin_shift   = bin;
        digit_count = 0;

        for (d = 0; d < 19; d++)
            bcd[d] = 4'd0;

        // double dabble
        for (i = 0; i < 64; i++) begin

            // add-3
            for (d = 0; d < 19; d++)
                bcd_next[d] = (bcd[d] >= 5) ? (bcd[d] + 3) : bcd[d];

            // shift
            for (d = 18; d > 0; d--)
                bcd[d] = {bcd_next[d][2:0], bcd_next[d-1][3]};

            bcd[0] = {bcd_next[0][2:0], bin_shift[63]};

            bin_shift = bin_shift << 1;
        end

        // digit count
        for (d = 0; d < 19; d++) begin
            if (bcd[d] != 0)
                digit_count = d + 1;
        end
    end
endmodule
